//arima y, ar(1/#) ma(1/#) 
//arima y, arima(#p, #d, #q),p AR自回归阶数,d,差分平稳时间序列,q MA移动平均阶数
//arima y x1 x2 x3,ar(#) ma(#) ARMAX模型
cd "D:\file\stata file\code 12"
use "D:\file\stata file\datasets_2ed\pe.dta"
g d_logpe = d.logpe // 构造一期滞后项
* 显示自相关系数和偏自相关系数,10阶
corrgram d_logpe, lags(10) 
* 画自相关图
ac d_logpe, lags(10)
* 画偏自相关图
pac d_logpe,lags(10)
* 做4阶AR回归
arima d_logpe,ar(1/4) nolog
* 检验回归阶数是否过度
estat ic
* 生成残差值并且检验是否自相关
predict el, res
corrgram el, lags(10)
* 4阶MA回归
arima d_logpe,ma(1/4) nolog
estat ic
predict e2,res
corrgram e2,lags(10)
* 包含2阶4阶滞后期的回归.
arima d_logpe,ar(2 4) nolog
estat ic
arima d_logpe,ma(2 4) nolog
estat ic
di "AR(2 4)模型更适合"
// var模型
use "D:\file\stata file\datasets_2ed\macro_swatson.dta", clear
*寻找最佳var滞后期
varsoc dinf unem
di "打星号的哪一行数据所对应的滞后期最佳"
// var模型回归,exog(w1 w2)选项,表示外生变量
var dinf unem, lags(1/2)
di "如果样本量小于30,最好使用选择项dfk(小样本自由度调整),small(显示小样本的t分布和F分布)"
varwle // 对var联合方程进行联合显著检验.
varlmar  // 对残差是否存在自相关进行检验
varstable,graph  // 检验特征值是否在单位圆内部,并做图
varnorm // 检验残差项是否正态分布.
vargranger //进行格兰杰因果检验
* 建立脉冲文件的语句 irf create filename,set(filename) step(#) replace. set(filename)表示设置为当前文件
irf create macro, set(macro) replace
* 画脉冲响应图 
irf graph irf
* 画正交化的脉冲响应图
irf graph oirf
var dinf unem if quarter<tq(1999q1),lags(1/2)
* 估计VAR后,计算被解释变量未来step(#)期的预测值,
fcast compute f_,step(10)
* compute之后,画出预测值,选择项observed表示与实际观测值比较.
fcast graph f_dinf f_unem, observed lpattern("_")
