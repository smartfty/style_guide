# Aboug wire service

## Server Ascess

There is a server in Gabia data center

ip:
name:
password:

It is mounted to our NewsGo server as Volumn with ip as name

## detecting incomeing files

Using guard gem we should be able to detect incoming news feed and process them

Does guard work with mounted volumn?

## about contents

- summary

- story
  - xml file

- image
  - xml file
  - thumbnail.jpg
  - preview.jpg
  - high_rest.jpg

## parsing the data

Using happy_mapper gem to parse the xml data
Using ruby class YNewsMl defined in
  lib/y_news_ml.rb

## task to parse at a given intervcal

Using whenever gem to setup a cron job to parse at certain interval

## deleting passed wire content

Delete the stuff that is a week old, from the data base


