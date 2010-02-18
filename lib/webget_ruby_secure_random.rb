=begin rdoc

= WebGet Ruby Gem: secure random number generator interface for Ruby 1.86 backported from 1.8.7

Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
Copyright:: Copyright the original author; I merely made it into a gem.
License:: CreativeCommons License, Non-commercial Share Alike
License:: LGPL, GNU Lesser General Public License

This gem is intended for use with Ruby 1.8.6 only.

This gem is a backport of the built-in securerandom method from Ruby 1.8.7.

This library is an interface for secure random number generator which is
suitable for generating session key in HTTP cookies, etc.

It supports following secure random number generators.

  * openssl
  * /dev/urandom

Examples
  SecureRandom.hex(10) => "52750b30ffbc7de3b362"
  SecureRandom.hex(10) => "92b15d6c8dc4beb5f559"
  SecureRandom.hex(11) => "6aca1b5c58e4863e6b81b8"
  SecureRandom.hex(12) => "94b2fff3e7fd9b9c391a2306"
  SecureRandom.hex(13) => "39b290146bea6ce975c37cfc23"

Examples
  SecureRandom.base64(10) => "EcmTPZwWRAozdA=="
  SecureRandom.base64(10) => "9b0nsevdwNuM/w=="
  SecureRandom.base64(10) => "KO1nIU+p9DKxGg=="
  SecureRandom.base64(11) => "l7XEiFja+8EKEtY="
  SecureRandom.base64(12) => "7kJSM/MzBJI+75j8"
  SecureRandom.base64(13) => "vKLJ0tXBHqQOuIcSIg=="

Examples
  SecureRandom.random_bytes(10) => "\016\t{\370g\310pbr\301"
  SecureRandom.random_bytes(10) => "\323U\030TO\234\357\020\a\337"

=end


begin
  require 'openssl'
rescue LoadError
end

module SecureRandom
  # SecureRandom.random_bytes generates a random binary string.
  #
  # The argument n specifies the length of the result string.
  #
  # If n is not specified, 16 is assumed.
  # It may be larger in future.
  #
  # If secure random number generator is not available,
  # NotImplementedError is raised.
  def self.random_bytes(n=nil)
    n ||= 16
    if defined? OpenSSL::Random
      return OpenSSL::Random.random_bytes(n)
    end
    if !defined?(@has_urandom) || @has_urandom
      @has_urandom = false
      flags = File::RDONLY
      flags |= File::NONBLOCK if defined? File::NONBLOCK
      flags |= File::NOCTTY if defined? File::NOCTTY
      flags |= File::NOFOLLOW if defined? File::NOFOLLOW
      begin
        File.open("/dev/urandom", flags) {|f|
          unless f.stat.chardev?
            raise Errno::ENOENT
          end
          @has_urandom = true
          ret = f.readpartial(n)
          if ret.length != n
            raise NotImplementedError, "Unexpected partial read from random device"
          end
          return ret
        }
      rescue Errno::ENOENT
        raise NotImplementedError, "No random device"
      end
    end
    raise NotImplementedError, "No random device"
  end

  # SecureRandom.hex generates a random hex string.
  #
  # The argument n specifies the length of the random length.
  # The length of the result string is twice of n.
  #
  # If n is not specified, 16 is assumed.
  # It may be larger in future.
  #
  # If secure random number generator is not available,
  # NotImplementedError is raised.
  def self.hex(n=nil)
    random_bytes(n).unpack("H*")[0]
  end

  # SecureRandom.base64 generates a random base64 string.
  #
  # The argument n specifies the length of the random length.
  # The length of the result string is about 4/3 of n.
  #
  # If n is not specified, 16 is assumed.
  # It may be larger in future.
  #
  # If secure random number generator is not available,
  # NotImplementedError is raised.
  def self.base64(n=nil)
    [random_bytes(n)].pack("m*").delete("\n")
  end

  # SecureRandom.random_number generates a random number.
  #
  # If an positive integer is given as n,
  # SecureRandom.random_number returns an integer:
  # 0 <= SecureRandom.random_number(n) < n.
  #
  # If 0 is given or an argument is not given,
  # SecureRandom.random_number returns an float:
  # 0.0 <= SecureRandom.random_number() < 1.0.
  def self.random_number(n=0)
    if 0 < n
      hex = n.to_s(16)
      hex = '0' + hex if (hex.length & 1) == 1
      bin = [hex].pack("H*")
      mask = bin[0].ord
      mask |= mask >> 1
      mask |= mask >> 2
      mask |= mask >> 4
      begin
        rnd = SecureRandom.random_bytes(bin.length)
        rnd[0] = (rnd[0].ord & mask).chr
      end until rnd < bin
      rnd.unpack("H*")[0].hex
    else
      # assumption: Float::MANT_DIG <= 64
      i64 = SecureRandom.random_bytes(8).unpack("Q")[0]
      Math.ldexp(i64 >> (64-Float::MANT_DIG), -Float::MANT_DIG)
    end
  end

end

# Added by joelparkerhenderson@gmail.com for backwards compatibility with Ruby 1.8
class Fixnum
 def ord
  return self
 end
end
