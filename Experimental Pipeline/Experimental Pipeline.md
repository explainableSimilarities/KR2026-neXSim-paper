## Experimental Pipeline

### Seeds
```text
|-----------------|-----------|
|       Seed      | Pool Size |
|-----------------|-----------|
| Company         |    157,637|
| Film            |    143,918|
| Sculpture       |    107,718|
| Actor           |     64,783|
| Vehicle         |     54,695|
| Band            |     45,698|
| Video Game      |     23,824|    
| University      |     14,854|
| Championship    |      9,840|
| Municipality    |      8,144|
| Scientist       |      6,282|
| Chemical Element|      3,586|
| Dialect         |        875|
| Amusement Park  |        802|
|-----------------|-----------|
```
### Entity pool from Seed (Query)
```Cypher
UNWIND $seeds as s
CALL {
  WITH s
  MATCH (n:Synset)-[:instance_of]->(:Synset)-[:subclass_of*0..]->(:Synset {id: s})
  RETURN n.id as entity, n.mainSense as entity_name, s as seed
  UNION
  WITH s
  MATCH (n:Synset)-[:subclass_of*1..]->(:Synset {id: s})
  RETURN n.id as entity, n.mainSense as entity_name, s as seed
  UNION
  WITH s 
  MATCH (n:Synset)-[:is_a]->(:Synset {id: s})
  RETURN n.id as entity, n.mainSense as entity_name, s as seed
}
RETURN DISTINCT entity, entity_name, seed
```
Generating a `.txt` file for each seed with the list of entities in the pool (with their name and id)

### Units of a given size

We fixed to `4000` the number of units to be evaluated for each seed/size combo. Fixing a size, the following is the python code to generate the units for a given seed (here the example for size 48):

```python
import os
import random

samples = 4000
size = 48

def sample():

    if not os.path.exists(OUTPUT_DATA_FOLDER):
        os.makedirs(OUTPUT_DATA_FOLDER)


    # read the folder 'experiment_data/by_seed' and take all the filenames
    seeds = os.listdir(INPUT_DATA_FOLDER)

    for seed in seeds:
        lines = []
        with open(os.path.join(INPUT_DATA_FOLDER, seed), 'r') as infile:
            tmp = infile.readlines()[1:]
        for line in tmp:
            lines.append(line.split(';')[0])

        m_seed = seed.replace('.txt', '')
        print('Sampling {}'.format(m_seed))

        if not os.path.exists(OUTPUT_DATA_FOLDER+f'/{m_seed}'):
            os.makedirs(OUTPUT_DATA_FOLDER+f'/{m_seed}')
        
        random.shuffle(lines)

        sampled = set()

        while len(sampled) < samples:
            indices = random.sample(range(len(lines)), size)
            _unit = tuple(sorted(indices))
            sampled.add(_unit)

        with open(os.path.join(OUTPUT_DATA_FOLDER, m_seed, f"{size}.txt"), 'w') as f:
            for index_set in sampled:
                row = ";".join(lines[x] for x in index_set)
                f.write(row + '\n')

if __name__ == '__main__':
    sample()
```

### Experimental Execution

For each experimental instance, we execute, through a `Python` script, a call to the system's API to obtain the summaries, the characterization and the kernel explanationof the entities in the unit, exploiting the `/api/oneshot` endpoint. The API also returns the computation time for each of these components, which we store in a `.csv` file for later analysis. The following is an example of how to call the API for a given unit:

```python
import requests
import json

def call_api(unit):
    url = "https://.../api/oneshot"
    payload = json.dumps({
        "unit": unit
    })
    headers = {
        'Content-Type': 'application/json'
    }
    response = requests.request("POST", url, headers=headers, data=payload)
    return response.json()
```

This json response is then parsed to extract the relevant information for our experiments, such as the summaries, characterizations, kernel explanations, and computation times. It can be validated according to the following Data Models (the `Pydantic` library is required to run this code):

