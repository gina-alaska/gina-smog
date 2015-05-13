module Smog
  class StopDomainCommand < Clamp::Command
    option ['-f', '--force'], 'F', 'Force the action'

    # subcommand "Start", "Start a domain", Smog::StartDomainCommand
    # subcommand "Stop", "Stop a domain", Smog::StopDomainCommand
    # subcommand "Pause", "Pause a domain", Smog::PauseDomainCommand
    # subcommand "Create", "Create a domain", Smog::CreateDomainCommand
    # subcommand "Migrate", "Migrate a domain", Smog::MigrateDomainCommand
    #
    def execute
    end
  end
end
