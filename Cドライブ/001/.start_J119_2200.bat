@echo off

rem jobNo
set job=119

rem ログファイル
set outhulft=%~dp0logs\J%job%.log

rem ログフォルダ作成
if not exist %~dp0logs mkdir %~dp0logs

rem ログフォルダ・ローテーション
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old


rem ========== ターゲット時間を指定=======
rem HHMISS形式（時間の先頭は0を付けない）
rem set targetTime=193000
set targetTime=221000

:chekTime
rem ========== 日付取得 =================
rem 時間を取得(HHMIDD)取得
set nowTime=%time:~0,2%%time:~3,2%%time:~6,2%
echo %nowTime% %targetTime%

if %nowTime% LSS %targetTime% goto wait


rem ========== バッチ処理実行 ==========
set calbat=E:\job\%job%
>> %outhulft% echo %DATE% %TIME%　日次処理を開始します(%calbat%)2200
PUSHD %calbat%
call %calbat%\8.特売連携22時.bat
IF ERRORLEVEL 1 GOTO ERROR

REM CCR 特売22時締め（新店改装店発注、予約発注）
CALL E:\JOB\109\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM JOB 28
CALL E:\JOB\028\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM 特売3締(本締)
CALL E:\JOB\032\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM CCR 特売22時締め
CALL E:\JOB\114\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

EXIT /B 0

:ERROR
>> %outhulft% echo %job% RC=1
EXIT /B 1



rem ========== 待機 ====================
:wait
>> %outhulft% echo %DATE% %TIME% 指定時刻(%targetTime%)まで待機します...

timeout /t 30 >nul
goto chekTime

