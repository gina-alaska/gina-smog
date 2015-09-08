require 'smog/cli/volume/create'
require 'smog/cli/volume/dumpxml'

module Smog
  class VolumeCommand < Clamp::Command
    subcommand 'create', 'Create a volume', Smog::CreateVolumeCommand
    subcommand 'dumpxml', 'Dump Vol XML', Smog::DumpXmlVolumeCommand
  end
end
