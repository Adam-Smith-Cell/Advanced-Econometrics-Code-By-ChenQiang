cd "D:\file\stata file"
mkdir code2
cd "code2"
sysuse auto
describe
// 直方图检验是否正态
hist mpg,normal
// 核密度图检验是否正态
kdensity mpg,normal
// QQ图检验
qnorm mpg
// 以下是某些检验正态方法，pr接近0，则拒绝正态原假设。
sktest mpg
graph save "Graph" "D:\file\stata file\code1\example1.gph"
swilk mpg
graph save "Graph" "D:\file\stata file\code1\example2.gph"
sfrancia mpg
graph save "Graph" "D:\file\stata file\code1\example3.gph"
//对数化数据，使之正态化。
gen lnmpg=log(mpg)
kdensity lnmpg,normal
graph save "Graph" "D:\file\stata file\code1\example4.gph"
sktest lnmpg
// JB检验正态。参考流程如下。
sum mpg,detail
di (r(N)/6)*((r(skewness)^2)+((1/4)*(r(kurtosis)-3)^2))
di chi2tail(2, 14.031924)