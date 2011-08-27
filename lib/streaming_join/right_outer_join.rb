require 'streaming_join/join'

class RightOuterJoin < Join
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
