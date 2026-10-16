# Information about Figure 1

This folder contains explanations, source code, and generated outputs for
Figure 1 in *Choosing and Evaluating Randomization Procedures: A Tutorial*.
The [Figure 1 information page](https://katatam.github.io/randomization/figure1_balance_unpredictability/)
explains each of the 11 plotted procedures and its simulation settings.

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

The deterministic comparator is strict AB alternation. Approximate 95%
Monte Carlo intervals are mean +/- 1.96 MCSE. The plot retains the actual
means and interval endpoints, including endpoints above 0.5.

Run the script from this folder with `Rscript figure1_balance_unpredictability_mcse.R`.
It requires `randomizeR`; the current outputs were checked with version 3.0.2
under R 4.5.1. Parameter settings and guessing-strategy interpretation are
documented in `index.html` and the script.
