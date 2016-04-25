require './tag_handler'

def call_url_with_uid(tag_uid)
  url = "http://cowokatra.apps.railslabs.com/cards/#{tag_uid.to_s}"
  p "Opening URL: #{url}"

  # system "DISPLAY=:0 chromium-browser --kiosk --disable-session-crashed-bubble --noerrdialogs #{url}"
  `open #{url}`
end

stop_loop = false
tag_handler = TagHandler.new

# Trap ^C 
Signal.trap("INT") { 
  stop_loop = true
}

# Trap `Kill `
Signal.trap("TERM") {
  stop_loop = true
}

while !stop_loop
  tag_info = tag_handler.wait_for_tag 
  if tag_info
    call_url_with_uid(tag_info.to_s) if tag_info.to_s
  end
end

