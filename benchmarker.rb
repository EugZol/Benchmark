class Benchmarker
  @@benchmarkers = {}

  def self.instance(key)
   @@benchmarkers[key] ||= new
  end
end

