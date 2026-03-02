# Protest-Diffusion

Spatio-temporal analysis of protest diffusion in Bangladesh using a Hawkes point process model fitted to ACLED event data.

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Data](#data)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
- [Reproducibility](#reproducibility)
- [Citation](#citation)
- [License](#license)
- [Contributing](#contributing)
- [Contact](#contact)

---

## Overview

This project models the spatio-temporal diffusion of protest and mob violence events in Bangladesh during a concentrated period in the summer of 2024 (June 5 – August 5, 2024). A self-exciting **Hawkes process** is used to capture how past protest events increase the probability of future events occurring nearby in time and space.

Event data are sourced from the [Armed Conflict Location & Event Data Project (ACLED)](https://acleddata.com/), filtered to include `Mob violence` and `Violent demonstration` sub-event types. The model parameters (baseline intensity `μ`, excitation magnitude `α`, and temporal decay `β`) are estimated via maximum likelihood (Nelder–Mead optimisation).

The companion working paper — *Bangladesh Local Official Violence* — is included as a PDF in this repository.

---

## Repository Structure

```
Protest-Diffusion/
├── Bangladesh_hawkes.R                  # Main R analysis script
├── Bangladesh_Local_Official_Violence.pdf  # Companion working paper / report
├── acled_data.csv                       # ACLED protest event data
├── LICENSE                              # Apache-2.0 license
└── README.md                            # This file
```

---

## Data

| File | Description | Source |
|------|-------------|--------|
| `acled_data.csv` | Armed Conflict Location & Event Data for Bangladesh. Contains fields including `sub_event_type`, `event_date`, `admin3`, `latitude`, `longitude`. | [ACLED](https://acleddata.com/) |

The script filters the dataset to:
- **Sub-event types**: `Mob violence`, `Violent demonstration`
- **Date range**: 2024-06-05 to 2024-08-05
- Duplicate events (same district + date) are removed; rows with missing coordinates are dropped.

> **Note**: If you use a fresh ACLED download, update the file path in `Bangladesh_hawkes.R` (line 9) to point to your local copy.

---

## Requirements

- **R** (≥ 4.0 recommended)
- R packages:
  - [`dplyr`](https://dplyr.tidyverse.org/)
  - [`lubridate`](https://lubridate.tidyverse.org/)
  - [`PtProcess`](https://cran.r-project.org/package=PtProcess)

---

## Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/zachessesjohnson/Protest-Diffusion.git
   cd Protest-Diffusion
   ```

2. **Install R dependencies**

   Open R or RStudio and run:

   ```r
   install.packages(c("dplyr", "lubridate", "PtProcess"))
   ```

3. **Update the data path**

   Open `Bangladesh_hawkes.R` and replace the hard-coded path on line 9 with the path to `acled_data.csv` on your machine:

   ```r
   acled_data <- read.csv("acled_data.csv")   # relative path when run from repo root
   ```

---

## Usage

Run the main analysis script from within the repository root:

```r
source("Bangladesh_hawkes.R")
```

The script will:

1. Load and filter the ACLED data to the relevant event types and date window.
2. Scale the spatial coordinates and event times.
3. Define a spatio-temporal Hawkes process intensity function.
4. Fit the model via negative log-likelihood minimisation using `optim()` (Nelder–Mead).
5. Print the estimated parameters and optimisation diagnostics to the console.

> **TODO**: Add output plots (e.g., estimated intensity surface, residual diagnostics) and export results to a results directory. Update this section when those steps are implemented.

---

## Reproducibility

A random seed (`set.seed(123)`) is set at the top of the script to ensure reproducible results across R sessions.

To reproduce the full analysis:

1. Complete the [Setup](#setup) steps above.
2. Ensure `acled_data.csv` is accessible and the path is correct.
3. Run `source("Bangladesh_hawkes.R")` in R.

Expected output includes:
- The number of filtered events in the date range.
- The head of the scaled event data frame.
- Per-iteration log-likelihood values from the optimiser.
- The final optimisation result (`fit` object) with estimated `μ`, `α`, and `β`.

---

## Citation

If you use this code or the companion paper in your work, please cite:

```
TODO: Add full citation for the Bangladesh Local Official Violence working paper
      (authors, year, title, institution/journal, DOI if available).
```

---

## License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

---

## Contributing

Contributions, bug reports, and suggestions are welcome. Please open an issue or submit a pull request on GitHub.

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/my-feature`).
3. Commit your changes (`git commit -m "Add my feature"`).
4. Push to the branch (`git push origin feature/my-feature`).
5. Open a Pull Request.

---

## Contact

For questions or collaboration inquiries, please open a GitHub issue in this repository.

> **TODO**: Add author name, institutional affiliation, and e-mail address here.
