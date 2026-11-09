# NMADTA

<p class="package-tagline">Network meta-analysis of multiple diagnostic tests</p>

NMADTA brings Bayesian diagnostic-test network meta-analysis into R. Compare
multiple tests using evidence from studies that evaluate different subsets of
tests, with or without a gold standard reference test. Fit hierarchical or
HSROC models, assess missing-data assumptions, and turn the results into
posterior summaries and diagnostic accuracy plots.

<p class="home-actions"><a class="btn btn-primary" href="articles/get-started.html">Get started</a> <a class="btn btn-outline-primary" href="https://CRAN.R-project.org/package=NMADTA">View on CRAN</a></p>

## Installation

Install [JAGS 4.x](https://mcmc-jags.sourceforge.io/) first, then install the
released package in R. NMADTA requires R 4.0.0 or later.

~~~r
install.packages("NMADTA")
library(NMADTA)
~~~

The current release is **0.1.4**. The [installation guide](articles/get-started.html#installation)
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

![SROC panels produced by NMADTA for D-dimer and ultrasonography in the 12-study example.](figures/example-sroc.png)

<p class="figure-note">Actual NMADTA output from the worked example, using three chains and 50,000 iterations per chain. See the <a href="articles/get-started.html">complete analysis</a> for data preparation, numerical output, diagnostics, and reproducibility details.</p>

## Joint uncertainty in diagnostic accuracy

The contour display shows the joint posterior distribution of the true-positive
and false-positive rates. The two panels below are **Figure 5 from the companion
RSM article**, showing D-dimer and ultrasonography.

~~~r
plot(kang_fit, type = "contour")
~~~

[![Figure 5 from the RSM article: posterior contour plots of true-positive versus false-positive rates for D-dimer and ultrasonography.](figures/paper-figure-5.png)](figures/paper-figure-5.png)

<p class="figure-note">Figure 5 reproduced from <a href="https://doi.org/10.1017/rsm.2026.10097">Xing et al. (2026), Research Synthesis Methods</a>, <a href="https://creativecommons.org/licenses/by/4.0/">CC BY 4.0</a>. Cropped to the figure. This published illustration used NMADTA 0.1.3. Click the figure to view it at full resolution.</p>

## Two model families, one workflow

Both model families return an `nmadt` object with common `print()`, `summary()`,
and `plot()` methods.

| Analysis | Hierarchical model | HSROC model |
|:--|:--|:--|
| MAR formulation | [`nmadt.hierarchical()`](reference/nmadt.hierarchical.html) | [`nmadt.hsroc()`](reference/nmadt.hsroc.html) |
| MNAR sensitivity analysis | [`nmadt.hierarchical.MNAR()`](reference/nmadt.hierarchical.MNAR.html) | [`nmadt.hsroc.MNAR()`](reference/nmadt.hsroc.MNAR.html) |

The hierarchical model directly parameterizes sensitivity and specificity.
The HSROC model uses accuracy and threshold components. Read
[Choosing a model](articles/models.html) for the distinction and the
assumptions that matter in practice.

## Learn more

- **[Get started](articles/get-started.html):** install NMADTA and follow a complete worked example.
- **[Prepare your data](articles/data-format.html):** column order, missing-test indicators, and joint outcome counts.
- **[Explore missing-data assumptions](articles/missing-data.html):** set up an MNAR sensitivity analysis.
- **[Browse the reference](reference/index.html):** arguments, returned objects, and plotting options.

## Paper and replication

Xing X, Lu B, Lin L, Lian Q, Hodges JS, Chen Y, Chu H (2026).
**NMADTA: An R package for network meta-analysis of multiple diagnostic tests.**
*Research Synthesis Methods*.
[doi:10.1017/rsm.2026.10097](https://doi.org/10.1017/rsm.2026.10097).

The article describes the methods and software design and links to
[replication data and code](https://osf.io/46jvc/). Its examples used NMADTA
0.1.3; this website documents version 0.1.4.
