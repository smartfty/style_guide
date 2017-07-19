require 'prawn-svg'


@content = File.open("front_page_heading.svg", 'r'){|f| f.read}

Prawn::Document.generate("front_page_heading.pdf") do
  svg @content
end
