

class TestFileMaker
  private def make_dir(path)
    return if File.exist?(path)
    FileUtils.mkdir_p(path)
  end

  def make_text(path)
    return if File.exist?(path)
    FileUtils.touch(path)
  end

  def make_test_dir(base_dir_name)
    n = 10
    n.times do |i|
      path = "#{base_dir_name}/inner_test/inner_Dir#{i}"

      n.times do |n|
        path += "/test_dir_name#{n}"
        make_dir(path)
        p path
        make_text(path + "/test.txt")
      end

    end
  end
end
