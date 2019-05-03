require 'fileutils'
require './sources/Errors.rb'
require './sources/StringExtension.rb'

class TestFileHandler
  def initialize
    @skip_reg = set_up_skip_delete_reg
  end

  def make_test_dir(dir_size,base_dir_name)
    dir_size.times do |i|
      path = "#{base_dir_name}/inner_test/inner_dir#{i}"
      dir_size.times do |n|
        path += "/test_dir_name#{n}"
        make_dir(path)
        make_text(path + "/test.txt")
      end
    end
  end

  def force_rm_rf(path,is_serious=false)
    return unless File.exist?(path) 
    if skip_delete_path?(path)
      raise Errors::DangerousPathError.new(path)
    end
    FileUtils.rm_rf(path) if is_serious
  end


  def set_up_skip_delete_dirs
    <<-EOS
    Applications
    etc
    Library
    home
    Network
    System
    net
    Users
    private
    Volumes
    sbin
    bin
    tmp
    usr
    EOS
  end

  def set_up_skip_delete_list
    set_up_skip_delete_dirs
      .split_and_strip
      .map {|s| "/" << s}
      .concat([".","/","./","../"])
  end

  def set_up_skip_delete_reg
      str = '^(\\/+('
      str << set_up_skip_delete_dirs
        .split_and_strip
        .join('|')
      str << ')?\\/?'
      str << '|\\.+\\/?'
      str << ')$'
  end


  def skip_delete_path?(path)
    if path.match(@skip_reg)
      return true
    end
    return false
  end

  def make_dir(path)
    return if File.exist?(path)
    FileUtils.mkdir_p(path)
  end

  def make_text(path)
    return if File.exist?(path)
    FileUtils.touch(path)
  end
end


if $0 == __FILE__
  test_file_handler = TestFileHandler.new
  test_file_handler.make_test_dir(10,"test_dir")

end

