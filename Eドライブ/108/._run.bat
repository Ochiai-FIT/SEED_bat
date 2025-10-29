@echo off
REM 状況確認
REM Get-ExecutionPolicy

REM ポリシー変更（管理者権限で開く）
REM Set-ExecutionPolicy RemoteSigned

REM カレントフォルダ固定
pushd %~dp0

REM プロセスチェック後にバッチ開始
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "%~dp0\.process.ps1 .start.bat;exit $LASTEXITCODE"

IF ERRORLEVEL 1 EXIT /B 1
EXIT /B 0

