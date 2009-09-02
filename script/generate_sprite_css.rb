begin
  # Where shall the css be generated. Careful! ANY EXISTING FILES ARE OVERWRITTEN!!!
  #output_file = File.new('temp.css', "w") 
  
  # The width and height of one button
  button_width=66
  button_height=41
  
  # The types of the diffetent buttons and all the possible states for one button
  x_values = %w(der die das)
  y_values = %w(button ghost wrong good)
  
  # The path of the image file containing the appended button images.
  # The button images shall be appended in one row, in the following order: 
  # type1-state1, type1-state2, ... type1-stateN, type2-state1, , type2-state2 ... 
  image_path='../images/derdiedas-buttons.png'
  
  
  css_id_array = x_values.collect {|x| "##{x}_button a" }
	puts css_id_array * ",\n" + " {\n"
  puts "  width: #{button_width}px;\n"
  puts "  height: #{button_height}px;\n"
  puts "  background-image: url(#{image_path});\n"
  puts "  background-repeat: no-repeat;\n"
  puts "  text-decoration: none;\n"
  puts "  display: inline-block;\n"
  puts "}\n"
  
  css_id_array = x_values.collect {|x| "##{x}_button a span" }
	puts css_id_array * ",\n" + " {\n"
  puts "  visibility: hidden;\n"
  puts "}\n"
  
  x_values.each do |x|
    y_values.each do |y|
      puts "##{x}_button.#{y} a {\n"
	    position_x = button_width * x_values.index(x)
	    position_y = button_height * y_values.index(y)
	    puts "  background-position: -#{position_x}px -#{position_y}px;\n"
	    puts "}\n"
    end
  end

  #output_file.close
  rescue => err
    puts "Exception: #{err}"
    err
end