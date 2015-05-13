module Smog
  class SshDomainCommand < Smog::CLI
    option ['--host'], 'HOST', 'Host to run domain on.', required: true
    parameter 'NAME', 'Name of domain'

    def execute
      @conn = cluster.host(host)

      @domain = @conn.connection.servers.all(name: name).first

      puts "Not implemented. Host can be reached at #{@domain.ssh_ip_address}"

      # # @domain.ssh_ip_address = '192.158.122.157'
      # # puts @domain.ssh_proxy.inspect
      # puts @domain.public_ip_address
      # @domain.ssh_ip_address = ->(server) { server.public_ip_address }
      # puts @domain.ssh_ip_address
      # @domain.ssh(['hostname'])
    end
  end
end
