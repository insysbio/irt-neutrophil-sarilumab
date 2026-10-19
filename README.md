# IRT article: neutrophil response model

This folder contains the QSP model used in the article's example of neutrophil response to sarilumab.

## Files

- `index.heta`: the model assembly point; it brings together the model tables and defines dosing events.
- `NEU_IL6_model_from_IRT.xlsx`: model tables downloaded directly from IRT.
- `NEU_IL6_model.xlsx`: the IRT tables with additional components added manually (used in the build).
- `PK_sari.xlsx`: sarilumab pharmacokinetic model tables (used in the build).
- `qsp-units.heta` and `platform.json`: units and project settings.
- `RUN_MODEL.jl`: simulations and plots.
- `Project.toml` and `Manifest.toml` describe the Julia environment.
- `NEU_IL6_Sari_merged_model.xlsx`: assembled model tables; their components match the generated model in `dist/`.
- `dist/`: generated outputs; not included in the archive.

## Requirements

To build and run the model, install [Heta Compiler](https://hetalang.github.io/hetacompiler/installation.html), [Julia](https://julialang.org/downloads/), and [HetaSimulator.jl](https://hetalang.github.io/HetaSimulator.jl/stable/). The simulation script also uses Plots, DataFrames, and Measures.

## Build with heta-compiler

From this folder, run:

```sh
heta build
```

## Work in Julia

See **RUN_MODEL.jl**

## Authors

Immune Response Template (IRT) Team
