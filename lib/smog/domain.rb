module Smog
  class Domain
    # Takes a Libvirt::Domain Object
    def initalize(dom)
      @dom = dom
    end

    def start
      @dom.start
    end

    def stop
      @dom.stop
    end
  end
end
