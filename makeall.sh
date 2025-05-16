#!/bin/bash
##############################
# 建構所有 Docker 映像檔
# 
# 使用： ./makeall.sh
##############################

# 根目錄
base_dir="docker/php-fpm"
# 日誌目錄
log_dir="logs"
mkdir -p "$log_dir"

# 錯誤日誌
error_log="$log_dir/error.log"
echo "==== Make Build Errors ====" > "$error_log"

# 取得所有子資料夾
for dir in $(find $base_dir -mindepth 1 -maxdepth 1 -type d); do
    # 提取資料夾名稱作為檔案標籤
    dir_name=$(basename "$dir")

    # 執行 make dev 背景作業，並記錄日誌
    log_file_dev="$log_dir/${dir_name}_dev.log"
    echo "Starting make dev in $dir (log: $log_file_dev)"
    make -C "$dir" dev > "$log_file_dev" 2>&1 &
    # 記錄PID
    pids_dev[$!]="$dir_name:dev"

    # 執行 make prod 背景作業，並記錄日誌
    log_file_prod="$log_dir/${dir_name}_prod.log"
    echo "Starting make prod in $dir (log: $log_file_prod)"
    make -C "$dir" prod > "$log_file_prod" 2>&1 &
    # 記錄PID
    pids_prod[$!]="$dir_name:prod"
done

echo ""
echo "Building..."
echo ""

# 等待所有背景程序完成並檢查錯誤
for pid in "${!pids_dev[@]}"; do
    wait $pid
    if [ $? -ne 0 ]; then
        echo "[ERROR] ${pids_dev[$pid]} failed. Check log: $log_dir/${pids_dev[$pid]}.log" | tee -a "$error_log"
    fi
done

for pid in "${!pids_prod[@]}"; do
    wait $pid
    if [ $? -ne 0 ]; then
        echo "[ERROR] ${pids_prod[$pid]} failed. Check log: $log_dir/${pids_prod[$pid]}.log" | tee -a "$error_log"
    fi
done

echo ""
echo "Finish..."
echo ""
echo "All make processes are completed. Check $error_log for errors."
