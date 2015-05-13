require 'smog/cli/domain/start'
require 'smog/cli/domain/stop'
require 'smog/cli/domain/pause'
require 'smog/cli/domain/create'
require 'smog/cli/domain/migrate'
require 'smog/cli/domain/info'
require 'smog/cli/domain/ssh'

module Smog
  class DomainCommand < Clamp::Command
    option ['-f', '--force'], 'F', 'Force the action'

    # subcommand 'start', 'Start a domain', Smog::StartDomainCommand
    # subcommand 'stop', 'Stop a domain', Smog::StopDomainCommand
    # subcommand 'pause', 'Pause a domain', Smog::PauseDomainCommand
    subcommand 'create', 'Create a domain', Smog::CreateDomainCommand
    # subcommand 'migrate', 'Migrate a domain', Smog::MigrateDomainCommand
    subcommand 'info', 'Get information about a domain', Smog::InfoDomainCommand
    subcommand 'ssh', 'Ssh to domain', Smog::SshDomainCommand
    def execute
    end
  end
end
