require "catalogillo/engine"
require "catalogillo/config"
require "catalogillo/exceptions"

module Catalogillo

  def self.config
    yield Catalogillo::Config
  end

end
