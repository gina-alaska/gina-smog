module Smog
  class InfoDomainCommand < Smog::CLI
    option ['--host'], 'HOST', 'Host to run domain on.', required: true
    parameter 'NAME', 'Name of domain'

    def execute
      @conn = cluster.host(host)

      @domain = @conn.connection.servers.all(name: name)

      puts @domain.inspect
    end
  end
end
