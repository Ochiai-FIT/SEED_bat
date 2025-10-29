@echo off

rem jobNo
set job=010

rem ログファイル
set outhulft=%~dp0logs\J%job%.log

rem ログフォルダ作成
if not exist %~dp0logs mkdir %~dp0logs

rem ログフォルダ・ローテーション
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old

rem ========== バッチ処理実行 ==========
set calbat=E:\job\%job%
>> %outhulft% echo %DATE% %TIME%　日次処理を開始します(%calbat%)
PUSHD %calbat%
call %calbat%\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

EXIT /B 0

:ERROR
>> %outhulft% echo %job% RC=1
EXIT /B 1
