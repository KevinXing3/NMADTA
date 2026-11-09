forestplot.hierarchical <- function(x,
                                    cex.axis = 1.2, cex.lab = 1.2,
                                    max_per_page = 2,
                                    ...) {
  if (!inherits(x, "nmadt"))
    stop("Input must be an 'nmadt' object.")
  if (tolower(x$model) != "hierarchical")
    stop("forestplot_hierarchical() is for hierarchical models only.")
  
  # 取出必要信息
  K       <- x$K
  nstu    <- x$nstu
  dat     <- x$dat
  testname <- x$testname
  samp    <- x$rawOutput
  
  # 需要的内部函数：indicator() 和 paralist()
  index <- indicator(K, nstu, dat)
  summ  <- summary(samp)
  result <- summ[[2]]
  samp.mat <- result
  
  para_study_se <- paralist("Se.stud", summ)
  para_study_sp <- paralist("Sp.stud", summ)
  
  pool.se <- result[paste0("post.Se[", seq_len(K), "]"), 3]
  pool.sp <- result[paste0("post.Sp[", seq_len(K), "]"), 3]
  
  # 设置分页
  pages <- ceiling(K / max_per_page)
  oldpar <- par(no.readonly = TRUE)
  on.exit(par(oldpar))
  
  for (p in seq_len(pages)) {
    idx_start <- (p - 1) * max_per_page + 1
    idx_end   <- min(p * max_per_page, K)
    idx <- idx_start:idx_end
    n_this <- length(idx)
    
    # 自动调整布局与字体
    par(mfrow = c(n_this, 2), mar = c(5, 5, 2, 1) + 0.1)
    if (n_this > 1) { cex.axis <- 0.9; cex.lab <- 0.9 }
    
    for (k in idx) {
      study_idx <- ((k - 1) * nstu + 1):(k * nstu)
      forest.se <- samp.mat[para_study_se[study_idx], c(1, 3, 5)]
      forest.sp <- samp.mat[para_study_sp[study_idx], c(1, 3, 5)]
      
      # Sensitivity forest plot
      plotCI(
        x = forest.se[, 2], y = seq_len(nstu),
        li = forest.se[, 1], ui = forest.se[, 3],
        xaxt = "n", err = "x",
        xlab = paste(testname[k], " Se(%)"), ylab = "Study ID",
        slty = index[, k], xlim = c(0, 1),
        cex.axis = cex.axis, cex.lab = cex.lab
      )
      abline(v = pool.se[k], lty = 3)
      axis(1, seq(0, 1, 0.1), labels = seq(0, 100, 10), tick = TRUE)
      axis(2, seq_len(nstu), tick = TRUE)
      
      # Specificity forest plot
      plotCI(
        x = forest.sp[, 2], y = seq_len(nstu),
        li = forest.sp[, 1], ui = forest.sp[, 3],
        xaxt = "n", err = "x",
        xlab = paste(testname[k], " Sp(%)"), ylab = "Study ID",
        slty = index[, k], xlim = c(0, 1),
        cex.axis = cex.axis, cex.lab = cex.lab
      )
      abline(v = pool.sp[k], lty = 3)
      axis(1, seq(0, 1, 0.1), labels = seq(0, 100, 10), tick = TRUE)
    }
    
    # 分页提示
    if (pages > 1 && p < pages) {
      readline(prompt = sprintf("Page %d/%d done. Press [Enter] to continue...", p, pages))
    }
  }
  
  invisible(recordPlot())  # 返回可保存的绘图记录
}
