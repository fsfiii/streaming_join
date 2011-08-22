require 'streaming_join'

j = JoinMapper.new

# take column 0 and column 1 from the left (key is the first)
j.add_side(/_left/, 0, 1)
# take columns 0, 1, and 2 from the right
# also add a filter (reindexed by output columns)
j.add_side(/_right/, 0, 1, 2) {|c| c[2].to_i < 2000}

# add an option for the right side
# tab already is the default separator, so this is just an example
j.add_opts(/_right/, sep: "\t")

# process the STDIN loop
j.process_stream
