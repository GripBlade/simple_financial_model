# Sample Hardhat Project

项目发行方，规定了用于奖励的货币总数，以及奖励的速率，即固定了单位时间内的奖励总金额，用户的具体奖励为每一小段内的奖励总金额乘以用户质押的份额，并按时间段进行累加。
有一点类似于用于微积分求面积的积分，即积分的定义域为时间，积分的积分值为奖励总金额。

但是，如果照搬公式，那么难以在代码中实现具体逻辑，因此我需要采用合理算法逻辑，优化计算
我们可以假设userStake是一个不变的量
那么公式变成了 ```userReward = userStake * ∑（  Reward / totalAmount)```
reward十分地好计算，即为时间乘上奖励速率（tokenPer） 
totalAmount，为所有用户质押总量，仅仅在有用户进行质押时改变，
```
假设在t1，t2时刻，分别有用户1，用户2，进行了质押(s1,s2)，
所以，当t3时刻时，∑（  Reward / totalAmount)  = （t2-t1）*tokenPer/s1 + （t3-t2）*tokenPer/(s1+s2),
所有我们可以推出，当有用户质押时，可以编写一个函数改变∑（  Reward / totalAmount)即可。
```
同理，当userStake，在t1改变时，userReward = userReward(t1)+ userStake * ∑（  Reward / totalAmount) ,即可


