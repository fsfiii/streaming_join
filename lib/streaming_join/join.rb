# base Join class (inner join)
class Join
  def initialize opts = {}
    @sep_in  = ENV['stream_map_output_field_separator'] || "\t"
    @sep_out = ENV['streaming_join_output_separator'] || "\t"
    @sep_out = $1.hex.chr if @sep_out =~ /\A(?:\\u?)?(\d+)\Z/
    @report  = opts.fetch :report, true
    @cols_l  = ENV['streaming_join_cols_left'].to_i
    @cols_r  = ENV['streaming_join_cols_right'].to_i
  end

  def report detail
    return if not @report
    STDERR.puts "reporter:counter:join,#{detail},1"
  end

  def output key, left, right
    left.each do |l|
      o = "#{key}#{@sep_out}#{l}#{@sep_out}#{right}"
      if block_given?
        yield o
      else
        puts o
      end
    end
  end

  def null_left key, right
  end

  def null_right key, left
  end

  def process_stream(input = STDIN, &blk)
    last_key = key = nil
    last_side = nil
    left = []

    input.each do |line|
      key, side, value = line.chomp.split(@sep_in, 3)

      report 'keys' if last_key != key

      side = side.to_i
      if side == 0
        #puts "LEFT: #{line}"
        #puts "last_key: #{last_key}"
        # if we are on the left side and just processed the left side
        # of another key, we didn't get any right side records
        if last_key != key and last_side == 0
          report 'null right' if last_key != key
          null_right last_key, left
        end

        if last_key != key
          left = []
        end
        left << value
      else
        # if we're in a new key and the first record is a right side
        # record, that means we never processed a left side
        if not last_key or last_key != key or left.empty?
          report 'null left' if last_key != key
          null_left key, value
        else
          report 'left and right' if last_key != key
          output key, left, value
        end
      end

      last_side = side
      last_key = key
    end

    # if the last processed record is on the left, there is
    # not going to be a right side
    if last_side == 0
      report 'null right'
      null_right(key, left)
    end
  end
end
