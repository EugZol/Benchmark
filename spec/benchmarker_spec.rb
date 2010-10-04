require File.dirname(__FILE__) + "/../benchmarker"

describe Benchmarker

  describe 'instance' do
    before do
      class TestBenchmarker < Benchmarker
      end
    end

    it "returns new instance of benchmarker if no instance with such key exists" do
      TestBenchmarker.instance(:key).class.should == TestBenchmarker
    end

    it "returns existing instance of benchmarker if it exists with such key" do
      b = TestBenchmarker.instance(:key)
      TestBenchmarker.instance(:key).object_id.should == b.object_id
    end

    after do
      Object.send(:remove_const, :TestBenchmarker)
    end
  end

  describe 'for' do
    before do
      @benchmarker = Benchmarker.new
    end

    
  end

end
