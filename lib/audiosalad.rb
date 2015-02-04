require "audiosalad/api"
require "audiosalad/release"
require "audiosalad/track"
require "audiosalad/version"
require "audiosalad/engine"
require "audiosalad/config"

module AudioSalad
  def self.config(&block)
    if block
      block.call(AudioSalad::Config)
    else
      AudioSalad::Config
    end
  end
end
