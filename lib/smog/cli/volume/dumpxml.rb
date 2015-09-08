module Smog
  class DumpXmlVolumeCommand < Smog::CLI

    def execute
      cluster.host('uaf-c-05').connection.list_volumes.each do |vol|
        puts vol.inspect
      end
    end
  end
end
