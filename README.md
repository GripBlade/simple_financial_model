# simple_financial_model

这个项目旨在记录我在学习 Web3 过程中遇到的一些经济模型的基本概念和代码实现。使用框架为hardhat

## 1 质押离散 discrete staking model
### 项目背景:
该质押奖励激励用户 投入自己的代币，来支持某一个项目，并通过回报机制（时间，以及数量）来反馈于支持者
### 具体实现:
项目发行方，规定了用于奖励的货币总数，以及奖励的速率，即固定了单位时间内的奖励总金额，用户的具体奖励为每一小段内的奖励总金额乘以用户质押的份额，并按时间段进行累加。
有一点类似于用于微积分求面积的积分，即积分的定义域为时间，积分的积分值为奖励总金额。

详情见项目1

## 2 ido


