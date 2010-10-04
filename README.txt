Simple benchmark tool.

Usage:

  require File.dirname(__FILE__) + '/benchmark'

  class A 
    def sum(n)
      sum = 0
      1.upto(n) do |i|
        sum += sql(n)
        sleep(0.005)
        sum += sql(n-i)
      end
    end
    def sql(n)
      sleep(0.02)
      Kernel.rand(n)
    end 
  end

  b = Benchmark.instance(:general)
  b.for(A)
  b.for(Integer, :upto)

  a = A.new
  a.sum(5)
  a.sum(3)

  puts b.to_s

See example.rb for example output.

