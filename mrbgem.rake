MRuby::Gem::Specification.new('mruby-fileutils-simple') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Terence Lee, Alexander Gromnitsky'
  spec.version = '0.0.2'
  spec.summary = 'Like FileUtils but delegates all work to system tools.'
  spec.homepage = 'https://github.com/hone/mruby-fileutils-simple'

  spec.add_dependency 'mruby-dir',         mgem: 'mruby-dir'
  spec.add_dependency 'mruby-onig-regexp', mgem: 'mruby-onig-regexp'
end
