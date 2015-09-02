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
      puts @domain.inspect
      @domain.save
      @domain.start

      puts "Booting #{@domain.name}.. please wait"
      ip = false
      Fog.wait_for(120, 5) do
        puts @domain.public_ip_address
        ip = @domain.public_ip_address if @domain.public_ip_address

        ip
      end

      puts "#{@domain.name} booted with ip #{ip}"
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
        fmt ||= 'qcow2'
        pool, disk = if disk.include?('/')
                       disk.split('/')
                     else
                       ['default', disk]
                     end
        config << {
          pool: pool,
          name: disk,
          size: size,
          format: fmt
        }
      end

      config
    end
  end
end
