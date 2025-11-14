#!/bin/bash
# install_neko_dialog.sh - 使用dialog的猫娘一言安装脚本

# 配置变量
NEKO_SCRIPT_NAME="neko_hitokoto.sh"
NEKO_SCRIPT_DIR="$HOME/.neko_hitokoto"
BASHRC_FILE="$HOME/.bashrc"
BACKUP_DIR="$HOME/.bashrc_backups"
TEMP_DIR="/tmp/neko_install"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 检查dialog是否安装
check_dialog() {
    if ! command -v dialog &> /dev/null; then
        echo -e "${RED}错误：未找到 'dialog' 命令。${NC}"
        echo "请先安装 dialog 工具："
        echo "Ubuntu/Debian: sudo apt-get install dialog"
        echo "CentOS/RHEL: sudo yum install dialog"
        echo "Arch Linux: sudo pacman -S dialog"
        exit 1
    fi
}

# 显示欢迎界面
show_welcome() {
    dialog --title "🐱 程序员猫娘一言安装程序" \
           --msgbox "\n欢迎安装程序员猫娘一言脚本！\n\n这个脚本将会：\n• 安装猫娘一言主脚本\n• 配置.bashrc文件\n• 设置API密钥（可选）\n\n安装过程大约需要10秒钟。" 12 50
}

# 带进度条的安装过程
install_with_progress() {
    {
        # 初始化变量
        local total_steps=8
        local current_step=0
        
        # 步骤1: 创建备份目录 (5%)
        echo "XXX"
        echo "5"
        echo "创建备份目录..."
        echo "XXX"
        mkdir -p "$BACKUP_DIR" 2>/dev/null
        sleep 1
        ((current_step++))
        
        # 步骤2: 备份.bashrc文件 (15%)
        echo "XXX"
        echo "15"
        echo "备份原有.bashrc配置..."
        echo "XXX"
        local timestamp=$(date +%Y%m%d_%H%M%S)
        if [[ -f "$BASHRC_FILE" ]]; then
            cp "$BASHRC_FILE" "$BACKUP_DIR/bashrc_backup_$timestamp" 2>/dev/null
        fi
        sleep 1
        ((current_step++))
        
        # 步骤3: 创建脚本目录 (25%)
        echo "XXX"
        echo "25"
        echo "创建脚本安装目录..."
        echo "XXX"
        mkdir -p "$NEKO_SCRIPT_DIR" 2>/dev/null
        mkdir -p "$TEMP_DIR" 2>/dev/null
        sleep 1
        ((current_step++))
        
        # 步骤4: 安装主脚本 (35%)
        echo "XXX"
        echo "35"
        echo "安装猫娘一言主脚本..."
        echo "XXX"
        cat > "$NEKO_SCRIPT_DIR/$NEKO_SCRIPT_NAME" << 'EOF'
#!/bin/bash
# neko_hitokoto.sh - DeepSeek驱动的程序员猫娘一言

# DeepSeek API配置
API_KEY="${NEKO_API_KEY:-sk-9ae41f0d05cd46758f95b9a4ca6d26ac}"
API_URL="https://api.deepseek.com/v1/chat/completions"

# 随机话语库（备用，当API不可用时使用）
BACKUP_MESSAGES=(
    "💻 雑魚が、代码写得不错呢~"
    "🐱 喵呜~这个命令执行得很完美哦！"
    "🚀 哇！效率好高，不愧是雑魚程序员~"
    "🌟 今天的bug又少了一个呢，喵~"
    "📚 继续学习吧，雑魚也要努力变强！"
)

# 调用DeepSeek API获取猫娘回复
get_neko_response() {
    local user_input="$1"
    
    # 构建请求数据
    local request_data=$(jq -n --arg input "$user_input" '{
        "model": "deepseek-chat",
        "messages": [
            {
                "role": "system", 
                "content": "你是一只喜欢说「雑魚」的程序员猫娘。回复要简短有趣，不超过50token。对用户的命令执行进行吐槽、鼓励或给建议。当用户输入了不正确的指令时，你要嘲笑它。当用户输入了nano .bashrc或用任意一个文件编辑器编辑了.bashrc文件的话，你得表现的惊讶，并询问用户为啥要编辑.bashrc。可以适当的使用颜文字/指令"
            },
            {
                "role": "user", 
                "content": "用户刚才执行了命令：\($input)，现在请用程序员猫娘的语气简短回应，一定不要超过50token"
            }
        ],
        "max_tokens": 50,
        "temperature": 0.8
    }')
    
    # 发送API请求
    local response=$(curl -s -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "$request_data")
    
    # 提取回复内容
    local neko_response=$(echo "$response" | jq -r '.choices[0].message.content' 2>/dev/null)
    
    # 如果API调用失败，使用备用消息
    if [[ -z "$neko_response" || "$neko_response" == "null" ]]; then
        local count=${#BACKUP_MESSAGES[@]}
        local index=$((RANDOM % count))
        neko_response="${BACKUP_MESSAGES[$index]}"
    fi
    
    echo "🐱 $neko_response"
}

# 显示随机一言
show_hitokoto() {
    local last_command=$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//')
    
    # 过滤掉一些基础命令，避免频繁提示
    local ignore_commands=("ls" "cd" "pwd" "clear" "neko" "hitokoto")
    for cmd in "${ignore_commands[@]}"; do
        if [[ "$last_command" == "$cmd"* ]]; then
            return 0
        fi
    done
    
    # 控制显示频率（1/3概率）
    local chance=$((RANDOM % 3))
    if [[ $chance -eq 0 ]]; then
        echo ""
        get_neko_response "$last_command"
        echo ""
    fi
}

# 主功能函数
neko_hitokoto() {
    case "${1:-}" in
        "enable")
            # 启用一键一言功能
            if [[ -n "$PROMPT_COMMAND" ]]; then
                if [[ $PROMPT_COMMAND != *show_hitokoto* ]]; then
                    PROMPT_COMMAND="show_hitokoto; $PROMPT_COMMAND"
                fi
            else
                PROMPT_COMMAND="show_hitokoto"
            fi
            echo "🐱 程序员猫娘一言已启用！"
            ;;
        "disable")
            # 禁用功能
            PROMPT_COMMAND="${PROMPT_COMMAND//show_hitokoto;/}"
            PROMPT_COMMAND="${PROMPT_COMMAND//show_hitokoto/}"
            echo "🔕 一言功能已禁用"
            ;;
        "test")
            # 测试功能
            echo "🧪 测试猫娘回复："
            get_neko_response "测试命令"
            ;;
        "help"|"")
            # 显示帮助
            echo "🐱 程序员猫娘一言使用说明："
            echo "  neko_hitokoto enable     # 启用一键一言"
            echo "  neko_hitokoto disable    # 禁用功能"
            echo "  neko_hitokoto test       # 测试API"
            echo "  neko_hitokoto help       # 显示帮助"
            ;;
        *)
            echo "❌ 未知命令: $1"
            echo "   使用 'neko_hitokoto help' 查看帮助"
            ;;
    esac
}

