require 'builder'
require 'nokogiri'

module Smog
  class Xml
    private

    def template(name)
      File.read(File.join(template_path, "#{name}.xml"))
    end

    def template_path
      File.join(File.dirname(__FILE__), '../..', 'templates')
    end
  end
end

require 'smog/xml/pool'
require 'smog/xml/disk'
require 'smog/xml/domain'
