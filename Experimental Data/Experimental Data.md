## Experimental Data

### Overview

The following section provides an overview of the content of this folder, its subfolders, and the files contained therein. This folder is dedicated to the experimental results obtained with our benchmark on neXSim (See the [Experimental Pipeline](../Experimental%20Pipeline/Experimental%20Pipeline.md) section for further details).

``` text
Experimental Data/                # we are here...
├── computation_timex/xlsx        
│   ├── execution_times_raw_data.xlsx
├── sizes/xlsx        
│   ├── core_ker_size_raw_data.xlsx
│   ├── summary_size_raw_data.xlsx
├── unit_identifiers/xlsx        
│   ├── identifiers_actor.xlsx
│   ├── identifier_amusement_park.xlsx
│   ├── identifier_band.xlsx
│   ├── identifier_championship.xlsx
│   ├── identifier_chemical_element.xlsx
│   ├── identifier_company.xlsx
│   ├── identifier_comune.xlsx
│   ├── identifier_dialect.xlsx
│   ├── identifier_film.xlsx
│   ├── identifier_scientist.xlsx
│   ├── identifier_sculpture.xlsx
│   ├── identifier_university.xlsx
│   ├── identifier_vehicle.xlsx
│   ├── identifier_video_game.xlsx
```

### Computation Times

The `computation_times` folder contains an `.xlsx` file with the raw data of the computation times for characterization and kernel explanation for each unit in our benchmark. In one row, we have the unit identifier (seed+size+instance_number), the 4 computation times for characterization (each run except the worst), and the 4 computation times for kernel explanation (each run except the worst). Average and variance for both metrics are also included in the file.


### Sizes

The `sizes` folder contains two `.xlsx` files with the raw data regarding sizes of computed objects. The first (`core_ker_size_raw_data.xlsx`) contains the size of the core kernel for each unit, while the second (`summary_size_raw_data.xlsx`) contains the size of the summary for each sampled entity.

### Unit Identifiers

One file for each of the 14 seeds in our benchmark, matching the unit identifiers (seed+size+instance_number) with the corresponding entities in the unit (Babelnet Identifiers). This information is crucial for linking the experimental results with the specific entities that were part of each unit in our benchmark.