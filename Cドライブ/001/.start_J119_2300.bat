@echo off

rem jobNo
set job=119

rem ログファイル
set outhulft=%~dp0logs\J%job%.log

rem ログフォルダ作成
if not exist %~dp0logs mkdir %~dp0logs

rem ログフォルダ・ローテーション
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old

REM REBOOT制御ファイル
SET FILENAME=E:\JOB\REBOOT\processing
TYPE NUL > %FILENAME%

rem ========== バッチ処理実行 ==========
set calbat=E:\job\%job%
>> %outhulft% echo %DATE% %TIME%　日次処理を開始します(%calbat%)2300
PUSHD %calbat%


REM 特売3締(本締)継続
CALL E:\JOB\033\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM CCR 特売23時締め
CALL E:\JOB\115\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM 処理日付カウントアップ
CALL E:\JOB\036\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM 後処理（催し検索ロード～）
CALL E:\JOB\050\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM REBOOT制御ファイル削除
DEL %FILENAME%

EXIT /B 0

:ERROR
>> %outhulft% echo %job% RC=1
EXIT /B 1
