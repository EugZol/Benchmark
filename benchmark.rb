require File.dirname(__FILE__) + '/time_logger'

class Benchmark
  @@Benchmarks = {}

  def self.instance(key)
    @@Benchmarks[key] ||= new
  end

  def initialize
    @time_logger = TimeLogger.new
  end

  def for_method(klass, method)
    method = method.to_s
    klass.class_variable_set(:@@_time_logger, @time_logger)
    method_with_benchmark = %Q{
      def #{method + '_with_benchmark'}(*args, &blk)
        e = @@_time_logger.start_event(inspect << ".#{method}(" << args.map{|x| x.inspect}.join(', ') << ')')

        r = #{method + '_without_benchmark'}(*args, &blk)

        @@_time_logger.stop_event(e)
        r
      end
    }
    #puts "Achtung! Here is method:\n" << method_with_benchmark
    klass.class_eval method_with_benchmark
    klass.send(:alias_method, method + '_without_benchmark', method)
    klass.send(:alias_method, method, method + '_with_benchmark')
  end

  def for(klass, method = nil)
    if method
      for_method(klass, method) 
    else
      klass.instance_methods(false).each{|m| self.for_method(klass,m)}
    end
  end

  def to_s
    @time_logger.to_s
  end
end
