require File.dirname(__FILE__) + "/../benchmark"

describe Benchmark do
  before do
    @benchmark = Benchmark.new
    class A
      def parent_method
        :parent_method
      end

      def inspect
        '<' << self.class.to_s << '>'
      end
    end

    class B < A
      def test(*args)
        :test
      end
    end

    class C
      def inspect
        "#<C:0x1337>"
      end

      def test(*args)
      end
    end
  end

  after do
    Object.send(:remove_const, :C)
    Object.send(:remove_const, :B)
    Object.send(:remove_const, :A)
  end

  describe 'instance' do
    before do
      class TestBenchmark < Benchmark
      end
    end

    it "returns new instance of Benchmark if no instance with such key exists" do
      TestBenchmark.instance(:key).class.should == TestBenchmark
    end

    it "returns existing instance of Benchmark if it exists with such key" do
      b = TestBenchmark.instance(:key)
      TestBenchmark.instance(:key).object_id.should == b.object_id
    end

    after do
      Object.send(:remove_const, :TestBenchmark)
    end
  end

  describe 'for' do
    it "calls for_method for all instance method of class (no method provided in args)" do
      @benchmark.should_receive(:for_method).with(B, :test)
      @benchmark.for(B)
    end

    it "calls for_method for provided method of class" do
      @benchmark.should_receive(:for_method).with(B, :some_method)
      @benchmark.for(B, :some_method)
    end
  end

  describe 'for_method' do
    it "creates _with_benchmark method chain" do
      B.should_receive(:alias_method).with("test_without_benchmark", "test")
      B.should_receive(:alias_method).with("test", "test_with_benchmark")
      @benchmark.for_method(B, :test)
    end

    it "sets up TimeLogger and redirects call to original method" do
      t = TimeLogger.new
      @benchmark.instance_variable_set(:@time_logger, t)
      t.should_receive(:start_event).with('B <B>.test(1, 2)').and_return 56
      t.should_receive(:stop_event).with(56)
      @benchmark.for_method(B, :test)
      B.new.test(1,2)
    end

    it "sets label to 'ClassName 0xADDR' if inspect of benchmarked object provides non customized ouput" do
      t = TimeLogger.new
      @benchmark.instance_variable_set(:@time_logger, t)
      t.should_receive(:start_event).with('C 0x1337.test(1, 2)')
      t.stub!(:stop_event)
      @benchmark.for_method(C, :test)
      C.new.test(1,2)
    end

    it "forwards result of original method to sender" do
      @benchmark.for_method(B, :test)
      B.new.test(1,2).should == :test
    end
  end
  
  it 'delegates to_s to time_logger' do
    t = TimeLogger.new
    @benchmark.instance_variable_set(:@time_logger, t)
    t.should_receive(:to_s).and_return 'test'
    @benchmark.to_s
  end
end

