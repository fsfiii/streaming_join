require 'streaming_join'

j = JoinMapper.new

# For our first side (beginning on the left), use the input filename
# matching the regular expression of /_left/.
# Take column 0 and column 1 from that file (key is the first). 
j.add_side(/_left/, 0, 1)

# For the right side, use the input filename matching /_right/.
# Take columns 0, 1, and 3.
# Also add a filter (reindexed by output columns).
# Records for which the block returns false will be discarded.
j.add_side(/_right/, 0, 1, 2) {|c| c[2].to_i < 2000}

# Add an option for the right side.
# (tab already is the default separator, so this is just an example)
j.add_opts(/_right/, sep: "\t")

# process the STDIN loop
j.process_stream
