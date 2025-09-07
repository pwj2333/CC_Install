@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo 错误：请以管理员身份运行此脚本！
    echo.
    echo 操作方法：
    echo 1. 在开始菜单中找到"命令提示符"
    echo 2. 右键点击，选择"以管理员身份运行"
    echo 3. 然后再次运行此脚本
    echo.
    pause
    exit /b 1
)

:: 显示欢迎信息
echo ========================================
echo       薛定猫 Claude Code 安装工具
echo ========================================
echo.

:: 获取API密钥
set /p "API_KEY=请输入您的薛定猫API密钥（将用于替换'sk-...'部分）: "

:: 验证输入
if "%API_KEY%"=="" (
    echo.
    echo 错误：API密钥不能为空！
    pause
    exit /b 1
)

:: 检查Node.js环境 - 使用更稳定的方法
echo.
echo 正在检查Node.js环境...

:: 方法1: 使用 where 命令查找 node.exe
where node >nul 2>&1
if %errorLevel% equ 0 (
    echo 检测到系统中已安装Node.js。
) else (
    echo.
    echo 错误：未检测到Node.js，请先安装Node.js。
    echo 下载地址：https://nodejs.org/
    pause
    exit /b 1
)

:: 方法2: 检查 npm
where npm >nul 2>&1
if %errorLevel% equ 0 (
    echo 检测到系统中已安装npm。
) else (
    echo.
    echo 错误：未检测到npm，请重新安装Node.js。
    pause
    exit /b 1
)

:: 方法3: 尝试获取版本信息但不显示（避免可能的输出问题）
for /f "tokens=*" %%i in ('node --version 2^>nul') do set NODE_VERSION=%%i
if defined NODE_VERSION (
    echo Node.js 版本: !NODE_VERSION!
) else (
    echo.
    echo 错误：无法获取Node.js版本信息，请重新安装Node.js。
    pause
    exit /b 1
)

:: 安装Claude Code
echo.
echo 正在安装Claude Code...
call npm install -g @anthropic-ai/claude-code

if %errorLevel% neq 0 (
    echo.
    echo 错误：Claude Code安装失败！
    echo 请检查网络连接或npm配置。
    pause
    exit /b 1
)

:: 设置环境变量
echo.
echo 正在设置环境变量...
setx ANTHROPIC_AUTH_TOKEN "%API_KEY%"
setx ANTHROPIC_BASE_URL "https://xuedingmao.top"
setx API_TIMEOUT_MS "600000"

:: 完成提示
echo.
echo ========================================
echo           安装成功！
echo ========================================
echo.
echo 已设置的环境变量：
echo ANTHROPIC_AUTH_TOKEN = %API_KEY%
echo ANTHROPIC_BASE_URL   = https://xuedingmao.top
echo API_TIMEOUT_MS       = 600000
echo.
echo 下一步操作：
echo 1. 请确保您的API密钥有效且已激活
echo 2. 您可能需要重新启动命令提示符才能使环境变量生效
echo 3. 测试安装：尝试运行 'claude-code --help' 命令
echo 4. 如需支持，请访问：https://xuedingmao.top
echo.
echo 按任意键退出...
pause >nul