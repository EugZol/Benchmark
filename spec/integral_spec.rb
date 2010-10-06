require File.dirname(__FILE__) + "/../benchmark"

describe 'integral test' do
  before do
    class TestBenchmark < Benchmark
    end
  end

  it 'should pass1' do
    @test1 = lambda do
      class A 
        def sum(n)
          sum = 0
          1.upto(n) do |i|
            sum += sql(n)
            sum += sql(n-i)
          end
        end
        def sql(n)
          Kernel.rand(n)
        end
        def my_random_method
         "just an A"
        end
        def another_random_method
          "just an A"
        end
        def to_s
        end
      end

      b = TestBenchmark.instance(:general)
      b.for(A)
      #Benchmark.instance(:general).for(Integer, :upto)

      a = A.new
      a.sum(5)
      #a.sum(3)

      #puts b.to_s
    end.should_not raise_error
  end

  it 'should pass N2' do
    @test2 = Benchmark.instance(:general)
  end

  after do
  end
end
