use "D:\file\stata file\datasets_2ed\nerlove.dta"
// 简要查看数据情况
summarize
describe
//普通线性回归
reg lntc lnq lnpf lnpk lnpl
//稳健线性回归
reg lntc lnq lnpf lnpk lnpl,robust
//检验系数
test lnq = 1
//检验非线性方程
testnl _b[ lnpl ] = _b[ lnq ]^2