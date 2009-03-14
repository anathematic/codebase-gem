Gem::Specification.new do |s|
  s.name = 'codebase'
  s.version = "3.0.0"
  s.platform = Gem::Platform::RUBY
  s.summary = "The codebase gem to make using codebase easier (duh?)"
  
  s.add_dependency('colored', '>= 1.1')
  
  s.files = Dir.glob("{bin,lib}/**/*")
  s.require_path = 'lib'
  s.has_rdoc = false

  s.bindir = "bin"
  s.executables << "codebase"
  s.executables << "cb"

  s.author = "Adam Cooke"
  s.email = "adam@atechmedia.com"
  s.homepage = "http://www.atechmedia.com"
end