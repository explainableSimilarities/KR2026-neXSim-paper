## neXSim-v0.1-beta
The `System` folder contains the link to the source code of our system, neXSim-v0.1-beta, which is available on GitHub. This codebase includes all the necessary components to run our system.

The source code, available at [neXSim-v0.1-beta GitHub Repository](https://github.com/explainableSimilarities/neXSim-v0.1-beta), is organized into several modules that correspond to the different functionalities of our system. 

### Project Strucutre

``` text
neXSim-v0.1-beta/
├── neXSim/                       # source code folder
│   ├── characterization.py       # Characterization Algorithm and utilities
│   ├── lca.py                    # Utilities for navigating taxonomical relations 
│   ├── models.py                 # Data Models
│   ├── neo4j_manager.py          # Communication Layer with a Neo4j Graph Database 
│   ├── postgresQL_manager.py     # Communication Layer with a PostgresQL Database 
│   ├── report.py                 # Generate a textual report of entities in input 
│   ├── router.py                 # API Layer
│   ├── search.py                 # Utilities for entity search
│   ├── summary.py                # Algorithms and utilities for entity summarization
│   └── utils.py                  # Additional Utilities
├── .env                          # environment variables (to be set)
├── .gitignore                    # Files to exclude from Git
├── app.py                        # Entry point (Flask)
├── docker-compose.yml            # For installation in a docker container
├── gunicorn_config.py            # Server configuration
├── README.md                     # The README file for the system repository
└── requirements.txt              # Python dependencies
```

The codebase is well-documented, with comments and README files that provide instructions on how to set up and run the system. Please refer to the `README.md` file in the linked repository for detailed instructions on installation, configuration, and usage of neXSim-v0.1-beta.