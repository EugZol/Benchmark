require File.dirname(__FILE__) + "/../time_logger"

describe TimeLogger do

  before do
    @now = Time.new
    @in_1_ms = @now + 1.0/1000
    @in_2_ms = @now + 2.0/1000
    @in_3_ms = @now + 3.0/1000
    @time_logger = TimeLogger.new
  end

  describe 'basic features' do

    it "returns integer id of event in response to start_event" do
      @time_logger.start_event.should be_a_kind_of(Integer)
    end

    it "accepts integer id of event for stop_event" do
      e = @time_logger.start_event
      lambda{@time_logger.stop_event(e)}.should_not raise_error
    end

    it "raises an error when one is trying to stop event that wasn't started" do
      e = @time_logger.start_event
      lambda{@time_logger.stop_event(e+1)}.should raise_error
    end

    it "asks for current time twice for single event" do
      Time.should_receive(:now).and_return(@now)
      Time.should_receive(:now).and_return(@in_1_ms)

      i = @time_logger.start_event
      @time_logger.stop_event(i)
    end
  end

  describe 'to_s output' do
    it "shows nice string for single event with default label" do
      Time.should_receive(:now).and_return(@now)
      Time.should_receive(:now).and_return(@in_1_ms)

      t = @time_logger
      e = t.start_event
      t.stop_event(e)
      t.to_s.should == "0.000 001 <undefined>\n"
    end

    it "shows nice string for single event with custom label" do
      Time.should_receive(:now).and_return(@now)
      Time.should_receive(:now).and_return(@in_1_ms)

      t = @time_logger
      e = t.start_event('my_label')
      t.stop_event(e)
      t.to_s.should == "0.000 001 my_label\n"      
    end

    it "shows nice string for two events with custom labels" do
      Time.should_receive(:now).and_return(@now)
      Time.should_receive(:now).and_return(@in_1_ms)
      Time.should_receive(:now).and_return(@in_2_ms)
      Time.should_receive(:now).and_return(@in_3_ms)

      t = @time_logger
      e1 = t.start_event('first')
      t.stop_event(e1)
      e2 = t.start_event('second')
      t.stop_event(e2)

      t.to_s.should == "0.000 001 first\n0.002 001 second\n"
    end

    it "pads events if they are nested" do
      Time.should_receive(:now).and_return(@now)
      Time.should_receive(:now).and_return(@in_1_ms)
      Time.should_receive(:now).and_return(@in_2_ms)
      Time.should_receive(:now).and_return(@in_3_ms)

      t = @time_logger
      e1 = t.start_event('first')
      e2 = t.start_event('second')
      t.stop_event(e2)
      t.stop_event(e1)

      t.to_s.should == "0.000 003 first\n  0.001 001 second\n"
    end
  end

end

