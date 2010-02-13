Gem::Specification.new do |s|

  s.name              = "webget_ruby_secure_random"
  s.summary           = "WebGet Ruby Gem: secure random number method for Ruby 1.8.6"
  s.version           = "1.2.0"
  s.author            = "WebGet"
  s.email             = "webget@webget.com"
  s.homepage          = "http://webget.com/"
  s.signing_key       = '/home/webget/keys/certs/webget.com.rsa.private.key.and.certificate.pem'
  s.cert_chain        = ['/home/webget/keys/certs/webget.pem']

  s.platform          = Gem::Platform::RUBY
  s.require_path      = 'lib'
  s.has_rdoc          = true
  s.files             = ['lib/webget_ruby_secure_random.rb']
  s.test_files        = ['test/unit/webget_ruby_secure_random_test.rb']

end
