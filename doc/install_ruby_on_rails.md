# Install Ruby on Rails
https://www.driftingruby.com/episodes/getting-started-ruby-on-rails-development-environment

defaults write com.apple.finder AppleShowAllFiles -bool true

## Homebrew

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

## iTerm2

brew cask install iterm2

## rvm

brew install gpg
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
source /Users/$(whoami)/.rvm/scripts/rvm
rvm list known
rvm install 2.4.1
gem update --system
echo 'gem: --no-document' >> ~/.gemrc


## rails
gem install bundler
gem install rails

## git
brew install git
git config --global user.name "USERNAME" && git config --global user.email "EMAILADDRESS"

## Atom
brew cask install atom
