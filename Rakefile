require 'fileutils'

MRUBY_VERSION="1.2.0"

file :mruby do
    #sh "git clone --depth=1 https://github.com/mruby/mruby"
  sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz -s -o - | tar zxf -"
  FileUtils.mv("mruby-#{MRUBY_VERSION}", "mruby")
end

APP_ROOT=ENV["APP_ROOT"] || Dir.pwd
# avoid redefining constants in mruby Rakefile
mruby_root=File.expand_path(ENV["MRUBY_ROOT"] || "#{APP_ROOT}/mruby")
mruby_config=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
ENV['MRUBY_ROOT'] = mruby_root
ENV['MRUBY_CONFIG'] = mruby_config
Rake::Task[:mruby].invoke unless Dir.exist?(mruby_root)
Dir.chdir(mruby_root)
load "#{mruby_root}/Rakefile"

task :mtest => :all do
  # in order to get mruby/test/t/synatx.rb __FILE__ to pass,
  # we need to make sure the tests are built relative from mruby_root
  MRuby.each_target do |target|
    run_test if target.test_enabled?
  end
end
