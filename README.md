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

exchange1 = Exchange.new({'name' =>'coinland',
                          'time' => "1970-01-01",
                          'depth' => {'asks' => [[6.1,1.0]], 'bids' => [[5.8,1.0]]}
                         })

exchange2 = Exchange.new({'name' =>'discountcoin',
                          'time' => "1970-01-01",
                          'depth' => {'asks' => [[5.5,1.0]], 'bids' => [[5.0,1.0]]}
                         })
calc = Arbitrage.new
calc.add_exchanges([exchange1, exchange2])
calc.plan
=> [["coinland", "discountcoin", 5.5, 1.0]]
```

The calculated plan is to buy from discountcoin at 5.5 neocoins, quantity 1, and sell them to coinland.
