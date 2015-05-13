module Smog
  class DiskXml < Xml
    def initialize(xml)
      @xml = xml
    end

    def self.for(conn, name)
      uuid = conn.list_pools(name: name).first[:uuid]
      pool = conn.client.lookup_storage_pool_by_uuid uuid
      new pool.xml_desc
    end

    def render(name, size, fmt = 'qcow2')
      opts = { path: pool_path, name: name, size: size, format: fmt }
      template("#{pool_type}-volume") % opts
    end

    private

    def pool_type
      (Nokogiri::XML(@xml) / 'pool').first[:type]
    end

    def pool_path
      (Nokogiri::XML(@xml) / 'path').text
    end
  end
end
