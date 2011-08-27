require 'streaming_join/join'

class LeftOuterJoin < Join
  def null_right key, left
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
end
