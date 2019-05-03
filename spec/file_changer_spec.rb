require './FileChanger.rb'
require './spec/TestFileHandler.rb'
require './spec/TestHelper.rb'


shared_context 'file changer init' do |paths|
 let(:file_changer){ FileChanger.new(paths) }
end

describe 'FileChanger',must:true do
  context 'check reg convert' do
    include_context 'file changer init',[]

    it 'snake case strings change to camel case' do
      TestHelper.snake_strs.split_and_strip.each do |str|
        changed_camel = file_changer.send(:snake_to_camel).call(str)
        match_res = changed_camel.match(/_/)
        expect(match_res).to eq nil
      end
    end

    it 'snake case strings change to pascal case' do
      TestHelper.snake_strs.split_and_strip.each do |str|
        changed_camel = file_changer.send(:snake_to_pascal).call(str)
        if snake_match_res = changed_camel.match(/_/)
          expect(snake_match_res).to eq nil
        end

        changed_pascal = file_changer.send(:snake_to_pascal).call(str)
        if is_pascal = TestHelper.pascal_case?(changed_pascal)
          expect(is_pascal).to eq true
        end
      end
    end#it

  end#context
end#desc



describe 'FileChanger ',must:true do
  include_context 'file changer init',TestHelper.set_up_skip_retrieve_dirs

  it 'create directories and retrive snake case' do 
    test_file_handler = TestFileHandler.new
    change_type = :to_pascal
    make_dir_base_name   = "test_dirs"
    changed_dir_name     = file_changer.send(:snake_to_pascal).call(make_dir_base_name)
    retrieve_target_path = "."

    if File.exist?(make_dir_base_name)
       pending "directory is already exist"
    else
      make_size = 20
      test_file_handler.make_test_dir(make_size,make_dir_base_name)
    end

    #:to_camel or :to_pascal
    target_dirs  = file_changer.retrieve_snake_dirs(retrieve_target_path,change_type)

    if target_dirs.empty?
       return pending "target_dirs is empty"
    else
      p "target-dir-length:#{target_dirs.length}"
    end

    file_changer.change_dirs_name(target_dirs)


    changed_dirs = file_changer.retrieve_snake_dirs(retrieve_target_path,change_type)
    p "result-target-dir-length:#{changed_dirs.length}"
    expect(changed_dirs.empty?).to eq true

    if File.exist?(changed_dir_name)
       test_file_handler.force_rm_rf(changed_dir_name,true)
    end

  end#context
end#desc


