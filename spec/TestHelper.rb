require './sources/StringExtension.rb'

class TestHelper
    class << self
      def pascal_case?(str)
        return false if str == nil

        pascal_reg = /(?:(?:[A-Z])(?:[a-z0-9]+))+/
        if res = str.match(pascal_reg)
          return true if res.to_s.length == str.length
        end

        return false
      end

      def set_up_skip_retrieve_dirs 
        #describe the directory name you want to skip here.
        skip_dir_names = <<-EOS
        node_modules
        spec
        Carthage
        Pods
        EOS
        skip_dir_list = skip_dir_names.split_and_strip
      end

      def snake_strs
        snake_strs = <<-EOS
        test_test
        Abc_Def_Ghi
        abc_def_ghi_jkl_mn
        A__B__C
        a_b_c
        EOS
      end
  end
end