```python
from enum import Enum
from typing import List, Union, Optional, Any

from pydantic import BaseModel, Field
from typing_extensions import Annotated

BABELNET_PATTERN = re.compile(r"^bn:\d{8}[nvar]$")


def is_valid_babelnet_id(candidate: str) -> bool:
    """
    Format: bn:<8-digit number><letter in {n,v,a,r}>
    """
    return bool(BABELNET_PATTERN.match(candidate))


class EntityType(str, Enum):
    CONCEPT = "CONCEPT"
    NAMED_ENTITY = "NAMED_ENTITY"


def validate_babelnet_id(v: str) -> str:
    if not is_valid_babelnet_id(v):
        raise ValueError(f"Invalid BabelNet ID: {v}")
    return v


BabelNetID = Annotated[str, validate_babelnet_id]


class Entity(BaseModel):
    id: BabelNetID
    main_sense: str
    description: str = Field(default="")
    synonyms: List[str] = Field(default_factory=list)
    entity_type: "EntityType" = Field(default="NAMED_ENTITY")  # if enum default
    image_url: str = Field(default="")

    class Config:
        frozen = True  # makes objects immutable & hashable

    @property
    def shown_name(self) -> str:
        return self.main_sense.replace("_", " ")

    def __hash__(self):
        return hash(self.id)


class EntityList(BaseModel):
    entities: List[Entity]


class Variable(BaseModel):
    origin: List[BabelNetID] = Field(default_factory=list)
    is_free: bool = False
    nominal: int = 0

    class Config:
        frozen = True

    def __eq__(self, other) -> bool:
        if not isinstance(other, Variable):
            return NotImplemented
        return str(self) == str(other)

    def __str__(self):
        return f"{'X' if self.is_free else 'Y'}_{self.nominal}"

    def __hash__(self) -> int:
        return hash(str(self))


class Atom(BaseModel):
    source_id: Union[BabelNetID, Variable]
    target_id: Union[BabelNetID, Variable]
    predicate: str

    class Config:
        frozen = True

    @staticmethod
    def _multiply_term(lhs: Union[BabelNetID, Variable], rhs: Union[BabelNetID, Variable]) \
            -> Union[BabelNetID, Variable]:

        if type(lhs) == str and type(rhs) == str and lhs == rhs:
            return lhs

        out = Variable(origin=[], is_free=False, nominal=0)

        if type(lhs) == str:
            out.origin.append(lhs)
        else:
            out.origin.extend(lhs.origin)
        if type(rhs) == str:
            out.origin.append(rhs)
        else:
            out.origin.extend(rhs.origin)

        return out

    def __eq__(self, other: Any) -> bool:
        if not isinstance(other, Atom):
            return NotImplemented
        if self.predicate != other.predicate:
            return False
        if type(self.source_id) != type(other.source_id):
            return False
        if type(self.target_id) != type(other.target_id):
            return False

        return self.source_id == other.source_id and self.target_id == other.target_id

    def multiply(self, other: "Atom") -> "Atom":
        if type(self) != type(other):
            return NotImplemented

        if self.predicate != other.predicate:
            return NotImplemented

        new_source = Atom._multiply_term(self.source_id, other.source_id)
        new_target = Atom._multiply_term(self.target_id, other.target_id)
        return Atom(source_id=new_source, target_id=new_target, predicate=self.predicate)

    def __hash__(self) -> int:
        return hash((self.source_id, self.target_id, self.predicate))


class SearchByIdResponse(BaseModel):
    entities: list[Entity]


class Summary(BaseModel):
    entity: BabelNetID
    summary: list[Atom]
    tops: list[BabelNetID]

    def __lt__(self, other):
        if type(other) is not type(self):
            raise TypeError(f"Cannot compare {type(self)} and {type(other)}")
        return len(self.summary) < len(other.summary)


class NeXSimResponse(BaseModel):
    unit: list[BabelNetID]
    summaries: Optional[list[Summary]] = None
    lca: Optional[list[Atom]] = None
    characterization: Optional[list[Atom]] = None
    tops: Optional[list[Union[BabelNetID, Variable]]] = None
    kernel_explanation: Optional[list[Atom]] = None
    computation_times: Optional[dict[str, float]] = None

```
The validation can be performed as follows:

```python
response_json = call_api(unit)
try:
    response = NeXSimResponse.model_validate(response_json)
except ValidationError as e:
    print("Validation error:", e)
```

