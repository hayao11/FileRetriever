require './spec/TestFileHandler.rb'

describe 'FileChanger',must:true do
  it 'skip dengerous path ' do
   test_file_handler = TestFileHandler.new
   test_file_handler.set_up_skip_delete_list.each do |s|
     if test_file_handler.skip_delete_path?(s)
       expect { test_file_handler.force_rm_rf(s) }.to raise_error(Errors::DangerousPathError)
     end
   end
  end#it
end#describe

