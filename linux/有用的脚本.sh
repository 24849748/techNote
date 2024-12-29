#!/bin/sh

function runExe() {
    if [ $# -lt 1 ]; then
        echo -e "\033[1;31mERR: require at least input EXE name!!\033[0m"
        return
    fi

    printf "\033[1;32m"
    printf "#################################\n"
    printf "#   START %-21s #\n" $1
    printf "#################################"
    printf "\033[0m\n"

    # Run EXE bin here
    start_time=$(date +%s)
    $@
    end_time=$(date +%s)
    spent_time=$((end_time - start_time))
    echo "$1 start spent time: $spent_time s"
    sleep 1
}

# echo "into allstart"


## 使用demo
# runExe EmxCoreServer -b
# runExe EmxMediaServer -b
# runExe EmxModulesServer -b
# runExe GuiV1Server -b
# runExe Launcher -b
# runExe DxMain -b

# echo "leave allstart"