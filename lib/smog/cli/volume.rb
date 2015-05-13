require 'smog/cli/volume/create'

module Smog
  class VolumeCommand < Clamp::Command
    subcommand 'create', 'Create a volume', Smog::CreateVolumeCommand
  end
end
