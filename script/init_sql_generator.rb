if __FILE__ == $0
  input = File.new("processed_nouns.txt", "r")
  output = File.new("init_data.sql", "w")
  while (line = input.gets)
    words = line.strip.split(/ --- /)
    
    line = "insert into words (article, german, english)"
    line += " values ('#{words[0]}', '#{words[1]}', '#{words[2]}');"
    
    output.puts line
  end
  
  #output.puts "exit 0;"
  
  input.close
  output.close
  
end