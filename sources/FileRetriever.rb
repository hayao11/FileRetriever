
class FileRetriever
  FileInfo = Struct.new(:fle_type,:file_name,:abs_path)

  def initialize(skip_file_regs=[])
    default_skip_regs = ["^\\.+$","\\.DS_Store$"]
    skip_file_regs.concat(default_skip_regs)
    @skip_file_names_reg = reg_convert_from_strs(skip_file_regs)
  end

  def retrieve(base_path,callback)
    files = dir_entries(base_path)
    files.each do |file_name|
      next if skip_file?(file_name)

      abs_path = File.expand_path(file_name,base_path)
      file_type = ftype?(abs_path)
      next unless file_exist?(abs_path)

      callback.call(file_type,file_name,abs_path)

        case file_type
        when :directory
          retrieve(abs_path,callback)
        end
    end
  end

  def retrieved(base_path,result_files=[])
    files = dir_entries(base_path)
    files.each do |file_name|
      next if skip_file?(file_name)

      abs_path = File.expand_path(file_name,base_path)
      file_type = ftype?(abs_path)
      next unless file_exist?(abs_path)

        result_files << FileInfo.new(file_type,file_name,abs_path)

          case file_type
          when :directory
            retrieved(abs_path,result_files)
          end
    end
    result_files
  end

  private
    def ftype?(path)
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
end#class


if $0 == __FILE__

  skip_dir_names = ["vendor",".git"]
  file_retriever = FileRetriever.new(skip_dir_names)

  callback = lambda {|file_type,file_name,abs_path| 
    p file_type,file_name,abs_path
  }

  file_retriever.retrieve(".",callback)
  p file_retriever.retrieved(".")
end



