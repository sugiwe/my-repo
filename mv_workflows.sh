#!/bin/bash

# Usage
# ./mv_workflow.sh [YYYYMMDD]
#   引数として日付を渡すと日付をファイル名の一部とするファイルを対象としてcompletedディレクトリに移動します。
#   デフォルト値は本日の日付です。

if [ $# -eq 0 ]; then
    DATE_PATTERN=$(date +"%Y%m%d")
    echo "日付が指定されていないため、本日の日付 $DATE_PATTERN を使用します。"
else
    DATE_PATTERN=$1
fi

if [ ! -d ".github/workflows" ]; then
    echo "エラー: .github/workflows ディレクトリが存在しません。"
    exit 1
fi

if [ ! -d "./completed" ]; then
    mkdir -p ./completed
    echo "completed ディレクトリを作成しました。"
fi

matching_files=()
for file in .github/workflows/*"$DATE_PATTERN"*; do
    if [ -f "$file" ]; then
        matching_files+=("$file")
    fi
done

if [ ${#matching_files[@]} -eq 0 ]; then
    echo "移動するファイルがありません: $DATE_PATTERN を含むファイルは見つかりませんでした。"
    exit 0
fi

for file in "${matching_files[@]}"; do
    filename=$(basename "$file")
    mv "$file" "./completed/"
    echo "移動完了: $filename を ./completed/ に移動しました。"
done

# ディレクトリの空チェック
if [ -z "$(ls -A .github/workflows)" ]; then
    touch .github/workflows/.gitkeep
    echo ".github/workflows ディレクトリが空になったため、.gitkeep ファイルを作成しました。"
fi

echo "処理完了: 日付 $DATE_PATTERN を含む ${#matching_files[@]} 個のファイルを ./completed に移動しました。"
