require 'timeout'
require 'nfc'

class TagHandler
  attr_reader :reader
  attr_accessor :last_tag

  def initialize(reader=nil)
    # Create a new context
    ctx = NFC::Context.new

    # Open the first available USB device
    @reader = ctx.open reader
  end

  def wait_for_tag(wait_timeout = 1)
    Timeout::timeout(wait_timeout) do 
      tag_info = dev.select
    end

    handle_new_tag tag_info
  rescue Timeout::Error
    false
  end

  def handle_new_tag(tag_info)
    return false if tag_info.to_s == @last_tag.to_s

    @last_tag = tag_info
  end 
end 
