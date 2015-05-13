module Smog
  class StartDomainCommand < Smog::CLI
    option ['-f', '--force'], 'F', 'Force the action'
    option ['--host'], 'HOST', 'The host to start the domain on (default: first node in the cluster)'
    parameter 'domain', 'The name of the domain to start'

    def execute
      cluster.start_domain(domain, host)
    end
  end
end
