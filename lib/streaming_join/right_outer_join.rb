require 'streaming_join/join'

class RightOuterJoin < Join
  def output key
    report 'keys'

    left,right = @join
    if not right
      report 'null right'
      return
    else
      report 'right keys'
    end

    # the number of columns on the left can be passed in as an env variable
    # so that the full record with empty "" values can be displayed even if
    # there is no match
    cols_l = ENV['streaming_join_cols_left'].to_i

    right.each do |r|
      if left
        report 'left and right'
        left.each do |l|
          o = "#{key}#{@sep_out}#{l}#{@sep_out}#{r}"
          block_given? ? (yield o) : (puts o)
        end
      elsif cols_l > 0
        report 'null left'
        o = "#{key}#{@sep_out}"
        o << "#{Array.new(cols_l).join(@sep_out)}#{@sep_out}#{r}"
        block_given? ? (yield o) : (puts o)
      else
        report 'null left'
        o = "#{key}#{@sep_out}#{r}"
        block_given? ? (yield o) : (puts o)
      end
    end
  end
end
