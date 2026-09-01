# Figure 1: Balance vs. Unpredictability

This folder contains the source code and generated outputs for Figure 1 in
*Choosing and Evaluating Randomization Procedures in Clinical Trials: A
Tutorial*.

Files:

- `figure1_balance_unpredictability_mcse.R`: R script used to simulate the
  randomization sequences, calculate replicate-level summaries, estimate Monte
  Carlo standard errors, and draw the figure.
- `figure1_balance_unpredictability_mcse.csv`: plotted means and Monte Carlo
  standard errors for each procedure.
- `balance_unpred_gradient_check.png`: generated Figure 1 image.
- `index.html`: short web explanation for GitHub Pages.

The simulation uses `M = 1000` independently simulated allocation sequences
with `n = 50` participants per sequence. Monte Carlo standard errors are
estimated across sequence-level summaries as `sd(Z) / sqrt(M)`.
