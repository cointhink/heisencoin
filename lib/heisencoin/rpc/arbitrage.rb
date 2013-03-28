module Heisencoin  
  class RPC
    module Actions
      def rpc_arbitrage(params)
        # defaults
        opts = {
          exchange_names: params['exchanges'] || Exchange.actives.map{|e| e.slug},
                currency: params['currency']  || 'usd'
          }
    
        snapshot = Snapshot.last
        exchanges = opts[:exchange_names].map{|name| Exchange.find(name)}
    
        actions, markets = Strategy.opportunity('btc', opts[:currency], exchanges, snapshot)
    
        # Full accounting
        #strategy = Strategy.analyze(actions)
        #snapshot.update_attribute :strategy, strategy
        #puts "Linked strategy ##{strategy.id} to snapshot ##{snapshot.id} #{snapshot.created_at}"
    
        # Summary
        usd_in = Balance.make_usd(0)+actions.sum{|a| a[:sells].sum{|s| a[:buy].cost(s[:spent])}}
        usd_out = Balance.make_usd(0)+actions.sum{|a| a[:sells].sum{|s| s[:offer].cost(s[:spent])}}
    
        { cache: Time.now,
          snapshot: {id: snapshot.id, date: snapshot.created_at},
          exchanges: markets,
          balance_in: usd_in.to_h,
          balance_out: usd_out.to_h,
        }

      end
    end
  end
end