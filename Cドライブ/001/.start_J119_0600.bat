@echo off

rem jobNo
set job=119

rem ログファイル
set outhulft=%~dp0logs\J%job%.log

rem ログフォルダ作成
if not exist %~dp0logs mkdir %~dp0logs

rem ログフォルダ・ローテーション
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old

rem ========== バッチ処理実行 ==========
set calbat=E:\job\%job%
>> %outhulft% echo %DATE% %TIME%　日次処理を開始します(%calbat%)0600
PUSHD %calbat%
call %calbat%\9.日次連携.bat
IF ERRORLEVEL 1 GOTO ERROR

REM N10 JOBNO.032,033の連携不可時間帯のHULFT送信　
CALL E:\job\HULFT\.start__HULFT_連携不可対応.bat

REM N10 特売夜間処理
CALL E:\JOB\002\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM 発注結果削除処理
CALL E:\JOB\134\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

EXIT /B 0

:ERROR
>> %outhulft% echo %job% RC=1
EXIT /B 1

