cd "D:\file\stata file\code3"
use "D:\file\stata file\datasets_2ed\nerlove.dta"
reg lntc lnq lnpl lnpk lnpf
* 画残差关于拟合值的散点图
rvfplot
* 画残差关于某些自变量的散点图
rvpplot lnq
* 进行怀特异方差检验
estat imtest,white
* 进行BP，独立同分布假设检验（关于y拟合值，解释变量集合，特定解释变量）
estat hettest, iid
estat hettest, rhs iid
estat hettest lnq,iid
* 以下开始FGLS回归
quietly reg lntc lnq lnpl lnpk lnpf
// 生成残差
predict el,res
* 残差取负数
gen e2 = el^2
*取对数
g lne2 = log(e2)
*进行回归
reg lne2 lnq,noc
* 生成拟合值并取对数
predict lne2f
gen e2f =exp(lne2f)
* 最终的WLS
reg lntc lnq lnpl lnpk lnpf [aw=1/e2f]