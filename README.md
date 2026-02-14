# KR2026-neXSim-paper

## Contents of the repository
This repository contains the materials related to our paper "neXSim: A Knowledge-Intensive System for Explaining Similarities between Concepts". The materials are organized into several folders, each containing specific components of our work. Below is a brief description of the contents of each folder and how they relate to our system and the experiments we conducted.

### Folder structure
```text
├── Cypher                    # Cypher queries used to interact with the Neo4j graph database.
├── Experimental Data         # Experimental Results for both computation times and object sizes
├── Experimental Pipeline     # A description of the experimental pipeline used to evaluate our system.
├── Datalog Programs            # Datalog programs encoding the rules for inferring least common neighbors for `is_a` and `part_of` relations
├── SKB Construction          # Translation of BabelNet relations into our system's relation names
└── System                    # System's Source Code (neXSim-v0.1-beta)
```

#### Cypher
The Cypher folder (see [the corresponding readme](./Cypher/Cypher%20Queries.md)) contains the Cypher queries used to interact with the Neo4j graph database. These queries are essential for retrieving and data from the database. In particular, one can find the queries to search entities by `id`, by `lemma`, and to compute their `summary`. Finally, with the `subgraph` queries, we retrieve the information required to compute the least common neighbors for `is_a` and `part_of` relations, which are then used in our system to obtain `Kernel Explanations`.

#### Experimental Pipeline
In the `Experimental Pipeline` folder (see [the corresponding readme](./Experimental%20Pipeline/Experimental%20Pipeline.md)) we provide a detailed description of the experimental pipeline we followed to evaluate our system. This includes the steps taken to generate our pool, to sample instances from it and the actual execution of the experiments over our system.

#### Experimental Data
The experimental data (see [the corresponding readme](./Experimental%20Data/Experimental%20Data.md)) used in our system is located in the `Experimental Data` folder. This includes the datasets and any relevant files that were used for testing and validating our system's performance.

#### Datalog Programs 
The datalog programs used in our system are located in the `Datalog Programs` folder. These programs encode the rules used to infer the least common neighbors for `is_a` and `part_of` relations. For any further details, please refer to the [Datalog Programs readme](./Datalog%20Programs/Datalog%20Programs.md).

#### System
The `System` folder contains the link to the source code of our system, neXSim-v0.1-beta, which is available on GitHub. This codebase includes all the necessary components to run our system. For more details, please refer to the [System readme](./System/System.md).

#### SKB (Selective Knowledge Base) Construction
In the (`SKB Construction` folder) we provide a textual file called `Symbol To Relation Name.txt` [(also in markdown version)](./SKB%20Construction/SKB%20Construction.md) inside of which there is the table matching the correspondence between the symbols in the BabelNet indices and the relation names we used in our SKB (`our interpretation` column). This mapping is crucial for understanding how we translated the BabelNet relations into our system.

### References
- [System's Source Code (neXSim-v0.1-beta)](https://github.com/explainableSimilarities/neXSim-v0.1-beta)
- [Online Demo](https://prode-2.alviano.net/)
