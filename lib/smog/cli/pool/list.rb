module Smog
  class ListPoolCommand < Smog::CLI
    def execute
      cluster.hosts.each do |host|
        puts host.list_pools
        # puts host
        # puts '--------'
        # conn.storage_pools.each do |pool|
        #   puts "#{pool.name} - #{pool.info.allocation / (1024 * 1024)}MB/#{pool.info.capacity / (1024 * 1024)}MB"
        # end
      end
    end
  end
end
