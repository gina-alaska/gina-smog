module Smog
  class CreatePoolCommand < Smog::CLI
    option ['--host'], 'HOST', 'Remote host that provides the shared storage pool'
    option ['--shared'], :flag, 'Is the pool a shared pool', default: false

    parameter 'PATH', 'Path to the storage pool'
    parameter 'NAME', 'name of volume'
    def execute
      if shared? and host.nil?
        abort('You must specify --host when using --shared')
      end
      cluster.create_storage_pool(name: name, host: host, path: path, shared: shared?)
    end
  end
end
