require './sources/FileRetriever.rb'

describe :FileRetriever,must:true do
  it "retrieved not empty" do
    skip_dir_list = []
    file_retriever = FileRetriever.new(skip_dir_list)
    retrieved = file_retriever.retrieved(".")
    expect(retrieved.empty?).to eq false
  end
end
