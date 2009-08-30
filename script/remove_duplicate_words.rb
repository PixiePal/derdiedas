if __FILE__ == $0
  input = File.new("processed_nouns.txt", "r")
  output = File.new("processed_nouns_no_dups.txt", "w")
  all_words = {}
  count_ambigous_duplicates = 0
  count_simple_duplicates = 0
  
  while (line = input.gets)
    words = line.strip.split(/ --- /)
    
    if all_words[words[1]].nil?
      all_words[words[1]] = words[0]
      output.puts line
    else 
      if all_words[words[1]] != words[0]
        count_ambigous_duplicates += 1
        print "--- Ambiguous duplicate: #{words[1]} -- Didn't remove this. Please check manually!\n"
        output.puts line
      else
        count_simple_duplicates += 1
        print "--- Omiting duplicate: #{words[0]} #{words[1]}\n"
      end
    end
  end
  
  print "#{count_simple_duplicates} duplicate(s) removed.\n"
  print "#{count_ambigous_duplicates} ambigous duplicate(s) found. \n"
  
    
  input.close
  output.close
  
  system "mv processed_nouns_no_dups.txt processed_nouns.txt"
end