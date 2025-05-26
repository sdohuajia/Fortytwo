#!/bin/bash

# 检查是否以 root 用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以 root 用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到 root 用户，然后再次运行此脚本。"
    exit 1
fi

# 脚本保存路径
SCRIPT_PATH="$HOME/Fortytwo.sh"

# 安装 Fortytwo 函数
install_fortytwo() {
    # 更新系统并检查/安装 unzip
    echo "更新系统包并检查依赖..."
    if [ -x "$(command -v apt-get)" ]; then
        apt-get update
        if ! command -v unzip &> /dev/null; then
            echo "unzip 未安装，正在安装..."
            apt-get install -y unzip
        fi
    else
        echo "错误: 未检测到 apt-get，当前脚本仅支持基于 Debian/Ubuntu 的系统"
        exit 1
    fi

    # 创建目录并进入
    echo "创建并进入 Fortytwo 目录..."
    mkdir -p ~/Fortytwo && cd ~/Fortytwo

    # 下载 zip 文件到 Fortytwo 目录
    echo "下载 fortytwo-console-app 到 ~/Fortytwo..."
    curl -L -o ~/Fortytwo/fortytwo-console-app.zip https://github.com/Fortytwo-Network/fortytwo-console-app/archive/refs/heads/main.zip

    # 解压文件到 Fortytwo 目录
    echo "解压 fortytwo-console-app.zip 到 ~/Fortytwo..."
    unzip ~/Fortytwo/fortytwo-console-app.zip -d ~/Fortytwo

    # 删除压缩包
    echo "删除 fortytwo-console-app.zip..."
    rm ~/Fortytwo/fortytwo-console-app.zip

    # 进入解压后的目录
    echo "进入 fortytwo-console-app-main 目录..."
    cd ~/Fortytwo/fortytwo-console-app-main

    # 赋予执行权限并运行脚本
    echo "设置并运行 linux.sh..."
    chmod +x linux.sh && ./linux.sh

    echo "安装完成！按任意键返回主菜单..."
    read -n 1
}

# 重新启动 Fortytwo 节点函数
restart_fortytwo() {
    echo "重新启动 Fortytwo 节点..."
    if [ -d "/root/Fortytwo/fortytwo-console-app-main" ]; then
        cd /root/Fortytwo/fortytwo-console-app-main
        if [ -f "linux.sh" ]; then
            chmod +x linux.sh
            ./linux.sh
            echo "节点重新启动完成！按任意键返回主菜单..."
        else
            echo "错误：linux.sh 文件不存在"
        fi
    else
        echo "错误：fortytwo-console-app-main 目录不存在，请先安装 Fortytwo"
    fi
    read -n 1
}

# 主菜单函数
main_menu() {
    while true; do
        clear
        echo "脚本由哈哈哈哈编写，推特 @ferdie_jhovie，免费开源，请勿相信收费"
        echo "如有问题，可联系推特，仅此只有一个号"
        echo "================================================================"
        echo "退出脚本，请按键盘 ctrl + C 退出即可"
        echo "1. 安装 Fortytwo"
        echo "2. 重新启动 Fortytwo 节点"
        echo "3. 退出"
        echo "================================================================"
        read -p "请选择一个选项 [1-3]: " choice
        case $choice in
            1)
                install_fortytwo
                ;;
            2)
                restart_fortytwo
                ;;
            3)
                echo "退出脚本..."
                exit 0
                ;;
            *)
                echo "无效选项，请输入 1、2 或 3"
                read -n 1 -p "按任意键继续..."
                ;;
        esac
    done
}

# 保存脚本到指定路径
echo "保存脚本到 $SCRIPT_PATH..."
cp "$0" "$SCRIPT_PATH" && chmod +x "$SCRIPT_PATH"

# 启动主菜单
main_menu
