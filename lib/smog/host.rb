require 'fog/libvirt'

module Smog
  class Host
    attr_reader :name
    attr_reader :host
    attr_reader :connection

    def initialize(host)
      @name = host
      @uri = "qemu+ssh://#{host}/system"
      @uri += '?socket=/var/run/libvirt/libvirt-sock' if RUBY_PLATFORM =~ /darwin/
    end

    def connection
      ip_command = %q( awk "/$mac/ {print \$1}" /proc/net/arp )
      @connection ||= Fog::Compute.new(provider: 'Libvirt', libvirt_uri: @uri, libvirt_ip_command: ip_command)
      @connection
    end

    def create_domain(config, template = nil)
      # Remove uuid from the hash.  Fog expects it to be nil for new instances
      uuid = config.delete(:uuid)
      config[:name] = [config[:name], uuid].join('-') if uuid

      volumes = config.delete(:volumes)
      volumes.each { |v| v[:name] = [v[:name], uuid].join('-') } if uuid

      config[:volumes] = template.nil? ? [] : [clone_template(template, config[:name])]

      volumes.each do |vol|
        config[:volumes] << volume_xml(vol[:pool], vol[:name], vol[:size], vol[:format_type])
      end

      puts config.inspect

      domain = connection.servers.new(config)

      domain
    end

    def clone_template(template, name)
      t = connection.volumes.all(name: template).first
      fail "Volume does not exist: #{template}" if t.id.nil?
      puts "Cloning #{template} to #{name} ..."
      t.clone_volume(name)
      connection.volumes.all(name: name).first
    end

    def volume_xml(pool_name, name, size, fmt)
      xml = Smog::DiskXml.for(connection, pool_name).render(name, size, fmt)
      volume = connection.volumes.new(xml: xml, pool_name: pool_name, format_type: fmt)
      volume.save

      volume
    end

    #
    # def status
    # end
    #
    # def domains
    #   connection.list_all_domains
    # end
    #
    # def domain(name)
    #   domains.select { |dom| dom.name == name }.first
    # end
    #
    # def volumes
    #   storage_pools.map { |pool| { pool.name => pool.list_all_volumes } }
    # end
    #
    # def volume(name)
    #   volumes.select { |vol| vol.name == name }
    # end
    #
    # def storage_pools
    #   connection.list_all_storage_pools
    # end
    #
    # def storage_pool(name)
    #   storage_pools.select { |pool| pool.name == name }.first
    # end
    #
    # def create_storage_pool(xml)
    #   pool = connection.define_storage_pool_xml(xml)
    #   pool.build # if pool.info.type == 'netfs' and !pool.active?
    #   pool.create unless pool.active?
    #   pool.autostart = true
    #   pool
    # end
    #
    # def create_volume(pool_name, image_name, size = '20G', fmt = 'raw', allocation='100%')
    #   storage_pool(pool).create_volume(image_name, size, fmt, allocation)
    # end
    #
    # def create_volume_from(pool, xml, template)
    #   storage_pool(pool).create_volume_xml_from(xml, template)
    # end
    #
    # def create_domain(xml)
    #   connection.define_domain_xml(xml)
    # end
    #
    # def start_domain(name)
    #   dom = domain(name)
    #   fail 'Domain not found' if dom.nil?
    #   puts "Staring #{name} on #{@host}"
    #   puts "#{dom.inspect} - #{dom.state}"
    #   dom.create unless dom.active?
    # end
  end
end
