# Heisencoin

A toolbox of financial computations with a focus on cryptocoin markets.

### Install

```
gem install heisencoin
```

### Examples

Two exchanges, coinland and discountcoin are trading GalaxyCoins for NeoCoins.

```
require 'heisencoin'
include Heisencoin

calc = Arbitrage.new
exchange1 = Exchange.new({'name' =>'coinland'})
exchange2 = Exchange.new({'name' =>'discountcoin'})
calc.add_exchanges([exchange1, exchange2])

# after HTTP call to coinland api
depth = {'asks' => [[6.1,1.0]], 'bids' => [[5.8,1.0]]}
calc.add_depth(exchange1, depth)

# after HTTP call to discouncoin api
depth = {'asks' => [[5.5,1.0]], 'bids' => [[5.0,1.0]]}
calc.add_depth(exchange2, depth)

# Calculate all profitable trades
calc.plan
=> [[#<Heisencoin::Exchange:0x007fc5544f3c80 @name="coinland">, 5.8,
     #<Heisencoin::Exchange:0x007fc5544e9be0 @name="discountcoin">, 5.5,
     1.0]]
```

The calculated plan is to buy from discountcoin at 5.5 neocoins, quantity 1, and sell them to coinland for 5.8 neocoins.
