module Smog
  class CreateDomainCommand < Smog::CLI
    option '--cpu', 'CPU', 'Number of cpu cores', defaut: 1 do |c|
      Integer(c)
    end
    option ['-m', '--memory'], 'MEMORY', 'Amount of memory to allocate (in MB)', default: 1024 do |m|
      Integer(m)
    end
    option ['-d', '--disk'], 'DISK', 'Disk to attach in the format of [pool/]disk[,20[,qcow2]] (default: default/NAME.img). Disk will be created if necessary.', multivalued: true, required: true
    option ['-b', '--bridge'], 'BRIDGE', 'Network interface to use', default: 'br3'
    option ['--host'], 'HOST', 'Host to run domain on. (default: *best fit* NYI)', required: true
    option ['-t', '--template'], 'TEMPLATE', 'Use TEMPLATE as os disk, [pool/]disk'
    option ['-u', '--unique'], :flag, 'Append unique identifier to NAME'

    parameter 'NAME', 'Name of domain'

    def execute
      @conn = cluster.host(host)
      @domain = @conn.create_domain(config, template)
      @domain.save

      puts "#{@domain.name} created."
      puts "CPU: #{@domain.cpus}"
      puts "Memory: #{@domain.max_memory_size}"
      @domain.nics.each_with_index do |network, idx|
        puts "Network-#{idx}: "
        puts " -- MAC: #{network.mac}"
      end
      @domain.volumes.each_with_index do |volume, idx|
        puts "Disk-#{idx}: "
        puts " -- Format: #{volume.format_type}"
        puts " -- Capacity: #{volume.capacity}"
        puts " -- Allocation: #{volume.allocation}"
      end

      puts "\n\nDHCP Configuration:"
      puts "host #{@domain.name} {"
      puts "  hardware ethernet #{@domain.nics.first.mac};"
      puts "  fixed-address X.X.X.X;"
      puts "}"

      puts "\n\nDNS Entry:"
      puts "update add #{@domain.name}.x.gina.alaska.edu 48600 IN A X.X.X.X"
    end

    def config
      uuid = if unique?
               require 'securerandom'
               SecureRandom.hex(2)
             else
               nil
             end

      config = {
        cpus: cpu,
        memory_size: memory * 1024,
        name: name,
        volumes: disk_config,
        nics: [{
          type: 'bridge',
          bridge: bridge
        }]
      }
      config[:uuid] = uuid unless uuid.nil?
      config
    end

    def disk_config
      config = []
      disk_list.each do |d|
        disk, size, fmt = d.split(',')
        size ||= '20'
        fmt ||= 'raw'
        pool, disk = if disk.include?('/')
                       disk.split('/')
                     else
                       ['default', disk]
                     end
        config << {
          pool: pool,
          name: disk,
          size: size,
          format_type: fmt
        }
      end

      config
    end
  end
end
