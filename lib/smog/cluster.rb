require 'fog/libvirt'

module Smog
  class Cluster
    attr_accessor :hosts

    def initialize(nodes = [])
      @hosts = []

      Array(nodes).each do |node|
        @hosts << Smog::Host.new(node)
      end
    end

    def self.connect(nodes = [])
      new nodes
    end

    def status
      hosts.map(&:list_domains)
    end

    def domains
      hosts.map { |host| { host.name => conn.domains } }
    end

    def host(name)
      possible_hosts = hosts.select { |host| host.name =~ /#{name}/ }

      fail "#{name} matches too many hosts" if possible_hosts.count > 1
      possible_hosts.first
    end

    def create_storage_pool(opts)
      if storage_pools.map(&:name).include?(opts[:name])
        puts "Pool #{opts[:name]} already exists"
        return false
      end

      xml = if opts[:shared]
              template('gluster-pool') % opts
            else
              opts[:device_name] = File.basename(opts[:path])
              template('lvm-pool') % opts
            end
      hosts.each do |host|
        puts "Defining #{opts[:name]} on #{host}"
        host.create_storage_pool(xml)
      end
    end

    def create_volume(name, size = '20G', fmt = 'raw', opts = {})
      target_host = opts.delete(:host)
      target_host = if target_host.nil?
                      hosts.first
                    else
                      host(target_host)
                    end

      pool_type = pool_type_from_xml(opts[:pool])
      xml = template("#{pool_type}-volume") % opts

      target_host.create_volume(opts[:pool], xml)
    end

    def storage_pools
      hosts.map(&:storage_pools).flatten
    end

    def storage_pool(name)
      storage_pools.select { |pool| pool.name == name }.first
    end

    def create_domain_on(host_name, opts)
      disks = opts.delete(:disks)
      opts[:disks] = disks.map do |disk|
        pool, image = if disk.include?('/')
                        disk.split('/')
                      else
                        ['default', disk]
                      end

        disk_xml_for(pool, image)
      end.join("\n")

      xml = template('domain') % opts
      host(host_name).create_domain(xml)
    end

    def start_domain(name, host_name)
      hosts(host_name).start_domain(name)
    end
  end
end
