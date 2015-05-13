module Smog
  class CreateVolumeCommand < Smog::CLI
    option '--template', 'TEMPLATE', 'Create volume from template'
    option ['-s', '--size'], 'SIZE', 'Size of volume (GB)', default: 20 do |s|
      Integer(s)
    end
    option '--format', 'FORMAT', 'Format of the volume', default: 'raw'
    option ['-a', '--allocation'], 'ALLOCATION', 'Pre-allocate size in %', default: 0 do |a|
      Integer(a)
    end
    option ['--host'], 'HOST', 'Host to create the pool on'
    option ['-u', '--unique'], :flag, 'Append a unique identifier to the end of the name'

    parameter 'POOL', 'Pool to create volume in', default: 'default'
    parameter 'NAME', 'Name of the volume'

    def execute
      # Ensure the pool exists
      # Ensure the pool is shared unless host is specified
      # Ensure template exists if using a template
      volume_name = if unique?
                      require 'securerandom'
                      ext = File.extname(name)
                      base = File.basename(name, ext)
                      "#{base}-#{SecureRandom.hex(4)}#{ext}"
                    else
                      name
                    end
      puts "Creating #{pool}/#{volume_name}"

      cluster.create_volume(
        pool: pool,
        format: format,
        size: size,
        name: volume_name,
        allocation: allocation,
        host: host
      )
    end
  end
end
