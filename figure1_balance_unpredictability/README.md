# Information about Figure 1

This folder contains explanations, source code, and generated outputs for
Figure 1, *The balance–unpredictability trade-off*, in
*Choosing and Evaluating Randomization Procedures: A Tutorial*.
The [Figure 1 information page](https://katatam.github.io/randomization/figure1_balance_unpredictability/)
explains each of the 11 plotted procedures and its simulation settings.
The display is conceptually adapted from
[van der Pas (2019)](https://doi.org/10.1177/1740774519827957), redrawn and
extended for the tutorial.

Treatment allocation balance describes how closely the numbers assigned to each
treatment follow the intended allocation ratio. Treatment counts are the numbers
themselves; all procedures in this figure target a 1:1 ratio.

Temporal imbalance describes unequal treatment representation across recruitment
periods. The figure assesses temporal balance using cumulative treatment count
imbalance: the difference between the numbers assigned to A and B after each
enrollment. The horizontal coordinate is the proportion of enrollment steps
with an absolute cumulative treatment count imbalance of at least two.
This summary uses enrollment order; it does not explicitly model calendar time.

Unpredictability is one minus the average correct guess probability under the
Blackwell-Hodges convergence strategy, which guesses the underrepresented
treatment and guesses at random when the treatment counts are equal.
Points closer to the upper left combine better temporal balance under the
specified criterion with greater unpredictability under this guessing strategy.
The coordinates depend on the sample size and procedure parameters.

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
Horizontal bars describe simulation uncertainty in the imbalance coordinate;
vertical bars describe it in the unpredictability coordinate. These intervals
quantify simulation error under the specified setting. Sensitivity to sample
size and procedure parameters requires separate evaluation. Strict alternation
scores 0.25 for unpredictability under this guessing strategy, although knowledge of the
alternating rule makes every assignment predictable.

Run the script from this folder with `Rscript figure1_balance_unpredictability_mcse.R`.
It requires `randomizeR`; the current outputs were checked with version 3.0.2
under R 4.5.1. Parameter settings and guessing-strategy interpretation are
documented in `index.html` and the script.
