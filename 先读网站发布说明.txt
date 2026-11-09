# NMADTA 网站使用说明

本项目使用 pkgdown，与参考的 cubble 网站采用同一类 R 包文档站结构。
网页源文件与生成的 docs 文件夹均已包含，无需运行 R 就能发布现有页面。

## GitHub Pages 发布

仓库：https://github.com/KevinXing3/NMADTA
网站：https://kevinxing3.github.io/NMADTA/

Settings → Pages 的 Source 使用 GitHub Actions。
在 Actions → Publish package website → Run workflow 可发布已有 docs。
选中 Rebuild documentation with R before publishing 可重新构建文档后发布。
推送 docs 文件夹的修改也会自动发布。普通发布不会重新运行 MCMC。

## 本地更新

需要 R、JAGS、Pandoc，以及 pkgdown、rmarkdown、knitr 和 NMADTA 的依赖。
在项目根目录运行：

~~~r
install.packages(c("pkgdown", "rmarkdown", "knitr", "devtools"))
devtools::install(".", upgrade = "never")
source("tools/build-site.R")
~~~

README.md 生成首页；man 生成函数文档；vignettes 生成教程。
修改后重新构建即可。复制代码、站内搜索、移动端导航由 pkgdown 提供。

重新运行模型、生成示例图后再构建：

~~~r
source("tools/reproduce-example.R")
source("tools/build-site.R")
~~~

MCMC 需要时间；普通网站构建不会重新运行模型。
更改数据或模型设置后，也应同步更新教程中展示的数值结果。

## 主要文件

- _pkgdown.yml：导航、主题和函数分类
- man/figures/logo.png：最终选定的原图透明背景 Logo
- pkgdown/assets/figures：真实模型输出图
- pkgdown/assets/example：CSV 输入、摘要和运行环境
- docs：可直接部署的完整静态网站

## 来源与修改范围

软件源码来自 CRAN NMADTA 0.1.4：
https://cran.r-project.org/src/contrib/NMADTA_0.1.4.tar.gz

保留原作者名单和 GPL (>= 2) 许可。新增网站内容、示例脚本、
主题配置和论文引用；未修改统计函数、JAGS 模型或数据。
dat.kang 文档的疾病名称按 RSM 论文改为 deep vein thrombosis；
原 CRAN 说明的 colorectal cancer 与论文不一致。
网站示例使用 0.1.4，论文示例使用 0.1.3，数值可随运行环境变化。
论文：https://doi.org/10.1017/rsm.2026.10097
Logo 使用内置 imagegen 制作，最终版由您选定。
提示词记录在 pkgdown/logo-prompt.txt。

.openai 仅用于另行提供的私有预览，不需要上传至您的 GitHub 仓库。

正式 GitHub Pages 发布后，将 _pkgdown.yml 的 url 改为 GitHub 显示的正式网址再构建，可更新网站的 canonical 和社交分享地址。
