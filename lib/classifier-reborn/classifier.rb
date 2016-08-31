
module ClassifierReborn
  class Classifier

    def bind_hash(h, obj)
      h[obj.last] ||= 0
      h[obj.last] += 1
      h
    end

    def assert_instance(instance) # FIXME
      classify = self.class.instance_method(:classify)
      classify(instance.first).to_s == instance.last.to_s.upcase
    end

    def reduce_freq(list)
      list.reduce(Hash.new) {|h, obj| bind_hash(h, obj) }
    end

    def validate(testing_data)
      @classes_frequency = reduce_freq(testing_data)
      hits = testing_data.select{|t| assert_instance(t) }
      @failures = reduce_freq(testing_data - hits)
      @hits = reduce_freq(hits)

      print_stats
    end

    def print_stats
      matrix_confusion
      # puts "Precision: #{precision}"
      # puts "Recall: #{precision}"
      # puts "F-Measure: #{precision}"
    end

    def matrix_confusion
      keys = @classes_frequency.keys

      puts "Result"
      puts " #{keys.join(' ')}"
      keys.each do |k|
        string = "#{k}"
        keys.each do |kin|
          string << " #{( k == kin ? @hits[k] : @failures[k])}"
        end
        puts string
      end
    end

  end
end
