library(randomizeR)

set.seed(123142)

n_sim <- 1000
n_patients <- 50
imbalance_threshold <- 2

BlockMergeGen <- function(n, ratio, labels) {
  length.blocks <- sum(ratio)
  basis1 <- as.numeric(as.factor(
    getRandList(genSeq(pbrPar(rep(length.blocks, ceiling(n / length.blocks)),
                              K = length(ratio), ratio = ratio,
                              groups = labels)))))[1:n]
  basis2 <- as.numeric(as.factor(
    getRandList(genSeq(pbrPar(rep(length.blocks, ceiling(n / length.blocks)),
                              K = length(ratio), ratio = ratio,
                              groups = labels)))))[1:n]

  res <- rep(0, n)
  row1or2 <- sample(c(1, 2), size = n, prob = c(1 / 2, 1 / 2), replace = TRUE)
  taken.from.2 <- 0

  for (i in seq_len(n)) {
    if (row1or2[i] == 1) {
      res[i] <- basis1[i - taken.from.2]
    }
    if (row1or2[i] == 2) {
      taken.from.2 <- taken.from.2 + 1
      res[i] <- basis2[taken.from.2]
    }
  }

  res
}

sequence_to_ab <- function(sequence) {
  sequence <- as.character(sequence)
  sequence[sequence %in% c("1", "A")] <- "A"
  sequence[sequence %in% c("2", "B")] <- "B"
  sequence
}

correct_guess_probability <- function(sequence) {
  sequence <- sequence_to_ab(sequence)
  imbalance_before <- 0
  correct <- rep(NA_real_, length(sequence))

  for (i in seq_along(sequence)) {
    if (imbalance_before == 0) {
      correct[i] <- 0.5
    } else {
      guess <- ifelse(imbalance_before > 0, "B", "A")
      correct[i] <- as.numeric(sequence[i] == guess)
    }

    imbalance_before <- imbalance_before + ifelse(sequence[i] == "A", 1, -1)
  }

  mean(correct)
}

imbalance_proportion <- function(sequence, threshold = imbalance_threshold) {
  sequence <- sequence_to_ab(sequence)
  imbalance <- cumsum(ifelse(sequence == "A", 1, -1))
  mean(abs(imbalance) >= threshold)
}

assess_sequence <- function(sequence) {
  c(
    imbalance = imbalance_proportion(sequence),
    unpredictability = 1 - correct_guess_probability(sequence)
  )
}

generate_sequence <- function(procedure, n = n_patients) {
  if (procedure == "Deterministic allocation") {
    return(rep(c("A", "B"), length.out = n))
  }
  if (procedure == "Complete randomization") {
    return(as.vector(getRandList(genSeq(crPar(N = n, K = 2)))))
  }
  if (procedure == "Random allocation rule") {
    return(as.vector(getRandList(genSeq(rarPar(N = n)))))
  }
  if (procedure == "Truncated binomial design") {
    return(as.vector(getRandList(genSeq(tbdPar(bc = n)))))
  }
  if (procedure == "Permuted block randomization") {
    return(as.vector(getRandList(genSeq(
      pbrPar(bc = rep(4, ceiling(n / 4)), K = 2, ratio = rep(1, 2))
    )))[1:n])
  }
  if (procedure == "Random block-size PBR") {
    return(as.vector(getRandList(genSeq(
      rpbrPar(N = n, rb = c(4, 6, 8), K = 2, ratio = rep(1, 2))
    ))))
  }
  if (procedure == "Maximal procedure") {
    return(as.vector(getRandList(genSeq(mpPar(N = n, mti = 2)))))
  }
  if (procedure == "Efron's biased coin design") {
    return(as.vector(getRandList(genSeq(ebcPar(N = n, p = 2 / 3)))))
  }
  if (procedure == "Wei's urn design") {
    return(as.vector(getRandList(genSeq(udPar(N = n, ini = 10, add = 2)))))
  }
  if (procedure == "Big stick design") {
    return(as.vector(getRandList(genSeq(bsdPar(N = n, mti = 2)))))
  }
  if (procedure == "Merged block randomization") {
    return(LETTERS[1:2][BlockMergeGen(n, ratio = rep(1, 2), labels = LETTERS[1:2])])
  }

  stop("Unknown procedure: ", procedure)
}

procedures <- c(
  "Deterministic allocation",
  "Complete randomization",
  "Random allocation rule",
  "Truncated binomial design",
  "Permuted block randomization",
  "Random block-size PBR",
  "Maximal procedure",
  "Efron's biased coin design",
  "Wei's urn design",
  "Big stick design",
  "Merged block randomization"
)

simulation_results <- lapply(procedures, function(procedure) {
  replicate_results <- t(replicate(
    n_sim,
    assess_sequence(generate_sequence(procedure))
  ))

  data.frame(
    procedure = procedure,
    imbalance = mean(replicate_results[, "imbalance"]),
    unpredictability = mean(replicate_results[, "unpredictability"]),
    imbalance_mcse = sd(replicate_results[, "imbalance"]) / sqrt(n_sim),
    unpredictability_mcse = sd(replicate_results[, "unpredictability"]) / sqrt(n_sim)
  )
})

