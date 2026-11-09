# NMADTA

<p class="package-tagline">Network meta-analysis of multiple diagnostic tests</p>

NMADTA brings Bayesian diagnostic-test network meta-analysis into R. Compare
multiple tests using evidence from studies that evaluate different subsets of
tests, with or without a gold standard reference test. Fit hierarchical or
HSROC models, assess missing-data assumptions, and turn the results into
posterior summaries and diagnostic accuracy plots.

<p class="home-actions"><a class="btn btn-primary" href="https://kevinxing3.github.io/NMADTA/articles/get-started.html">Get started</a> <a class="btn btn-outline-primary" href="https://CRAN.R-project.org/package=NMADTA">View on CRAN</a></p>

## Installation

Install [JAGS 4.x](https://mcmc-jags.sourceforge.io/) first, then install the
released package in R. NMADTA requires R 4.0.0 or later.

~~~r
install.packages("NMADTA")
library(NMADTA)
~~~

The current release is **0.1.4**. The [installation guide](https://kevinxing3.github.io/NMADTA/articles/get-started.html#installation)
includes a check that R can find JAGS.

## A network of diagnostic evidence

The included `dat.kang` example combines **12 studies of deep vein thrombosis**.
Four compared D-dimer with venography, three compared ultrasonography with
venography, and five compared D-dimer with ultrasonography. No study evaluated
all three tests together.

NMADTA uses joint test-outcome counts within each study to compare the two
candidate tests in one model. Venography is the reference standard; `K = 2`
counts the candidate tests.

~~~r
data(dat.kang)

kang_fit <- nmadt.hierarchical(
  nstu = 12, K = 2,
  data = dat.kang,
  testname = c("D-dimer", "Ultrasonography"),
  directory = tempdir(),
  n.adapt = 5000, n.iter = 50000, n.chains = 3,
  conv.diag = TRUE
)

summary(kang_fit)
plot(kang_fit, type = "sroc")
~~~

![SROC panels produced by NMADTA for D-dimer and ultrasonography in the 12-study example.](https://kevinxing3.github.io/NMADTA/figures/example-sroc.png)

<p class="figure-note">Actual NMADTA output from the worked example, using three chains and 50,000 iterations per chain. See the <a href="https://kevinxing3.github.io/NMADTA/articles/get-started.html">complete analysis</a> for data preparation, numerical output, diagnostics, and reproducibility details.</p>

## Study-level diagnostic accuracy

The forest plots show study-level sensitivity and specificity for D-dimer and
ultrasonography, using the same fitted model as the SROC display above.
Points mark posterior medians, horizontal intervals show 95% credible intervals,
and vertical dotted lines mark the pooled posterior medians.

~~~r
plot(kang_fit, type = "forest")
~~~

[![Actual NMADTA forest plot output: study-level sensitivity and specificity for D-dimer and ultrasonography.](https://kevinxing3.github.io/NMADTA/figures/example-forest.png)](https://kevinxing3.github.io/NMADTA/figures/example-forest.png)

<p class="figure-note">Actual output from NMADTA 0.1.4 using the 12-study worked example. Dashed horizontal intervals identify studies in which that candidate test was not observed; these estimates are model-based. See the <a href="https://kevinxing3.github.io/NMADTA/articles/get-started.html#assess-convergence-and-assumptions">convergence assessment</a> for this run. Click the figure to view it at full resolution.</p>

## Two model families, one workflow

Both model families return an `nmadt` object with common `print()`, `summary()`,
and `plot()` methods.

| Analysis | Hierarchical model | HSROC model |
|:--|:--|:--|
| MAR formulation | [`nmadt.hierarchical()`](https://kevinxing3.github.io/NMADTA/reference/nmadt.hierarchical.html) | [`nmadt.hsroc()`](https://kevinxing3.github.io/NMADTA/reference/nmadt.hsroc.html) |
| MNAR sensitivity analysis | [`nmadt.hierarchical.MNAR()`](https://kevinxing3.github.io/NMADTA/reference/nmadt.hierarchical.MNAR.html) | [`nmadt.hsroc.MNAR()`](https://kevinxing3.github.io/NMADTA/reference/nmadt.hsroc.MNAR.html) |

The hierarchical model directly parameterizes sensitivity and specificity.
The HSROC model uses accuracy and threshold components. Read
[Choosing a model](https://kevinxing3.github.io/NMADTA/articles/models.html) for the distinction and the
assumptions that matter in practice.

## Learn more

- **[Get started](https://kevinxing3.github.io/NMADTA/articles/get-started.html):** install NMADTA and follow a complete worked example.
- **[Prepare your data](https://kevinxing3.github.io/NMADTA/articles/data-format.html):** column order, missing-test indicators, and joint outcome counts.
- **[Explore missing-data assumptions](https://kevinxing3.github.io/NMADTA/articles/missing-data.html):** set up an MNAR sensitivity analysis.
- **[Browse the reference](https://kevinxing3.github.io/NMADTA/reference/index.html):** arguments, returned objects, and plotting options.

## Paper and replication

Xing X, Lu B, Lin L, Lian Q, Hodges JS, Chen Y, Chu H (2026).
**NMADTA: An R package for network meta-analysis of multiple diagnostic tests.**
*Research Synthesis Methods*.
[doi:10.1017/rsm.2026.10097](https://doi.org/10.1017/rsm.2026.10097).

The article describes the methods and software design and links to
[replication data and code](https://osf.io/46jvc/). Its examples used NMADTA
0.1.3; this website documents version 0.1.4.
