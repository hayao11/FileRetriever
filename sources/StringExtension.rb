
class String
 def split_and_strip(sep="\n")
   self.split(sep).map{|s| s.strip }
 end
end


if $0 == __FILE__
  str = <<-EOS
  aa
  bb
  cc
  EOS
  p str.split_and_strip
end

