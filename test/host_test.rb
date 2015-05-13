require_relative 'test_helper'
require 'smog/host'
require 'ostruct'

class SmogHostTest < Minitest::Test
  def setup
    @host = Smog::Host.new('somehost')
    @libvirt = mock
    @libvirt.stubs(:open).returns('foo')
    @host.instance_variable_set(:@connection, @libvirt)
  end

  def test_initialize
    assert_equal 'somehost', @host.name
  end

  def test_connection
    assert_same @libvirt, @host.connection
  end

  def test_domains
    @libvirt.expects(:list_all_domains)
    @host.domains
  end

  def test_domain
    # domain = OpenStruct.new(name: 'foo.worker')
    # @host.stubs(:domains).returns([domain])

    assert_equal 'foo.worker', @host.domain('foo.worker')
    assert_nil @host.domain('doesnt-exist')
  end

  def test_storage_pools
    @libvirt.expects(:list_all_storage_pools)
    @host.storage_pools
  end

  def test_storage_pool
    # pool = OpenStruct.new(name: 'pool1')
    # @host.stubs(:storage_pools).returns([pool])
    @libvirt.expects(:list_all_storage_pools).returns(['something tat responsds to name'])

    assert_equal 'pool1', @host.storage_pool('pool1').name
    assert_nil @host.storage_pool('doesnt-exist')
  end

  def test_volumes
    # storage_pools = [
    #   OpenStruct.new(name: 'pool1', list_all_volumes: ['volume1'])
    # ]
    # @host.stubs(:storage_pools).returns(storage_pools)
    #
    # assert_equal { 'pool1' => ['volume1'] }, @host.volumes
  end
end
