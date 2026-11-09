#!/usr/bin/env Rscript
# Reproduce the website figures with the released NMADTA package.
suppressPackageStartupMessages(library(NMADTA))
stopifnot(packageVersion("NMADTA") >= "0.1.4")
dir.create(".cache", showWarnings = FALSE)
dir.create("pkgdown/assets/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("pkgdown/assets/example", recursive = TRUE, showWarnings = FALSE)
data("dat.kang", package = "NMADTA")

set.seed(10)
kang_fit <- nmadt.hierarchical(
  nstu = 12, K = 2, data = dat.kang,
  testname = c("D-dimer", "Ultrasonography"),
  directory = normalizePath(".cache"),
  n.adapt = 5000, n.iter = 50000, n.chains = 3,
  n.burnin = 25000, n.thin = 1,
  conv.diag = TRUE, trace = NULL, dic = FALSE,
  mcmc.samples = FALSE
)
saveRDS(kang_fit, ".cache/kang-fit.rds")
writeLines(capture.output(summary(kang_fit)), "pkgdown/assets/example/summary.txt")
writeLines(capture.output(utils::head(dat.kang)), "pkgdown/assets/example/data-head.txt")
write.csv(dat.kang, "pkgdown/assets/example/dat-kang.csv", row.names = FALSE)

png("pkgdown/assets/figures/example-sroc.png", width = 2100, height = 850,
    res = 180, type = getOption("bitmapType"), bg = "white")
plot(kang_fit, type = "sroc", cex.axis = 0.85, cex.lab = 0.9)
dev.off()
png("pkgdown/assets/figures/example-forest.png", width = 1800, height = 1300,
    res = 180, type = getOption("bitmapType"), bg = "white")
plot(kang_fit, type = "forest", cex.axis = 0.8, cex.lab = 0.9)
dev.off()

writeLines(capture.output(sessionInfo()), "pkgdown/assets/example/session-info.txt")
writeLines(c(
  "NMADTA website worked example",
  "Data: dat.kang (12 diagnostic-test studies of deep vein thrombosis)",
  "Model: nmadt.hierarchical; 2 candidate tests; MAR formulation",
  "R seed: 10 (R-side seed; JAGS results can vary by platform)",
  "Adaptation: 5000; iterations per chain: 50000; chains: 3",
  "Burn-in: 25000; thinning: 1; convergence diagnostics: TRUE",
  "The figures are actual NMADTA outputs from this run.",
  "These outputs illustrate the workflow and are not clinical recommendations."
), "pkgdown/assets/example/README.txt")
cat("Example complete. Available result elements:\n")
print(names(kang_fit))
cat("\nSensitivity and specificity:\n")
print(kang_fit$Se); print(kang_fit$Sp)
