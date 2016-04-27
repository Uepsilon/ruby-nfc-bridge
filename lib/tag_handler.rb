require 'nfc'
require 'logger'
require_relative '../lib/errors';

class TagHandler
  attr_reader :reader, :logger
  attr_accessor :last_tag

  def initialize
    @logger = Logger.new(File.expand_path('../logs/tag_helper.log', __dir__))

    open_reader
  rescue RuntimeError
    raise Errors::ReaderMissing
  end


  def wait_for_tag(wait_timeout = 1)
    handle_new_tag reader.poll(1, 2)
  end

  private

  def open_reader
    # Create a new context
    ctx = NFC::Context.new
    @logger = Logger.new(File.expand_path('../logs/tag_helper.log', __dir__))

    # Open the first available USB device
    @reader = ctx.open reader
  end

  def handle_new_tag(tag_info)
    if ['0', @last_tag.to_s].include? tag_info.to_s
      logger.debug "Got #{tag_info.to_s}" unless tag_info.to_s == '0'
      return false
    elsif tag_info.to_s.to_i < 0
      raise Errors::ReaderMissing
    end
    logger.debug "It's a new Tag: #{tag_info.to_s}"
    @last_tag = tag_info
  end
end
