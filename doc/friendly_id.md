# Using friendly_id


gem 'freindly_id'

## update db

rake db:migrate

## change Model

extend FriendlyId
friendly_id :method_to_genete_slug, use: :slugged

friendly_id :method_to_genete_slug, use: :slugged
friendly_id :friendly_string, :use => [:slugged]


## update existing records

ModelNmae.find_each(&:save)
