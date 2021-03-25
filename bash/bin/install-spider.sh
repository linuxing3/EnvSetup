#!/bin/bash
# Copyright 2019 the Deno authors. All rights reserved. MIT license.
# Copyright 2020 justjavac. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.

echo "==========================================================="
echo "installing spider"
echo "==========================================================="

function spider () {
	docker exec -it spider /root/go/bin/gospider spider
}

function spider_douban_movies() {
	docker exec -it spider /root/go/bin/gospider spider --website=douban
}

function spider_venezuela_news() {
	docker exec -it spider /root/go/bin/gospider spider --website=googlenews --keyword=venezuela
}

function spider_china_news() {
	docker exec -it spider /root/go/bin/gospider spider --website=googlenews --keyword=china
}

function spider_dev_news() {
	docker exec -it spider /root/go/bin/gospider spider --website=googlenews --keyword=development
}

function spider_iciba() {
	docker exec -it spider /root/go/bin/gospider spider --website=iciba
}

while true; do
  read -r -p "    [1] Douban [2] Venezuela News [3] China News [4] Dev News:  " opt
  case $opt in
    1)
      spider_douban_movies
      break
      ;;
    2)
      spider_venezuela_news
      break
      ;;
    3)
      spider_china_news
      break
      ;;
    4)
      spider_dev_news
      break
      ;;
    *)
      echo "Please choose a correct answer"
      ;;
  esac
done
