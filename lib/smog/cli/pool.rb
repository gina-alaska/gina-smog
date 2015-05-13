require 'smog/cli/pool/list'
require 'smog/cli/pool/create'

module Smog
  class PoolCommand < Smog::CLI
    subcommand 'list', 'List pools on each host in the cluster', Smog::ListPoolCommand
    subcommand 'create', 'Create a storage pool on each host in the cluster', Smog::CreatePoolCommand
  end
end
