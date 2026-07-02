# Structure-coefficient theorem for evolutionary games on dynamic networks

## Description

This repository provides reproducible materials for the paper titled
"Structure-coefficient theorem for evolutionary games on dynamic networks".

It contains the core Julia code for computing structure coefficients of dynamic
networks, a minimal Julia demo comparing the theoretical prediction with Monte
Carlo simulations on a simple dynamic network, and MATLAB scripts for reproducing
the figures in the paper.

The `.txt` files included in the figure folders are precomputed numerical results
used by the MATLAB plotting scripts. The large-scale numerical procedures used to
generate all of these `.txt` files are not included, because they are substantially
more extensive than the minimal demonstration.

Each MATLAB script is named after the corresponding figure panel; running a script
reproduces that panel using the associated `.txt` files in the same folder.

## Implementation Details

- The core theoretical calculation and simulation demo were written in Julia. We recommend using Julia 1.10.x or a later 1.x version.
- The figure plotting scripts were written in MATLAB R2024a.
- The figure folders contain precomputed numerical results in `.txt` files used by the MATLAB plotting scripts.

## File Structure

### Core Analysis Scripts

- `Structure_Coefficients_of_Dynamic_Networks.jl` - Computes structure coefficients for given dynamic networks.
- `Simulation.jl` - Performs Monte Carlo simulations of strategy frequencies on given dynamic networks.
- `Demo.jl` - Demonstrates the calculation of cooperation frequency on a simple dynamic network using both theoretical calculations and Monte Carlo simulations.

### Visualization Resources

- `Figure 2/` - Data and MATLAB scripts for Figure 2.
- `Figure 3/` - Data and MATLAB scripts for Figure 3.
- `Figure 5/` - Data and MATLAB scripts for Figure 5.
- `Extended Data Figure 1/` - Data and MATLAB scripts for Extended Data Figure 1.
- `Extended Data Figure 2/` - Data and MATLAB scripts for Extended Data Figure 2.
- `Extended Data Figure 3/` - Data and MATLAB scripts for Extended Data Figure 3.
- `Extended Data Figure 4/` - Data and MATLAB scripts for Extended Data Figure 4.
- `Extended Data Figure 5/` - Data and MATLAB scripts for Extended Data Figure 5.
- `Extended Data Figure 6/` - Data and MATLAB scripts for Extended Data Figure 6.
- `Extended Data Figure 7/` - Data and MATLAB scripts for Extended Data Figure 7.
- `Supplementary Figure 1/` - Data and MATLAB scripts for Supplementary Figure 1.
- `Supplementary Figure 2/` - Data and MATLAB scripts for Supplementary Figure 2.
- `Supplementary Figure 3/` - Data and MATLAB scripts for Supplementary Figure 3.
- `Supplementary Figure 4/` - Data and MATLAB scripts for Supplementary Figure 4.
- `Supplementary Figure 5/` - Data and MATLAB scripts for Supplementary Figure 5.

## System Requirements

### Operating System

- Tested on Windows 11.

### Hardware

- Standard desktop computer, for example Intel i7 CPU and 16 GB RAM.

### Software Dependencies

The Julia scripts use the following packages:

```julia
SparseArrays
LinearAlgebra
IterativeSolvers
```

`SparseArrays` and `LinearAlgebra` are Julia standard libraries. `IterativeSolvers`
is an external Julia package and can be installed by running the following commands
in Julia:

```julia
import Pkg
Pkg.add("IterativeSolvers")
```

The MATLAB plotting scripts were written and tested in MATLAB R2024a.

## Installation

### Julia Installation

Download and install Julia from the official website:

https://julialang.org/downloads/

Alternatively, Julia can be installed from the command line.

Linux and macOS:

```console
curl -fsSL https://install.julialang.org | sh
```

Windows:

```console
winget install julia -s msstore
```

### Julia Package Installation

After installing Julia, install the external Julia dependency by running:

```julia
import Pkg
Pkg.add("IterativeSolvers")
```

No additional installation is required for `SparseArrays` and `LinearAlgebra`,
because they are included in the Julia standard library.

## Usage

### Running the Julia Demo

Run the following command in the root folder of the repository:

```console
julia Demo.jl
```

The demo computes the cooperation frequency on a simple dynamic network using both
the theoretical calculation and Monte Carlo simulation, and prints the two results
for comparison.

The Monte Carlo part of `Demo.jl` may take a long time with the default parameters.
For a faster test run, users can reduce `maxLoop` and `maxIter` in `Demo.jl`.

### Reproducing Figure Panels

Each MATLAB script is named after the corresponding figure panel in the paper.

To reproduce a panel, open MATLAB, change the current folder to the corresponding
figure folder, and run the panel script. For example, to reproduce Figure 3b,
change the MATLAB current folder to `Figure 3/` and run:

```matlab
Figure_3_Panel_b
```

The required `.txt` files are precomputed numerical results and are read by the
MATLAB scripts in the corresponding figure folder.

## Notes on Precomputed Data

The `.txt` files in the figure folders are processed numerical outputs used for
plotting the figures. They are provided so that the MATLAB scripts can reproduce
the figure panels reported in the paper.

The full large-scale numerical workflows used to generate all precomputed `.txt`
files are not included in this repository. The repository instead provides the
core theoretical calculation code, a minimal simulation demo, and the processed
data required for figure reproduction.
