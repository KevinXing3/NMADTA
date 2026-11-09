context("nmadt.hierarchical.MNAR")
test_that("nmadt.hierarchical.MNAR is working and the results are reproducible", {

  data(dat.kang, package = "NMADTA")
  kangdata <- dat.kang
  expect_error(nadt.hsroc(nstu=10, K=2, data=kangdata, testname=c("D-dimer","Ultrasonography")))
  expect_error(nadt.hsroc(nstu=12, K=1, data=kangdata, testname=c("D-dimer","Ultrasonography")))
  expect_error(nadt.hsroc(nstu=12, K=1, data=kangdata, testname=c("D-dimer")))
  skip("skipped because it takes more than 5 minutes and similar mechanism tested in nmadt.hierarchical()")
  set.seed(9)
  kang.out.MNAR <- nmadt.hierarchical.MNAR(nstu=12, K=2, data=kangdata, testname=c("D-dimer","Ultrasonography")
                                           ,gamma1=c(-0.5,-0.5), gamma0=c(-0.5,-0.5))

  testname=c("D-dimer","Ultrasonography")
  K = 2
  mean = c(0.8501,0.9053)
  sd<- c(0.0643,0.0598)
  median <- c(0.8555,0.9127)
  cil<-c(0.7055,0.9566)
  ciu<-c(0.7887,0.9822)
  Se.stat <- array(paste(mean, " (", sd, ")", sep = ""),dim = c(K, 1))
  colnames(Se.stat) <- "Mean (SD)"
  rownames(Se.stat) <- testname
  Se.quan <- array(paste(median, " (", cil, ", ", ciu, ")", sep = ""),dim = c(K, 1))
  colnames(Se.quan) <- "Median (95% CI)"
  rownames(Se.quan) <- testname
  Se <- list(Mean_SD = noquote(Se.stat), Median_CI = noquote(Se.quan))

  expect_equal(as.numeric(unlist(kang.out.MNAR$Se)),as.numeric(unlist(Se)))
})
