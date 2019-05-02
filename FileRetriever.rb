require 'fileutils'
require './TestFileMaker.rb'

class FileRetriever
  def initialize(skip_file_regs=[])
    default_skip_regs = ["^\\.+$","\\.DS_Store$","^.git$"]
    skip_file_name_regs = skip_file_regs.concat(default_skip_regs)
    @skip_file_names_reg = reg_convert_from_strs(skip_file_name_regs)
    @snake_case_reg = Regexp.new(/(^|_)(.)/)
  end

  def retrieve_snake_dirs(base_path)
    dirs = []
    cb = lambda{|ftype,fn,abs_path| 
      if ftype == :directory
        changed = snake_to_camel_only_last(abs_path)
        unless abs_path == changed
          dirs << [abs_path,changed]
        end
      end
    }

    retrieve(base_path,cb) 
    return dirs
  end

  def change_snake_dirs_to_camel(dirs)
    dirs.sort{|a,b| a[0].length <=> b[0].length}.reverse.each do |a|
      FileUtils.mv(a[0],a[1])
    end
  end

private
  def retrieve(base_path,callback=nil)
    files = dir_entries(base_path)
    files.each do |file_name|
      next if skip_file?(file_name)

      abs_path = File.expand_path(file_name,base_path)
      ftype = check_ftype(abs_path)
      next unless file_exist?(abs_path)

      callback.call(ftype,file_name,abs_path) unless callback == nil

      case ftype
      when :directory
        retrieve(abs_path,callback)
      end
    end
  end

  def check_ftype(path)
    begin
     File.ftype(path).to_sym
    rescue => e
     return :unknown 
    ensure
    end
  end

  def dir_entries(path)
    Dir.entries(path)
  end

  def skip_file?(relative_path)
    return true if @skip_file_names_reg.match(relative_path)
    return false
  end

  def reg_convert_from_strs(strs)
    %r(#{strs.join("|")})
  end

  def file_exist?(path)
     File.exist?(path)
  end

  def read(path)
     File.read(path)
  end

  def split_target(path)
    splited_path = path.split("/")
    target = splited_path.pop
    return splited_path,target
  end

  def snake_to_camel_only_last(path) 
    path_data = split_target(path)
    changed_path = snake_to_camel(path_data.pop)
    [path_data,changed_path].join("/")
  end

  def snake_to_camel(str)
    str.gsub(@snake_case_reg) do |word|  
      if word.match(/^_/)
        word.upcase.sub("_","")
      else
        word
      end
    end
  end

end


if __FILE__ == $0
  dir_maker = TestFileMaker.new
  make_dir_base_name = "test_dir"
  dir_maker.make_test_dir(make_dir_base_name)

  skip_dir_names = <<-EOS
  not_change
  Carthage
  Pods
  EOS

  skip_dir_lists = skip_dir_names.split("\n").map{|str|str.strip}

  file_retriever = FileRetriever.new(skip_dir_lists)
  p str = File.absolute_path(".")
   found_dirs = file_retriever.retrieve_snake_dirs(str)
  file_retriever.change_snake_dirs_to_camel(found_dirs)
   found_dirs = file_retriever.retrieve_snake_dirs(str)
  p found_dirs.empty?
end



