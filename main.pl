import os

import zipfile

import shutil


# 再帰的にフォルダ一覧を返却する
def find_non_zip(path):
    list_none_zips = []

    for dirs in os.listdir(path):
        for new_root, new_dirs, new_files in os.walk(path + "\\" + dirs):
            if len(new_dirs) > 1:
                for new_dir in new_dirs:
                    dir_path = os.path.join(new_root, new_dir)

                    print(dir_path)

                    list_none_zips.append(dir_path)

    return list_none_zips


# 入力待ち状態
def wait(message):
    print("●" + message)

    input()


# 配下のディレクトリを圧縮して削除
def zip_directories(path_folder_arg,check_input=1):
    list_targets=[]
    list_target_names=[]

    for path_folder in os.listdir(path_folder_arg):
        oya_path, file_ext = os.path.splitext(path_folder)

        if file_ext != ".zip":
            list_targets.append(path_folder_arg + "\\" + path_folder)

            list_target_names.append(path_folder)

    if len(list_targets) > 0:

        if check_input == 1:

            print("●圧縮前確認")

            for list_target in list_target_names:
                print(list_target)

            input()

        for list_target in list_targets:
            zip_directory(list_target)


# ディレクトリを圧縮して削除
def zip_directory(path_zip):
    oya_path, file_ext = os.path.splitext(path_zip)

    if file_ext == ".zip":
        return

    os.chdir(os.path.dirname(path_zip))

    zip_targets = []

    # pathからファイル名を取り出す
    basename = os.path.basename(path_zip)

    # 作成するzipファイルのフルパス
    zip_file_path = os.path.abspath('%s.zip' % basename)

    for dir_path, dir_names, file_names in os.walk(path_zip):

        for filename in file_names:

            file_path = os.path.join(dir_path, filename)

            # 作成するzipファイルのパスと同じファイルは除外する
            if file_path == zip_file_path:
                continue

            arc_name = os.path.relpath(file_path, os.path.dirname(path_zip))

            zip_targets.append((file_path, arc_name))

    # zipファイルの作成
    zip_file = zipfile.ZipFile(zip_file_path, 'w')

    for file_path, name in zip_targets:
        zip_file.write(file_path, name)

    zip_file.close()

    shutil.rmtree(path_zip)


# 空ディレクトリ削除
def delete_dir_empty(dir_path):
    if dir_path.find('_SEIRI_') > 0:
        return 0

    for root, dirs, files in os.walk(dir_path):

        if len(files) == 0 and len(dirs) == 0:
            return 1

        for d in dirs:
            dir_path_now = os.path.join(dir_path, d)

            return_delete_dir_empty = delete_dir_empty(dir_path_now)

            if return_delete_dir_empty == 1:
                try:
                    os.rmdir(dir_path_now)

                    print('●空ディレクトリを削除しました\t' + dir_path_now)
                except OSError as ex:
                    print()

    return 0
