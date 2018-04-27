require 'erb'
require 'pry'
template =<<~EOF
    RLayout::Container.new(width:158.737,  height: 165.182) do
      line(x: 0 , y:1, width: 158.737, stroke_width: 2, height:0)
      text('<%= @title %>', x: 0, y:5, font: 'KoPubDotumPB', font_size: 12, width: 170)
      rect(x: 0, y: 70, width:158.737, height: 65,  fill_color:"CMYK=0,0,0,10")
      <% if @name.include?('_') %>
        <% @name_without_rest = @name.split('_').first %>
        image(local_image: '<%= @name_without_rest %>.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
      <% else %>
        image(local_image: '<%= @name %>.eps', y: 60, width: 60, height: 75, fill_color: 'clear')
      <% end %>
      container(x: 70, y: 80, width:150, bottom_margin: 10, fill_color: 'clear') do
        <% if @name && @name.include?('_') %>
          text('<%= @work %>', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
          text('<%= @position %>', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
        <% elsif @name && @work && @position %>
          <% if @name.include?('_') %>
            text('<%= @name.split("-").first.gsub("+", " ") %>', y:17, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
          <% else  %>
            text('<%= @name.gsub("+", " ") %>', y:17, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
          <% end  %>
          text('<%= @work %>', y:30, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
          text('<%= @position %>', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
        <% elsif @position == nil %>
          text('<%= @name.gsub("+", " ") %>', y:28, font: 'KoPubDotumPB', font_size: 9, fill_color: 'clear')
          text('<%= @work %>', y:41, font: 'KoPubDotumPL', font_size: 8, fill_color: 'clear')
        <% end %>
      end
    end
    EOF

csv_path = 'data.csv'
f = File.open(csv_path, 'r'){|f| f.read}

f.each_line do |line|
  # puts "line:#{line}"
  a = []
  a = line.chomp.split(',')
  @name = a[0]
  @title = a[1]
  @work = a[2]
  @position = a[3]

  puts "++++++++ @name:#{@name}"
  # puts "@position:#{@position}"
  erb   = ERB.new(template)
  layout = erb.result(binding)
  File.open("#{@name}.rb", 'w'){|f| f.write layout}
end
