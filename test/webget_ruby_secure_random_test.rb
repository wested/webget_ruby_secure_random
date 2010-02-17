require 'test/unit'
require 'webget_ruby_secure_random'

class Testing < Test::Unit::TestCase

 def test_random_bytes
  n=16
  20.times{
   x=SecureRandom.random_bytes(16)
   assert_equal(x.length,n)
  }
 end

 def test_hex
  n=16
  20.times{
   x=SecureRandom.hex(n)
   assert_equal(x.length,2*n)
  }
 end

 def test_base64
  n=16
  20.times{
   x=SecureRandom.base64(n)
   assert(x.length>=n,"x length #{x.length} >= n #{n}")
   assert(x.length<2*n,"x length #{x.length} < 2n #{2*n}")
  }
 end

 def test_random_number_integer
  n=16
  20.times{
   x=SecureRandom.random_number(n)
   assert(0<=x,"0<=x")
   assert(x<n,"x<n")
  }
 end

 def test_random_number_float
  20.times{
   x=SecureRandom.random_number
   assert(0<=x,"0<=x")
   assert(x<1,"x<1")
  }
 end

end
