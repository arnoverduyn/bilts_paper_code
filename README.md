[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
![GitLab code size in bytes](https://img.shields.io/badge/code%20size-120KB-brightgreen)

# BILTS Measure: Experimental Validation and Comparative Evaluation

This repository contains the MATLAB code for the experimental validation and comparative evaluation of the **BILTS similarity measure** against other approaches: DHB, eFS, ISA, ISA-ocp, RRV, and DSRF. The results and methodology are described in the accompanying paper (TO DO: add citation).

---

## Repository Structure
- **`src/`**: Contains the main script for running the trajectory recognition experiments: `main_trajectory_recognition.m`.
- **`Libraries/`**: Includes the required external libraries for the experiments:
  - `casadi_library/`: Users must download and place the Casadi library here (see instructions below).
- **`Data/Datasets/`**: Directory for datasets (folders are to be made and the datasets are to be downloaded separately, see instructions below).
- **Generated Results**: We also included an Excel file summarizing the results as reported in the paper.

---

## Prerequisites

### 1. MATLAB
Ensure that MATLAB is installed on your system. The code is tested with MATLAB R2024b.

### 2. Casadi Library
Download the Casadi library version `casadi-windows-matlabR2016a-v3.5.5` from the [Casadi website](https://web.casadi.org/get/).  
Place the downloaded library in the following directory:

```
Libraries/casadi_library/
```

### 3. Datasets
The code requires two datasets: **DLA** and **SYN**. Download these datasets from [Zenodo](https://zenodo.org/) (TO DO: add specific link). After downloading, create the directory `Data/Datasets/`, and place the datasets in the this directory:

```
Data/Datasets/DLA/
Data/Datasets/SYN/
```

---

## How to Run the Code

1. Download and set up the repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```
2. Download and place the Casadi library in `Libraries/casadi_library/`.
3. Download and organize the datasets in `Data/Datasets/` as described above.
4. Open MATLAB and navigate to the `src/` folder.
5. Run the main script:
   ```matlab
   main_trajectory_recognition
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Citing

If you use this package in your research, please cite the following paper:

```
@misc{...,
      title={BILTS: A Bi-Invariant Similarity Measure for Robust Object Trajectory Recognition under Reference Frame Variations}, 
      author={Arno Verduyn and Erwin Aertbeliën and Glenn Maes and Joris De Schutter and Maxim Vochten},
      year={2025},
      eprint={2405.04392},
      archivePrefix={arXiv},
      primaryClass={cs.RO},
      url={https://arxiv.org/abs/2405.04392}, 
}
```

## Acknowledgments
This work uses the Casadi library and the datasets available on Zenodo. We acknowledge the creators of these resources for their contributions to the research community.