# 如果直接运行脚本，执行相应功能
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    neko_hitokoto "$@"
else
    echo "🐱 程序员猫娘一言脚本已加载！"
    echo "   输入 'neko_hitokoto enable' 启用功能"
fi
EOF
        chmod +x "$NEKO_SCRIPT_DIR/$NEKO_SCRIPT_NAME"
        sleep 2
        ((current_step++))
        
        # 步骤5: 修改.bashrc文件 (55%)
        echo "XXX"
        echo "55"
        echo "配置.bashrc文件..."
        echo "XXX"
        # 移除旧配置
        grep -v "neko_hitokoto" "$BASHRC_FILE" > "$TEMP_DIR/bashrc_temp" 2>/dev/null
        mv "$TEMP_DIR/bashrc_temp" "$BASHRC_FILE" 2>/dev/null
        
        # 添加新配置
        echo "" >> "$BASHRC_FILE"
        echo "# 程序员猫娘一言配置" >> "$BASHRC_FILE"
        echo "# 自动添加于 $(date)" >> "$BASHRC_FILE"
        echo "source $NEKO_SCRIPT_DIR/$NEKO_SCRIPT_NAME" >> "$BASHRC_FILE"
        sleep 2
        ((current_step++))
        
        # 步骤6: 设置权限 (70%)
        echo "XXX"
        echo "70"
        echo "设置文件权限..."
        echo "XXX"
        chmod 755 "$NEKO_SCRIPT_DIR" 2>/dev/null
        chmod 644 "$NEKO_SCRIPT_DIR/$NEKO_SCRIPT_NAME" 2>/dev/null
        sleep 1
        ((current_step++))
        
        # 步骤7: 清理临时文件 (85%)
        echo "XXX"
        echo "85"
        echo "清理临时文件..."
        echo "XXX"
        rm -rf "$TEMP_DIR" 2>/dev/null
        sleep 1
        ((current_step++))
        
        # 步骤8: 完成安装 (100%)
        echo "XXX"
        echo "100"
        echo "安装完成！"
        echo "XXX"
        sleep 1
        
    } | dialog --title "🐱 安装进度" --gauge "正在初始化安装过程..." 10 60 0
}

