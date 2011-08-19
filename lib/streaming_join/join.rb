# base Join class (inner join)
class Join
  def initialize
    @sep_in  = ENV['stream_map_output_field_separator'] || "\t"
    @sep_out = ENV['streaming_join_output_separator'] || "\t"
    @sep_out = $1.hex.chr if @sep_out =~ /\A(?:\\u?)?(\d+)\Z/
  end

  def report detail
    STDERR.puts "reporter:counter:join,#{detail},1"
  end

  def output key
    report 'keys'

    left,right = @join
    if not left
      report 'null left'
      return
    elsif not right
      report 'null right'
      return
    end

    left.each do |l|
      report 'left and right'
      right.each do |r|
        o = "#{key}#{@sep_out}#{l}#{@sep_out}#{r}"
        if block_given?
          yield o
        else
          puts o
        end
      end
    end
  end

  def process_stream(input = STDIN, &blk)
    last_key = key = nil
    @join = []

    input.each do |line|
      key, side, value = line.chomp.split(@sep_in, 3)

      if last_key and last_key != key
        output(last_key, &blk)
        @join = []
      end

      (@join[side.to_i] ||= []) << value
      last_key = key
    end

    output(last_key, &blk) if key
  end
end
