require File.dirname(__FILE__) + '/time_logger'

class Object
  def _benchmarker_inspect
    m = inspect.match /\A#<\w+:(0x[0-9a-f]+)>/
    if m
      c_addr = m[1]
      self.class.to_s << ' ' << c_addr
    else
      self.class.to_s << ' ' << self.inspect
    end
  end
end

class Benchmark
  @@benchmarks = {}

  def self.instance(key)
    @@benchmarks[key] ||= new
  end

  def initialize
    @time_logger = TimeLogger.new
  end

  def for_method(klass, method)
    method = method.to_s

    klass.class_variable_set(:@@_time_logger, @time_logger)
    method_with_benchmark = %Q{
      def #{method + '_with_benchmark'}(*args, &blk)
        e = @@_time_logger.start_event(_benchmarker_inspect << ".#{method}(" << args.map{|x| x.inspect}.join(', ') << ')')

        r = #{method + '_without_benchmark'}(*args, &blk)

        @@_time_logger.stop_event(e)
        r
      end
    }
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
    puts "timestamp duration trace"
    @time_logger.to_s
  end
end

