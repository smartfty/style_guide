
svg_source_foler = "/Users/mskim/Development/rails5/style_guide/public/1/page_heading/text-2017-5-30"

Dir.glob("#{svg_source_foler}/*.svg").each_with_index do |svg_path|
  base_name = File.basename(svg_path)
  no_ext_name = File.basename(svg_path, ".svg")
  puts "base_name:#{base_name}"
  puts "no_ext_name:#{no_ext_name}"
  system("/Applications/Inkscape.app/Contents/Resources/bin/inkscape --without-gui --file=#{base_name} --export-pdf=#{no_ext_name}.pdf")
end
