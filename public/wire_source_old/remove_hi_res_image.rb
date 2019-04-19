
images_folder = File.dirname(__FILE__) + "/201_PHOTO_YNA"

Dir.glob("#{images_folder}/20181010/*.jpg").each do |image|
  next if image =~/_T2.jpg$/
  next if image =~/_P1.jpg$/
  puts image
  system("rm #{image}")

end