simulation_results <- do.call(rbind, simulation_results)
simulation_results$label <- c("DA", "CR", "RAR", "TBD", "PBR", "RPBR", "MP", "EBC", "UD", "BSD", "MBR")
simulation_results$imbalance_lower <- simulation_results$imbalance - 1.96 * simulation_results$imbalance_mcse
simulation_results$imbalance_upper <- simulation_results$imbalance + 1.96 * simulation_results$imbalance_mcse
simulation_results$unpredictability_lower <- simulation_results$unpredictability - 1.96 * simulation_results$unpredictability_mcse
simulation_results$unpredictability_upper <- simulation_results$unpredictability + 1.96 * simulation_results$unpredictability_mcse

write.csv(simulation_results, "figure1_balance_unpredictability_mcse.csv", row.names = FALSE)

blend_color <- function(x, y, xlim, ylim, lower_left, lower_right, upper_left, upper_right) {
  x_prop <- (x - xlim[1]) / diff(xlim)
  y_prop <- (y - ylim[1]) / diff(ylim)
  x_prop <- min(max(x_prop, 0), 1)
  y_prop <- min(max(y_prop, 0), 1)

  lower_left <- col2rgb(lower_left)
  lower_right <- col2rgb(lower_right)
  upper_left <- col2rgb(upper_left)
  upper_right <- col2rgb(upper_right)

  rgb_values <- (1 - x_prop) * (1 - y_prop) * lower_left +
    x_prop * (1 - y_prop) * lower_right +
    (1 - x_prop) * y_prop * upper_left +
    x_prop * y_prop * upper_right

  rgb(rgb_values[1], rgb_values[2], rgb_values[3], maxColorValue = 255)
}

x_limits <- c(-0.02, 0.8)
y_limits <- c(0.24, max(0.515, simulation_results$unpredictability_upper + 0.008))
x_ticks <- seq(0, 0.8, by = 0.1)
y_ticks <- seq(0.25, 0.5, by = 0.05)

point_colors <- mapply(
  blend_color,
  simulation_results$imbalance,
  simulation_results$unpredictability,
  MoreArgs = list(
    xlim = x_limits,
    ylim = y_limits,
    lower_left = "#3B6FB6",
    lower_right = "#C84C32",
    upper_left = "#007C72",
    upper_right = "#D89C00"
  )
)

label_y <- simulation_results$unpredictability
label_y[simulation_results$label == "CR"] <- label_y[simulation_results$label == "CR"] - 0.008
label_y[simulation_results$label == "MP"] <- label_y[simulation_results$label == "MP"] + 0.006
legend_order <- match(
  c("DA", "PBR", "MBR", "RPBR", "MP", "BSD", "EBC", "RAR", "UD", "TBD", "CR"),
  simulation_results$label
)

png("balance_unpred_gradient_check.png", width = 7, height = 5.2, units = "in", res = 450)
par(mar = c(5, 5, 3, 1), xaxs = "i", yaxs = "i")

plot(
  NA,
  NA,
  xlim = x_limits,
  ylim = y_limits,
  xlab = "Proportion of enrollment steps with absolute\ncumulative treatment count imbalance >= 2",
  ylab = "Unpredictability (1 - correct guess probability)",
  axes = FALSE,
  main = "The balance\u2013unpredictability trade-off"
)

box()
axis(1, at = x_ticks)
axis(3, at = x_ticks, labels = FALSE)
axis(2, at = y_ticks, las = 1)
axis(4, at = y_ticks, labels = FALSE)

has_horizontal_mcse <- simulation_results$imbalance_upper > simulation_results$imbalance_lower
has_vertical_mcse <- simulation_results$unpredictability_upper > simulation_results$unpredictability_lower

arrows(
  simulation_results$imbalance_lower[has_horizontal_mcse],
  simulation_results$unpredictability[has_horizontal_mcse],
  simulation_results$imbalance_upper[has_horizontal_mcse],
  simulation_results$unpredictability[has_horizontal_mcse],
  col = "gray25",
  lwd = 1,
  code = 3,
  angle = 90,
  length = 0.035
)
arrows(
  simulation_results$imbalance[has_vertical_mcse],
  simulation_results$unpredictability_lower[has_vertical_mcse],
  simulation_results$imbalance[has_vertical_mcse],
  simulation_results$unpredictability_upper[has_vertical_mcse],
  col = "gray25",
  lwd = 1,
  code = 3,
  angle = 90,
  length = 0.035
)

points(
  simulation_results$imbalance,
  simulation_results$unpredictability,
  pch = 21,
  bg = point_colors,
  col = "gray15",
  cex = 0.9,
  lwd = 1
)

text(
  simulation_results$imbalance,
  label_y,
  labels = simulation_results$label,
  pos = 4,
  cex = 0.75,
  col = "gray10"
)

legend(
  "bottomright",
  legend = paste(
    simulation_results$label[legend_order],
    gsub("block-size", "block size",
         simulation_results$procedure[legend_order], fixed = TRUE),
    sep = " = "
  ),
  pt.bg = point_colors[legend_order],
  col = "gray15",
  pch = 21,
  bty = "n",
  pt.cex = 0.9,
  cex = 0.80
)

dev.off()
