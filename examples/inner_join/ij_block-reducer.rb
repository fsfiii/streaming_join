require 'streaming_join'

Join.new.process_stream do |line|
  puts line
end
