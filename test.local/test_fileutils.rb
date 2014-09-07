# This is taken from rake repo.

require './helper'
require '../mrblib/shellwords'
require '../mrblib/main'

class FakeStdout
  def initialize
    @log = []
  end

  attr_accessor :log

  def puts msg
    @log << msg
  end
end

FileUtilsSimple::Delegator.stdout = FakeStdout.new

class TestFileUtilsSimple < $testunit_class

  def setup
    teardown
    Dir.mkdir $tmpdir
    Dir.chdir $tmpdir
  end

  def teardown
    Dir.chdir __dir__
    `rm -rf #{$tmpdir}`
  end

  def test_methods_list
    m = [
         :pwd,
         :cd,
         :touch,
         :install,
        ]
    assert_equal m.sort, FileUtilsSimple.singleton_methods.sort
    assert_equal m.sort, FileUtilsSimple::DryRun.singleton_methods.sort
  end

  def test_pwd
    assert_equal __dir__, File.dirname(FileUtilsSimple::DryRun.pwd)
    assert_equal "pwd ", FileUtilsSimple::Delegator.stdout.log.pop

    assert_equal __dir__, File.dirname(FileUtilsSimple.pwd)
    assert_equal nil, FileUtilsSimple::Delegator.stdout.log.pop

    assert_equal __dir__, File.dirname(FileUtilsSimple.pwd(verbose: true))
    assert_equal "pwd ", FileUtilsSimple::Delegator.stdout.log.pop
  end

  def test_pwd_invalid_params
    assert_raises ArgumentError do
      FileUtilsSimple.pwd 1
    end
  end

  def test_cd
    FileUtilsSimple.cd '/' do
      assert_equal '/', Dir.pwd
    end
    assert_equal __dir__, File.dirname(Dir.pwd)
  end

  def test_touch
    FileUtilsSimple.touch "1.txt", "2.txt", verbose: true, noop: true
    assert_equal "touch 1.txt, 2.txt", FileUtilsSimple::Delegator.stdout.log.pop
    assert_equal false, File.exist?("1.txt")
    assert_equal false, File.exist?("2.txt")

    FileUtilsSimple.touch "1.txt", "2.txt"
    assert_equal true, File.exist?("1.txt")
    assert_equal true, File.exist?("2.txt")
  end

  def test_install
    FileUtilsSimple.touch "1.txt"
    FileUtilsSimple.install "1.txt", "1/2/3/"
    assert_equal true, File.exist?("1/2/3/1.txt")
#    system "ls -la 1/2/3"

    FileUtilsSimple.install "1.txt", "1/2/1.txt", 644
    assert_equal true, File.exist?("1/2/1.txt")

    FileUtilsSimple.install "1.txt", "2.txt", 644
    assert_equal true, File.exist?("2.txt")
#    system "ls -la"
  end

end

MTest::Unit.new.run if mruby?
