require "catalogillo/engine"
require "catalogillo/config"

module Catalogillo

  def self.config
    yield Catalogillo::Config
  end

end
