require 'clamp'
require 'smog'
require 'smog/config'

module Smog
  class CLI < Clamp::Command
    option ['-c', '--conf'], 'CONFIG', 'Configuration File (Default: [.smog.yml, ~/.smog.yml])' do |c|
      c if ::File.exist?(c)
    end

    def initialize(invocation_path, context = {}, parent_attribute_values = {})
      super

      conf = default_config_file if conf.nil?
      @@config ||= Smog::Config.load_file(conf)
    end

    private

    def default_config_file
      ['.smog.yml', '~/.smog.yml'].select do |f|
        ::File.exist?(::File.expand_path(f))
      end.first
    end

    def cluster
      @@cluster ||= ::Smog::Cluster.connect(@@config.nodes)
      @@cluster
    end

    def config
      @@config
    end
  end

  require 'smog/cli/cluster'
  require 'smog/cli/domain'
  require 'smog/cli/pool'
  require 'smog/cli/volume'

  class SmogCommand < Smog::CLI
    subcommand 'cluster', 'Cluster-wide command', ::Smog::ClusterCommand
    subcommand 'domain', 'Manage domains in a libvirt cluster', ::Smog::DomainCommand
    subcommand 'pool', 'Manage storage pools in a libvirt cluster', ::Smog::PoolCommand
    subcommand 'volume', 'Manage volumes in a libvirt cluster', ::Smog::VolumeCommand
  end
end
