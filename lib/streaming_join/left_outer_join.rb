require 'streaming_join/join'

class LeftOuterJoin < Join
  def output key
    report 'keys'

    left,right = @join
    if not left
      report 'null left'
      return
    else
      report 'left keys'
    end

    # the number of columns on the right can be passed in as an env variable
    # so that the full record with empty "" values can be displayed even if
    # there is no match
    cols_r = ENV['streaming_join_cols_right'].to_i

    left.each do |l|
      if right
        report 'left and right'
        right.each do |r|
          o = "#{key}#{@sep_out}#{l}#{@sep_out}#{r}"
          block_given? ? (yield o) : (puts o)
        end
      elsif cols_r > 0
        report 'null right'
        o = "#{key}#{@sep_out}"
        o << "#{l}#{@sep_out}#{Array.new(cols_r).join(@sep_out)}"
        block_given? ? (yield o) : (puts o)
      else
        report 'null right'
        o = "#{key}#{@sep_out}#{l}"
        block_given? ? (yield o) : (puts o)
      end
    end
  end
end
