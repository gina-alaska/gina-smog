require 'yaml'

module Smog
  class Config
    attr_reader :config
    def initialize(file)
      @config = YAML.load_file(file)
    end

    def self.load_file(file)
      new(file)
    end

    def nodes
      @config[:nodes]
    end

    def node(name)
      @config[:nodes][name.to_sym]
    end
  end
end
