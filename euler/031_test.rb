
Solution by counting down each denomination:

count = 0
200.step(0, -200) {|a|
    a.step(0, -100) {|b|
        b.step(0, -50){|c|
            c.step(0, -20){|d|
                d.step(0, -10){|e|
                    e.step(0, -5){|f| 
                        f.step(0, -2){|g|
                            count += 1}}}}}}}
p count


Recursive solution in C/C++

#include <iostream>

int coins[8] = {200, 100, 50, 20, 10, 5,2,1};

int findposs(int money, int maxcoin)
{
    int sum = 0;
    if(maxcoin == 7) return 1;
    for(int i = maxcoin; i<8;i++)
    {
        if (money-coins[i] == 0) sum+=1;
        if (money-coins[i] > 0) sum+=findposs(money-coins[i], i);
    }
    return sum;     
}

int main()
{
    cout<<findposs(200, 0)<<endl;
}

Recursion in Ruby

def combinations(amount, maxCoin)
  return 1 if amount==0
  count = 0
  for c in @coins
    count += combinations(amount-c, c) if amount >= c and c >= maxCoin
  end
  count
end

Dynamic Programming (Ruby). Runs in .06 secs

coins = [200, 100, 50, 20, 10, 5, 2, 1]
def ways sum, head, *rest
  return 1 if rest.empty?
  ws = 0
  0.upto sum / head do |i|
    ws += ways(sum - head * i, *rest)
  end
  ws
end
p ways(200, *coins)