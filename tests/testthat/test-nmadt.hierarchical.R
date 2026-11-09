context("nmadt.hierarchical")
test_that("nmadt.hierarchical is working and the results are reproducible", {
  
  data(dat.kang, package = "NMADTA")
  kangdata <- dat.kang
  kangdata <- kangdata[c(-4,-7)]
  kangdata <- kangdata[-(17:28),]
  kangdata$sid <- c(rep(c(1:9), each = 4))
  set.seed(9)
  suppressWarnings({
    kang.out.hierarchical <- nmadt.hierarchical(
      nstu=12, K=2,
      data=dat.kang,
      testname=c("D-dimer","Ultrasonography")
    )
  })
  
  testname=c("D-dimer","Ultrasonography")
  mean = c(0.8417,0.9273)
  sd <- c(0.0706,0.0448)
  median <- c(0.8475,0.9319)
  cil <- c(0.6844,0.9654)
  ciu <- c(0.8278,0.9955)
  
  Se.stat <- array(paste(mean, " (", sd, ")", sep=""), dim=c(2,1),
                   dimnames=list(testname, "Mean (SD)"))
  Se.quan <- array(paste(median," (",cil,", ",ciu,")",sep=""), dim=c(2,1),
                   dimnames=list(testname, "Median (95% CI)"))
  
  # function: extract mean value from "0.85 (0.06)"
  extract_mean <- function(x) as.numeric(sub(" \\(.*", "", x))
  
  expect_equal(
    extract_mean(kang.out.hierarchical$Se$Mean_SD),
    mean,
    tolerance = 0.02
  )
})
