require File.dirname(__FILE__) + '/time_logger'

class Object
  private
  alias _base_to_s to_s

  def _benchmark_inspect
    self.class.send(:alias_method, :_this_to_s, :to_s)
    self.class.send(:alias_method, :to_s, :_base_to_s)
    m = inspect.match /\A#<\w+:(0x[0-9a-f]+)>\Z/
    self.class.send(:alias_method, :to_s, :_this_to_s)

    if m
      c_addr = m[1]
      r = self.class.to_s << ' ' << c_addr
    else
      r = self.class.to_s << ' ' << self.inspect
    end

    
    r
  end
end

class Benchmark
  @@benchmarks = {}

  def self.instance(key)
    @@benchmarks[key] ||= new
  end

  def initialize
    @time_logger = TimeLogger.new
    @benchmarked = {}
  end

  def for(klass, method = nil)
    if method
      for_method(klass, method) 
    else
      klass.instance_methods(false).each{|m| self.for_method(klass,m) }
    end
  end

  def to_s
    "timestamp duration trace\n" << @time_logger.to_s
  end

  protected

  def for_method(klass, method)
    method = method.to_s

    if (@benchmarked[klass] && @benchmarked[klass][method])
      return
    end

    klass.class_variable_set(:@@_time_logger, @time_logger)
    method_with_benchmark = %Q{
      def #{method + '_with_benchmark'}(*args, &blk)
        e = @@_time_logger.start_event(_benchmark_inspect << ".#{method}(" << args.map{|x| x.inspect}.join(', ') << ')')

        r = #{method + '_without_benchmark'}(*args, &blk)

        @@_time_logger.stop_event(e)
        r
      end
    }

    klass.class_eval method_with_benchmark
    klass.send(:alias_method, method + '_without_benchmark', method)
    klass.send(:alias_method, method, method + '_with_benchmark')

    (@benchmarked[klass] ||= {})[method] = true
  end  
end

