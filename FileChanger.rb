require 'fileutils'
require './sources/FileRetriever.rb'
require './sources/StringExtension.rb'

class FileChanger
  ChangePathInfo = Struct.new(:before,:after)
  def initialize(skip_file_names=[])
    default_skip_regs = ["^.git$","vendor"]
    default_skip_regs.concat(skip_file_names)
    @file_retriever = FileRetriever.new(default_skip_regs)
    @snake_case_reg = Regexp.new(/_+./)
  end
  
  def retrieve_snake_dirs(base_path,after_type)
    dirs = []
    path_change_callback = after_type == :to_camel ? snake_to_camel : snake_to_pascal

    cb = lambda do |ftype,fn,abs_path| 
      case ftype
      when :directory
        changed_path = set_up_changed_dir(abs_path,path_change_callback)
        unless abs_path == changed_path
          path_info = ChangePathInfo.new(abs_path,changed_path)
          dirs << path_info
        end
      end
    end

    @file_retriever.retrieve(base_path,cb) 
    return dirs
  end

  def change_dirs_name(dirs)
    dirs.sort {|a,b|
      a.before.length <=> b.before.length
    }.reverse.each do |path_info|
      FileUtils.mv(path_info.before,path_info.after)
    end
  end
  
    private
    def snake_to_camel
      lambda { |str|
        str.gsub(@snake_case_reg) do |word|  
          word.upcase.sub(/_+/,'')
        end
      }
    end
    
    def snake_to_pascal
      lambda { |str|
        return str unless str.match(/_/)
        str.split(/_/).map{|s| s.capitalize }.join("")
      }
    end

    def split_target(path)
      splited_path = path.split('/')
      target = splited_path.pop
      return splited_path,target
    end

    def set_up_changed_dir(path,cb)
      path_data = split_target(path)
      changed_path = cb.call(path_data.pop)
      [path_data,changed_path].join('/')
    end

    def camel_to_pascal(str)
       reg = /(?:(?:^[a-z]|[A-Z])(?:[a-z0-9]+))/
       matches = str.scan(reg)
       changed_str = matches.map{|s|s.capitalize}.join("")
       changed_str.length == str.length ? changed_str : nil
    end
end

if $0 == __FILE__

  #describe the directory name you want to skip here.
  skip_dir_names = <<-EOS
  Carthage
  Pods
  spec
  node_modules
  EOS

  #:to_camel or :to_pascal
  change_type  = :to_pascal
  file_changer = FileChanger.new(skip_dir_names.split_and_strip)

  #specify retrieve target directory. (relative or absolute path)
  retrieve_target_path = ""
  #retrieved directories data
  to_be_changed_dirs_data = file_changer.retrieve_snake_dirs(retrieve_target_path,change_type)
  
    #change directoy name
    if to_be_changed_dirs_data.empty?
      p :snake_not_found
    else
      file_changer.change_dirs_name(to_be_changed_dirs_data)
    end
end


