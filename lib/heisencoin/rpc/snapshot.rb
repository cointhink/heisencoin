module Heisencoin  
  class RPC
    module Actions
      def rpc_snapshot(params)
        snapshot = Snapshot.latest
        { snapshot: {id: snapshot.id, date: snapshot.created_at} }
      end
    end
  end
end