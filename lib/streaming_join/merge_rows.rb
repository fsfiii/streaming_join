require 'streaming_join'

class MergeRows < Join
  def output key
    report 'keys'

    o = "#{key}#{@sep_out}#{@join.join(@sep_out)}"
    block_given? ? (yield o) : (puts o)
  end

  def process_stream(input = STDIN)
    last_key = key = nil
    @join = []

    input.each do |line|
      key, value = line.chomp.split(@sep_in, 2)

      if last_key and last_key != key
        output last_key
        @join = []
      end

      @join << value
      last_key = key
    end

    output last_key if key
  end
end
