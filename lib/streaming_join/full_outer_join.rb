require 'streaming_join/join'

class FullOuterJoin < Join
  def output key
    report 'keys'

    left,right = @join
    if not left
      report 'null left'
    else
      report 'left keys'
    end
    if not right
      report 'null right'
    else
      report 'right keys'
    end

    #p left, right

    # the number of columns on the sides can be passed in as env variables
    # so that the full record with empty "" values can be displayed even if
    # there is no match
    cols_r = ENV['streaming_join_cols_right'].to_i
    cols_l = ENV['streaming_join_cols_left'].to_i

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
    end if left

    right.each do |r|
      next if left
      report 'null left'
      if cols_l > 0
        o = "#{key}#{@sep_out}"
        o << "#{Array.new(cols_l).join(@sep_out)}#{@sep_out}#{r}"
      else
        o = "#{key}#{@sep_out}#{r}"
      end

      block_given? ? (yield o) : (puts o)
    end if right
  end
end
