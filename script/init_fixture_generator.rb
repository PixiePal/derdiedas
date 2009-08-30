if __FILE__ == $0
  input = File.new("processed_nouns.txt", "r")
  output = File.new("init_data.yml", "w")
  counter = 0
  while (line = input.gets)
    words = line.strip.split(/ --- /)
    
    counter += 1
    line = "#{counter}:\n  id: #{counter}\n  article: #{words[0]}\n"  
    line += "  german: #{words[1]}\n\n"
    
    output.puts line
  end
  
  input.close
  output.close
  
end