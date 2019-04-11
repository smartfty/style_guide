namespace :wire do
  
  desc 'load new ytn contents'
  task :new_ytn => [:environment] do
    puts "in new_ytn task..."
    WireServiceWorker.perform_async
  end



  desc 'testing for mounted volumn file change'
  task :volumn_test, [:paths] => [:environment] do |t, args|
    puts "+++++++ testing files change in mounted volumn:#{args.paths}"
    puts "#{Rails.root}"
  end

  desc 'parse wire story xml'
  task :parse_wire_story_xml, [:paths] => [:environment] do |t, args|
    require "#{Rails.root}" + '/config/environment'
    puts " YhArticle.count:#{ YhArticle.count}"
    YNewsML.parse_new_story_xml(args.paths)
  end

  desc 'parse wire picture xml'
  task :parse_wire_picture_xml, [:paths] => [:environment] do |t, args|
    require "#{Rails.root}" + '/config/environment'
    YNewsML.parse_new_picture_xml(args.paths)
  end
end
