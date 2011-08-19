input_file = ENV['map_input_file']
if input_file =~ %r|_left|
  join = 0
elsif input_file =~ %r|_right|
  join = 1
else
  STDERR.puts "error: how do I handle input file '#{input_file}'?"
  exit 0
end

STDIN.each do |line|
  fields = line.chomp.split /\t/, -1
  puts "#{fields[0]}\t#{join}\t#{fields[1]}"
end
