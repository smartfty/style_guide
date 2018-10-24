namespace :wire do
  desc 'seed stories'
  task :seed_story =>:environment do
    title = "여기는 제목 입니다."
    subtitle = "여기는 제목 입니다."
    base = "여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다. 여기는 본문입니다.\n\n"
    User.all.each do |user|
      10.times do |i|
        date = Date.today
        status = true if i == 2
        random_num = (15..30).to_a.sample
        body = base*random_num
        Story.where(date: date, user: user, group: user.group, title: title, subtitle: subtitle, body: body, summitted: status).first_or_create if user.group
      end
    end
  end
end
