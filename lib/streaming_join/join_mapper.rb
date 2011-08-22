class JoinMapper
  def initialize
    # use our own input field separator variable since the stock
    # stream variable can't handle control characters
    @sep_in  = ENV['streaming_join_input_field_separator'] || "\t"
    @sep_in  = $1.hex.chr if @sep_in =~ /\A(?:\\u?)?(\d+)\Z/
    @sep_out = ENV['stream_map_output_field_separator'] || "\t"
    @sep_out = $1.hex.chr if @sep_in =~ /\A(?:\\u?)?(\d+)\Z/

    @join = []
  end

  def report detail
    STDERR.puts "reporter:counter:join,#{detail},1"
  end

  def add_side(file_re, *columns, &filter)
    h = {
      file_re: file_re,
      columns: columns,
      filter:  filter,
      sep:     @sep_in,
      side:    @join.size
    }
    @join << h
    h
  end

  def add_opts(file_re, opts)
    @join.each do |j|
      next if j[:file_re] != file_re
      j.merge! opts
    end
  end

  def join_side
    input_file = ENV['map_input_file']
    @join.each do |j|
      return j if input_file =~ j[:file_re]
    end
    raise "how do I handle input file '#{input_file}'?"
  end

  def process_stream(input = STDIN)
    last_key = key = nil

    j = join_side
    cols   = j[:columns]
    filter = j[:filter]
    side   = j[:side]
    sep    = j[:sep]

    input.each do |line|
      fields = line.chomp.split(sep, -1)

      c = []
      cols.each_with_index do |col,i|
        value = fields[col]
        break if i == 0 and value.nil? # can't have nil key
        c << value
      end
      next if c.empty?

      next if filter and not filter.call(c)

      o = "#{c[0]}#{@sep_out}#{side}#{@sep_out}"
      o << c[1...c.length].join(@sep_out)
      puts o
    end
  end
end
