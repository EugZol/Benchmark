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
end

b = Benchmark.instance(:general)
b.for(A)
Benchmark.instance(:general).for(Integer, :upto)

a = A.new
a.sum(5)
a.sum(3)

# Time Duration Method
# 0.000 001 A.new
# 0.001 007 A 0x100477420.sum(5)
# 0.002 006   Fixnum 1.upto(5)
# 0.003 001     A 0x100477420.sql(5)
# 0.005 002     A 0x100477420.sql(4) # 5-1
# 0.006 001     A 0x100477420.sql(5)
# 0.007 001     A 0x100477420.sql(3) # 5-2
# 0.008 001     A 0x100477420.sql(5)
# 0.009 001     A 0x100477420.sql(2) # 5-3
# 0.010 001     A 0x100477420.sql(5)
# 0.011 001     A 0x100477420.sql(1) # 5-4
# 0.012 001     A 0x100477420.sql(5)
# 0.013 001     A 0x100477420.sql(0) # 5-5
# 0.014 004 A 0x100477420 sum(3)
# 0.015 003   Fixnum 1.upto(3)
# 0.016 001     A 0x100477420.sql(3)
# 0.017 001     A 0x100477420.sql(2) # 3-1
# 0.018 001     A 0x100477420.sql(3)
# 0.019 001     A 0x100477420.sql(1) # 3-2
# 0.020 001     A 0x100477420.sql(3)
# 0.021 001     A 0x100477420.sql(0) # 3-3
