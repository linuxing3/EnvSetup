#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# 将源目录的文件，根据扩展名自动分类，移动到新目录内，更改为小写名称
# python organize_files_by_file_ext.py src dest
# 


import os
import shutil
import argparse

# ------------------------------------------------------------------------------ #
# 常量定义                                                                     
# ------------------------------------------------------------------------------ #
DIRECTORIES = {
 "图片": [".jpeg", ".jpg", ".tiff", ".gif", ".bmp", ".png", ".bpg", ".svg",
 ".heif", ".psd"],
 "视频": [".avi", ".flv", ".wmv", ".mov", ".mp4", ".webm", ".vob", ".mng",
 ".qt", ".mpg", ".mpeg", ".3gp", ".mkv"],
 "文档": [".oxps", ".epub", ".pages", ".docx", ".doc", ".fdf", ".ods",
 ".odt", ".pwi", ".xsn", ".xps", ".dotx", ".docm", ".dox",
 ".rvg", ".rtf", ".rtfd", ".wpd", ".xls", ".xlsx", ".ppt",
 ".pptx",".csv",".pdf"],
 "压缩文件": [".a", ".ar", ".cpio", ".iso", ".tar", ".gz", ".rz", ".7z",
 ".dmg", ".rar", ".xar", ".zip"],
 "影音": [".aac", ".aa", ".aac", ".dvf", ".m4a", ".m4b", ".m4p", ".mp3",
 ".msv", ".ogg", ".oga", ".raw", ".vox", ".wav", ".wma"],
 "文本": [".txt", ".in", ".out", ".csv", ".md", ".org", ".vcf"],
 "编程": [".py",".html5", ".html", ".htm", ".xhtml",".c",".cpp",".java",".css", ".sh", ".py", ".bash", ".go"],
 "可执行程序": [".exe"],
}

# ------------------------------------------------------------------------------ #
# 定义命令行的参数
# dir_path  源目录
# dest_dest  新目录
# ------------------------------------------------------------------------------ #
parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,
                                 description="Python organize files by file extensions.")
parser.add_argument("dir_path", default="./", nargs="?",
                    help="Read the location of src directory")
parser.add_argument("dest_path", default="./", 
                    help="Set the location of dest directory")
 
args = parser.parse_args()

path = args.dir_path
dest = args.dest_path

# ------------------------------------------------------------------------------ #
# 数据格式定义的帮助器
# ------------------------------------------------------------------------------ #
def flat_fields(config):
    """展开配置

    parameters:
    ---------------------------------------------------------
    config:           dictionary          config scheme definition  
    """
    list=[]
    for item in config:
        for ext in config[item]:
          list.append(ext.split('.')[-1])
    return list


def get_field_name(format, file_formats):
    """获取文件格式对应所属的上一级标签的名字

    parameters:
    ---------------------------------------------------------
    format:             string              format definition  
    file_formats:       dictionary          config scheme definition  
    """
    statement = format.lower()
    for item in file_formats:
        if statement in file_formats[item]:
            return item

# ------------------------------------------------------------------------------ #
# 文件系统操作
# ------------------------------------------------------------------------------ #
def mk_classified_dirs(path, file_formats):
    """分类文件整理

    parameters:
    ---------------------------------------------------------
    mk_classified_dirs(path, file_formats)
    path:                   string              source path to find files
    file_formats:           dictionary          file formats scheme definition  
    
    """
    for item in file_formats:
        os.makedirs(os.path.join(path, item), exist_ok=True)
        for ext in file_formats[item]:
          os.makedirs(os.path.join(path, item, ext.split('.')[-1]), exist_ok=True)


def origanize_files(path, dest, file_formats):
    """展开数据集定义为一个数组
    步骤:
    1. 如果是文件夹，递归调用进行子目录的操作
    2. 确定源文件地址
    3. 查询文件格式作为子类，并据此用get_field_name查找属于某一大类
    4. 确认目标文件地址，移动到改地址

    parameters:
    ---------------------------------------------------------
    mk_classified_dirs(path, file_formats)
    path:                   string              source path to find files
    dest:                   string              destination path to save new files
    file_formats:           dictionary          file formats scheme definition

    """ 
    # file_formats_list = flat_fields(file_formats)
    for entry in os.scandir(path):
        # 1. 
        if entry.is_dir():
            origanize_files(entry.path, dest, file_formats)
        # 2.
        file_path = os.path.join(path, entry.name)
        print('源文件:      ' + file_path)
        # 3.
        file_format = entry.name.split('.')[-1]
        field_name = get_field_name('.' + file_format, file_formats)
        if field_name:
            # 4.
            file_new_path = os.path.join(dest, field_name, file_format, entry.name.lower())
            print('新地址:    ' + file_new_path + '\n')
            shutil.move(file_path, file_new_path )

# ------------------------------------------------------------------------------ #
# 程序入口
# ------------------------------------------------------------------------------ #
if __name__ == "__main__":
    mk_classified_dirs(dest, DIRECTORIES)
    origanize_files(path, dest, DIRECTORIES)