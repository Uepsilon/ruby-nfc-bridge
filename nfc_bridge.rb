Dir['./lib/*.rb'].each { |file| require file }

def call_url_with_uid(tag_uid)
  url = "http://cowokatra.apps.railslabs.com/cards/#{tag_uid.to_s}"
  @logger.info "Opening URL: #{url}"

  # system "DISPLAY=:0 chromium-browser --kiosk --disable-session-crashed-bubble --noerrdialogs #{url}"
  # `open #{url}`
end

def wait_for_tag(tag_handler)
  tag_info = tag_handler.wait_for_tag
  if tag_info
    call_url_with_uid(tag_info.to_s) if tag_info.to_s
  end
end

@logger = Logger.new(File.expand_path('logs/tag_helper.log', __dir__))

loop do
  begin
    @tag_handler = TagHandler.new unless @tag_handler.is_a?(TagHandler)

    wait_for_tag @tag_handler
  rescue Errors::ReaderMissing
    @tag_handler = nil
    seconds = 5

    @logger.error "Reader gone, waiting #{seconds} seconds"
    sleep seconds
    @logger.error 'Retry'
    next
  end
end

