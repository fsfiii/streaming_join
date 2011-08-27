require 'streaming_join/join'

class FullOuterJoin < Join
  def null_right key, left
    report 'null right'
    o = "#{key}#{@sep_out}"

    left.each do |l|
      if @cols_r > 0
        o << "#{l}#{@sep_out}#{Array.new(@cols_r).join(@sep_out)}"
      else
        o = "#{key}#{@sep_out}#{l}"
      end
    end

    block_given? ? (yield o) : (puts o)
  end

  def null_left key, right
    report 'null left'
    o = "#{key}#{@sep_out}"

    if @cols_l > 0
      o << "#{Array.new(@cols_l).join(@sep_out)}#{@sep_out}#{right}"
    else
      o = "#{key}#{@sep_out}#{right}"
    end

    block_given? ? (yield o) : (puts o)
  end
end
