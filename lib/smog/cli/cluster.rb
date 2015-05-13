require 'smog/cli/cluster/status'

module Smog
  class ClusterCommand < Smog::CLI
    subcommand 'status', 'Print cluster status', Smog::ClusterStatusCommand
  end
end
