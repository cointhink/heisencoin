# Heisencoin

A toolbox of financial computations with a focus on cryptocoin markets.

### Install

```
gem install heisencoin
```

### Arbitrage

Two exchanges, coinland and discountcoin are trading GalaxyCoins for NeoCoins.

```
require 'heisencoin'
include Heisencoin

calc = Arbitrage.new
exchange1 = Exchange.new({'name' =>'coinland', 'fee' => 0.005})
exchange2 = Exchange.new({'name' =>'discountcoin', 'fee' => 0.004})
calc.add_exchanges([exchange1, exchange2])

# asks and bids are [price, quantity]
# after HTTP call to coinland api
depth = {'asks' => [[6.1,1.0]], 'bids' => [[5.8,1.0]]}
calc.add_depth(exchange1, depth)

# after HTTP call to discouncoin api
depth = {'asks' => [[5.5,1.0]], 'bids' => [[5.0,1.0]]}
calc.add_depth(exchange2, depth)

# Calculate all profitable trades
calc.plan
=> #<Heisencoin::Plan:0x007fe686c8bdc8 @steps=[#<Heisencoin::Trade:0x007fe686c8ba30 @from_offer=#<Heisencoin::Offer:0x007fe686c8b9e0 @exchange=#<Heisencoin::Exchange:0x007fe686c8b990 @name="discountcoin", @fee=0.004>, @price=5.5, @quantity=1.0>, @to_offer=#<Heisencoin::Offer:0x007fe686c8b8a0 @exchange=#<Heisencoin::Exchange:0x007fe686c8b850 @name="coinland", @fee=0.005>, @price=5.8, @quantity=1.0>, @quantity=1.0>], @state="planning">
```


The calculated plan is to buy from discountcoin at price 5.5 neocoins, quantity 1, and sell them to coinland for 5.8 neocoins.