# 配置API密钥
setup_api_key() {
    dialog --title "API密钥配置" --yesno "是否要现在配置DeepSeek API密钥？\n\n如果跳过，可以使用默认密钥或稍后手动配置。" 10 50
    local response=$?
    
    if [ $response -eq 0 ]; then
        API_KEY=$(dialog --title "输入API密钥" --inputbox "请输入您的DeepSeek API密钥:" 10 50 3>&1 1>&2 2>&3)
        if [ -n "$API_KEY" ]; then
            # 更新脚本中的API密钥
            sed -i "s/API_KEY=\"[^\"]*\"/API_KEY=\"$API_KEY\"/" "$NEKO_SCRIPT_DIR/$NEKO_SCRIPT_NAME"
            dialog --title "成功" --msgbox "API密钥已配置完成！" 8 40
        fi
    fi
}

# 检查依赖
check_dependencies() {
    local missing=()
    
    if ! command -v jq &> /dev/null; then
        missing+=("jq")
    fi
    
    if ! command -v curl &> /dev/null; then
        missing+=("curl")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        dialog --title "依赖检查" --yesno "缺少以下依赖: ${missing[*]}\n\n是否尝试自动安装？" 10 50
        
        if [ $? -eq 0 ]; then
            if command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y "${missing[@]}" | \
                dialog --title "安装依赖" --progressbox "正在安装依赖包..." 20 70
            elif command -v yum &> /dev/null; then
                sudo yum install -y "${missing[@]}" | \
                dialog --title "安装依赖" --progressbox "正在安装依赖包..." 20 70
            else
                dialog --title "警告" --msgbox "无法自动安装依赖，请手动安装: ${missing[*]}" 10 50
            fi
        fi
    fi
}

# 显示完成信息
show_completion() {
    dialog --title "安装完成" --msgbox "🐱 程序员猫娘一言已成功安装！\n\n使用说明：\n1. 重新启动终端或运行: source ~/.bashrc\n2. 启用功能: neko_hitokoto enable\n3. 禁用功能: neko_hitokoto disable\n4. 测试功能: neko_hitokoto test\n5. 查看帮助: neko_hitokoto help\n\n备份文件位置: $BACKUP_DIR" 16 60
}

# 测试安装
test_installation() {
    if source "$NEKO_SCRIPT_DIR/$NEKO_SCRIPT_NAME" 2>/dev/null; then
        dialog --title "测试结果" --msgbox "脚本加载测试成功！" 8 40
        return 0
    else
        dialog --title "测试结果" --msgbox "脚本加载测试失败，请检查安装。" 8 40
        return 1
    fi
}

# 主安装函数
main() {
    check_dialog
    show_welcome
    check_dependencies
    install_with_progress
    setup_api_key
    test_installation
    show_completion
    clear
    echo -e "${GREEN}🐱 安装完成！重新启动终端或运行: source ~/.bashrc${NC}"
}

# 卸载函数
uninstall() {
    dialog --title "确认卸载" --yesno "确定要卸载程序员猫娘一言吗？" 8 40
    if [ $? -ne 0 ]; then
        clear
        echo "卸载已取消。"
        exit 0
    fi
    
    {
        echo "XXX"
        echo "20"
        echo "备份当前.bashrc文件..."
        echo "XXX"
        local timestamp=$(date +%Y%m%d_%H%M%S)
        cp "$BASHRC_FILE" "$BACKUP_DIR/bashrc_backup_pre_uninstall_$timestamp" 2>/dev/null
        sleep 1
        
        echo "XXX"
        echo "50"
        echo "从.bashrc中移除配置..."
        echo "XXX"
        grep -v "neko_hitokoto" "$BASHRC_FILE" > /tmp/bashrc_temp 2>/dev/null
        mv /tmp/bashrc_temp "$BASHRC_FILE" 2>/dev/null
        sleep 1
        
        echo "XXX"
        echo "80"
        echo "删除脚本文件..."
        echo "XXX"
        rm -rf "$NEKO_SCRIPT_DIR" 2>/dev/null
        sleep 1
        
        echo "XXX"
        echo "100"
        echo "卸载完成！"
        echo "XXX"
        sleep 1
    } | dialog --title "卸载进度" --gauge "正在卸载猫娘一言..." 10 60 0
    
    dialog --title "卸载完成" --msgbox "程序员猫娘一言已成功卸载！\n\n请重新启动终端或运行: source ~/.bashrc" 10 50
    clear
}

# 参数处理
case "${1:-}" in
    "uninstall")
        uninstall
        ;;
    "help")
        echo "用法: $0 [command]"
        echo "命令:"
        echo "  install    - 安装猫娘一言（默认）"
        echo "  uninstall  - 卸载猫娘一言"
        echo "  help       - 显示帮助"
        ;;
    *)
        main
        ;;
esac
