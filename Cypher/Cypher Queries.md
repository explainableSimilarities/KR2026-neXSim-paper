## Cypher Queries

Here they follow the Cypher queries used to retrieve the information from the Neo4j graph database. In particular, we provide the queries to search entities by `id`, by `lemma`, and to compute their `summary`. Finally, with the `subgraph` queries, we retrieve the information required to compute the least common neighbors for `is_a` and `part_of` relations, which are then used in our system to obtain `Kernel Explanations`.

### Search by ID

Given a list of entity `ids`, we retrieve the corresponding information with the following query:

```cypher
MATCH (x:Synset)
WHERE x.id IN $ids
RETURN x.id as id,
x.mainSense as mainSense,
x.description as description,
x.synonyms as synonyms,
x.type as type
````


### Search by Lemma

Given a lemma, we retrieve the corresponding information with the following query (template):

```cypher
CALL db.index.fulltext.queryNodes("mainSensesAndSynonyms",
apoc.text.format("{main_sense_str} OR {synonyms_str}", {params_str})) 
YIELD node, score WITH node, score 
ORDER BY score * node.undirected_edges DESC
RETURN node.id as id, 
node.mainSense as mainSense,
node.description as description,
node.synonyms as synonyms,
node.type as type 
SKIP {skip} LIMIT 10
````

### Summary

Given a list of entity `ids`, we retrieve the corresponding summaries with the following query:


```cypher
UNWIND $ids as _id 
MATCH (a:Synset {id:_id})
CALL {
    WITH a
    MATCH (a)-[:is_a|instance_of]->(b:Synset)
    RETURN DISTINCT a.id as for, a.id AS source, "is_a" AS relation, b.id AS target
    UNION ALL
    WITH a
    MATCH (a)-[:subclass_of*1..]->(b:Synset)
    RETURN DISTINCT a.id as for, a.id AS source, "is_a" AS relation, b.id AS target
    UNION ALL
    WITH a
    MATCH (a)-[:instance_of]->(mid)-[:subclass_of*1..]->(b:Synset)
    RETURN DISTINCT a.id as for, a.id AS source, "is_a" AS relation, b.id AS target
    UNION ALL
    WITH a
    MATCH (a)-[:part_of*1..]->(b:Synset)
    RETURN DISTINCT a.id as for, a.id AS source, "part_of" AS relation, b.id AS target
    UNION ALL
    WITH a
    MATCH (a)-[r]->(b:Synset)
    WHERE not type(r) in [
    "instance_of",
    "subclass_of",
    "is_a",
    "part_of" ]
    RETURN DISTINCT a.id as for, a.id AS source, type(r) AS relation, b.id AS target   
}
RETURN DISTINCT for, source, relation, target;
```

### Subgraph Queries

'Given a list of entity `ids`, we retrieve the corresponding subgraph for `is_a` and `part_of` relations with the following queries (used to compute the least common neighbors for these relations):

```cypher
UNWIND $ids AS id
MATCH (s:Synset {id:id})
CALL apoc.path.subgraphAll(s, {
  relationshipFilter: 'subclass_of>',
  uniqueness: 'RELATIONSHIP_GLOBAL',
  bfs: true
}) YIELD relationships
UNWIND relationships AS r
WITH DISTINCT r
where type(r) = 'subclass_of'
RETURN DISTINCT startNode(r).id AS source, type(r) AS relation, endNode(r).id AS target;
````

```cypher
UNWIND $ids AS id
MATCH (s:Synset {id:id})
CALL apoc.path.subgraphAll(s, {
  relationshipFilter: 'part_of>',
  uniqueness: 'RELATIONSHIP_GLOBAL',
  bfs: true
}) YIELD relationships
UNWIND relationships AS r
WITH DISTINCT r
where type(r) = 'part_of'
RETURN DISTINCT startNode(r).id AS source, type(r) AS relation, endNode(r).id AS target;
````