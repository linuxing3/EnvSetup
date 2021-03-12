#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import json
import requests


def read_file():
    """读取书签文件内容"""
    # 书签路径
    google_fav_file_path = 'C:/Users/Wjb/AppData/Local/Google/Chrome/User Data/Default/Bookmarks'
    if os.path.exists(google_fav_file_path):
        with open(google_fav_file_path, 'rb') as r:
            goog_fav = r.read().decode('utf-8')
    return goog_fav


def get_bookmark_total(bookstr):
    """将书签文件转换成Python字典"""
    if len(book_str):
        book_json = json.loads(book_str)

    # 得到主要内容
    children_bar = book_json['roots']['bookmark_bar']['children']
    return children_bar


def get_detail(children: list, name, index):
    """递归解析书签信息"""
    if len(children) > 0:
        for child in children:
            if 'children' in child and child.get('type') == 'folder':
                # 书签文件夹，进行递归解析
                get_detail(child.get('children'), f'{name} -- {child.get("name")}', index+1)

            if child.get('type') == 'url':
                # 书签URL，进行去重判断
                print_complex_url(index, name, child.get('name'), child.get('url'))


total_fav = dict()
def print_complex_url(index, direct, name, url):
    """按照书签名检查是否重复"""
    if f'{name}' in total_fav:
        # 重复
        if index >= total_fav.get(f'{name}')[0]:
            print(direct, name)
        else:
            print(total_fav.get(f'{name}')[1], name)
            total_fav[f'{name}'] = [index, direct, name, url]
    else:
        # 不重复
        total_fav[f'{name}'] = [index, direct, name, url]


def is_bookmarks_active():
    """检查去重后的书签是否有效"""
    for key in total_fav:
        url = total_fav.get(key)[3]
        is_ok = is_url_ok(url)
        if is_ok in [-1, -2, -3]:
            print(total_fav.get(key)[1], key)


def is_url_ok(url):
    """判断URL是否有效"""
    try:
        resu = requests.get(url, timeout=5)
        if resu.status_code == 200:
            # 正常
            return 0
        else:
            return -3
    except requests.exceptions.ConnectionError as e:
        return -1
    except Exception as e:
        return -2


if __name__ == '__main__':
    book_str = read_file()
    children_bar = get_bookmark_total(book_str)
    # print(type(children_bar))
    get_detail(children_bar, 'root', 0)
    print('检查书签重复完成')
    is_bookmarks_active()
