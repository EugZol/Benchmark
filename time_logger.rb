require 'date'

class TimeLogger
  def initialize
    @events = []
  end

  def start_event(label = '<undefined>')
    now = Time.now
    @start = now if @events.empty?
    @events.push([label, now]).length - 1
  end

  def stop_event(event_id)
    raise "Event #{event_id} wasn't started" unless @events[event_id]
    @events[event_id].push(Time.now) # [label, timestamp_beginning, timestamp_end]
  end

  def to_s
    r = ""
    for i in (0..@events.length-1)
      duration = ((@events[i][2]-@events[i][1]) * 1000 ).to_i
      timestamp = @events[i][1] - @start
      r << "#{"%.3f" % timestamp} #{"%03i" % duration} #{@events[i][0]}\n"
    end
    r
  end
end

