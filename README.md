# FileRetriever 

It is a sample that gets information of specified directory recursively.
Still on the way of creation..


## usage

#### Clone this repository



#### if you want to test
bundle install --path vendor/bundle

#### run the test
bundle exec rspec --tag must



## FileRetriever
This is a class that gets directories or files information.

#### get information of  directories as array
```
  skip_dir_names = ["vendor",".git"]
  file_retriever = FileRetriever.new(skip_dir_names)

  file_retriever.retrieved(".")
```

#### When you want to process in callback
```
  callback = lambda {|file_type,file_name,abs_path| 
    p file_type,file_name,abs_path
  }
  file_retriever.retrieve(".",callback)

```
[Please refer to here](https://github.com/hayao11/FileRetriever/blob/327abbc64020a712decf2b9d5feefad63a2f368b/sources/FileRetriever.rb#L81)

## FileChanger

This change directories or files information.
At present, changing the snake case directory name to Pascal case or Camel case is the main task of this class.(I couldn't think of a good name. So, for now.)

```
  #Directories you want to skip
  skip_dir_names =   ['Carthage','Pods','spec','node_modules']
  
  #:to_camel or :to_pascal
  change_type  = :to_pascal
  file_changer = FileChanger.new(skip_dir_names)

  #specify retrieve target directory. (relative or absolute path)
  retrieve_target_path = "" # Be careful when specifying
  
  #retrieved directories data
  to_be_changed_dirs_data = file_changer.retrieve_snake_dirs(retrieve_target_path,change_type)
  
    #change directoy name
    file_changer.change_dirs_name(to_be_changed_dirs_data)

```

[Please refer here](https://github.com/hayao11/FileRetriever/blob/327abbc64020a712decf2b9d5feefad63a2f368b/FileChanger.rb#L78)

## Licence
[MIT](https://github.com/hayao11/FileRetriever/blob/master/LICENSE)



