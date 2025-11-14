![图标](1.jpg)

# 程序员猫娘一言 🐱

[English Version](https://github.com/sttgf/neko_hitokoto/main/README-en.md)

一个基于DeepSeek API的智能终端助手，以程序员猫娘的角色为你的命令行操作提供有趣的反馈和建议。

## 功能特点 ✨

- **智能反馈**: 根据你的命令执行情况，猫娘会给出鼓励、吐槽或建议
- **随机触发**: 以1/3的概率在命令执行后显示一言，避免频繁打扰
- **备用词库**: 当API不可用时自动使用本地备用消息
- **简单配置**: 支持启用/禁用功能，方便控制
- **API支持**: 集成DeepSeek API，提供智能回复

## 安装指南 📦

### 自动安装（推荐）

```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/sttgf/neko_hitokoto/main/install_neko_dialog.sh

# 运行安装程序
chmod +x install_neko_dialog.sh
./install_neko_dialog.sh
```

安装程序提供：
- 图形化安装界面（使用dialog）
- 自动依赖检查
- API密钥配置
- 进度条显示

### 手动安装

1. 克隆仓库：
```bash
git clone https://github.com/sttgf/neko_hitokoto.git
cd neko_hitokoto
```

2. 运行安装脚本：
```bash
chmod +x neko_hitokoto.sh
./neko_hitokoto.sh
```

## 使用方法 🚀

安装完成后，重新启动终端或运行：
```bash
source ~/.bashrc
```

### 基本命令

```bash
# 启用猫娘一言功能
neko_hitokoto enable

# 禁用功能
neko_hitokoto disable

# 测试API连接
neko_hitokoto test

# 显示帮助
neko_hitokoto help
```

### 功能说明

- **启用后**: 执行命令时有概率触发猫娘回复
- **智能过滤**: 自动忽略`ls`、`cd`等基础命令
- **特殊检测**: 当编辑`.bashrc`文件时会特别关注

## 配置选项 ⚙️

### API密钥配置

1. 获取DeepSeek API密钥：
   - 访问 [DeepSeek平台](https://platform.deepseek.com)
   - 注册账号并获取API密钥

2. 配置密钥：
   - 安装过程中输入
   - 或手动编辑脚本中的`API_KEY`变量

### 自定义设置

可以修改以下变量来自定义行为：
- `API_KEY`: DeepSeek API密钥
- `BACKUP_MESSAGES`: 备用消息库
- 触发概率（修改脚本中的随机数逻辑）

## 卸载 🗑️

```bash
./neko_hitokoto.sh uninstall
```

## 依赖要求 📋

- `bash` (v4.0+)
- `curl` (API调用)
- `jq` (JSON处理)
- `dialog` (图形化安装界面)

### 安装依赖

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install curl jq dialog
```

**CentOS/RHEL:**
```bash
sudo yum install curl jq dialog
```

**Arch Linux:**
```bash
sudo pacman -S curl jq dialog
```

## 故障排除 🔧

### 常见问题

1. **脚本不工作**
   - 检查是否已启用：`neko_hitokoto enable`
   - 是否重启终端或忘记输入 `source ~/.bashrc`
   - 确认API密钥配置正确

2. **API调用失败**
   - 检查网络连接
   - 验证API密钥有效性
   - 查看是否达到API调用限制

3. **依赖缺失**
   - 运行安装脚本的依赖检查功能
   - 手动安装缺失的依赖包

### 日志检查

安装过程中会创建备份文件，位置在：
```bash
ls ~/.bashrc_backups/
```

## 贡献 🤝

欢迎提交Issue和Pull Request！

## 许可证 📄

MIT License

## 更新日志 📝

### v1.0.0
- 初始版本发布
- 支持DeepSeek API集成
- 图形化安装界面
- 基础启用/禁用功能
