Gem::Specification.new do |s|
  s.name = 'streaming_join'
  s.rubyforge_project = 'streaming_join'
  s.version = '0.2.0'
  s.date = '2011-08-22'
  s.authors = ["Frank Fejes"]
  s.email = 'frank@fejes.net'
  s.summary =
    'Classes to process joins in Hadoop Map/Reduce Streaming.'
  s.homepage = 'https://github.com/fsfiii/streaming_join'
  s.description =
    'Classes to process various joins in Hadoop Map/Reduce Streaming.'
  s.files = [
    "README",
    "CHANGELOG",
    "lib/streaming_join.rb",
    "lib/streaming_join/join.rb",
    "lib/streaming_join/left_outer_join.rb",
    "lib/streaming_join/right_outer_join.rb",
    "lib/streaming_join/full_outer_join.rb",
    "lib/streaming_join/cross_join.rb",
    "lib/streaming_join/merge_rows.rb",
    "lib/streaming_join/join_mapper.rb",
  ]
end
