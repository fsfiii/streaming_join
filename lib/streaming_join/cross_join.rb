require 'streaming_join/join'

class CrossJoin < Join
  def output
    left,right = @join

    left.each do |lk,lv|
      right.each do |rk,rv|
        o = "#{lk}#{@sep_out}#{lv}#{@sep_out}#{rk}#{@sep_out}#{rv}"
        if block_given?
          yield o
        else
          puts o
        end
      end
    end
  end

  def process_stream(input = STDIN, &blk)
    @join = [] # big memory, big prizes

    input.each do |line|
      key, side, value = line.chomp.split(@sep_in, 3)

      (@join[side.to_i] ||= []) << [key, value]
    end

    output(&blk) if not @join.empty?
  end
end
