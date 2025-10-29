@echo off

rem jobNo
set job=999

rem ログファイル
set outhulft=%~dp0logs\J%job%.log

rem ログフォルダ作成
if not exist %~dp0logs mkdir %~dp0logs

rem ログフォルダ・ローテーション
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old

rem ========== バッチ処理実行 ==========
>> %outhulft% echo %DATE% %TIME%　HULFT_ERROR確認
>> %outhulft% echo %job% RC=1
EXIT /B 1
