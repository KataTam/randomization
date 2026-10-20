# Randomization Tutorial Companion Materials

Static Shinylive exports and reproducibility materials for the companion
resources of the randomization tutorial.

## Companion Apps

- Complete randomization: `complete_rand/`
- Comparing complete and restricted procedures: `compare_rand/`
- Randomization Design Lab: `Randomization_Design_Lab/`

Published app URLs:

- <https://katatam.github.io/randomization/complete_rand/>
- <https://katatam.github.io/randomization/compare_rand/>
- <https://katatam.github.io/randomization/Randomization_Design_Lab/>

## Information about Figure 1

Short explanations of all 11 plotted procedures, their settings, the simulation
methods, and source code for Figure 1 are in `figure1_balance_unpredictability/`.
The figure assesses temporal balance through the proportion of enrollment steps
with absolute cumulative treatment-count imbalance of at least two, alongside
unpredictability.

Published page:

<https://katatam.github.io/randomization/figure1_balance_unpredictability/>

That folder includes:

- `figure1_balance_unpredictability_mcse.R`: simulation and plotting script.
- `figure1_balance_unpredictability_mcse.csv`: plotted means and Monte Carlo
  standard errors.
- `balance_unpred_gradient_check.png`: generated Figure 1 image.
- `index.html`: short browser-readable explanation for GitHub Pages.
