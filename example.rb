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
Benchmark.instance(:general).for(Integer, :upto)

a = A.new
a.sum(5)
a.sum(3)

puts b.to_s

# timestamp duration trace
# 0.000 229 A 0x922c230.sum(5)
# 0.000 229   Fixnum 1.upto(5)
# 0.000 020     A 0x922c230.sql(5)
# 0.026 020     A 0x922c230.sql(4)
# 0.046 020     A 0x922c230.sql(5)
# 0.071 020     A 0x922c230.sql(3)
# 0.092 020     A 0x922c230.sql(5)
# 0.118 020     A 0x922c230.sql(2)
# 0.138 020     A 0x922c230.sql(5)
# 0.164 020     A 0x922c230.sql(1)
# 0.184 020     A 0x922c230.sql(5)
# 0.209 020     A 0x922c230.sql(0)
# 0.230 137 A 0x922c230.sum(3)
# 0.230 137   Fixnum 1.upto(3)
# 0.230 020     A 0x922c230.sql(3)
# 0.255 020     A 0x922c230.sql(2)
# 0.275 020     A 0x922c230.sql(3)
# 0.301 020     A 0x922c230.sql(1)
# 0.321 020     A 0x922c230.sql(3)
# 0.347 020     A 0x922c230.sql(0)

