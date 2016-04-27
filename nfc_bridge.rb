require './tag_handler'

def call_url_with_uid(tag_uid)
  url = "http://cowokatra.apps.railslabs.com/cards/#{tag_uid.to_s}"
  @logger.info "Opening URL: #{url}"

  # system "DISPLAY=:0 chromium-browser --kiosk --disable-session-crashed-bubble --noerrdialogs #{url}"
  # `open #{url}`
end

@logger = Logger.new(File.expand_path('logs/tag_helper.log', __dir__))

tag_handler = TagHandler.new
loop do
  tag_info = tag_handler.wait_for_tag
  if tag_info
    call_url_with_uid(tag_info.to_s) if tag_info.to_s
  end
end
