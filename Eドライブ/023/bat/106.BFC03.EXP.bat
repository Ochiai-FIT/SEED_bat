REM [106][BFC03]
@ECHO OFF

REM ログフォルダ作成
IF NOT EXIST %~DP0..\logs MKDIR %~DP0..\logs

REM コマンドフォルダ作成
IF NOT EXIST %~DP0..\cmd MKDIR %~DP0..\cmd

REM ログファイルの情報
SET OUTFILE=%~DP0../logs/setup.log
SET OUTTIME=%~DP0../logs/time.log

REM ベースフォルダ
SET BASEDIR=%~DP0..

REM 更新対象の情報
SET INFOSCRIPT=%~DP0..\cmd\%~N0.DB2

SET EXPFILENAME=%~DP0..\exp\0106
SET OUTFILENAME=0106
SET HULFTID=VFBUO020

REM ===== HULFT SEND DELETE ===============
SET HULFT=D:\HULFTFILES\SEND\%OUTFILENAME%
DEL /Q %HULFT%\*

SET MSG=%DATE% %TIME%  →  EXPORT処理(全特アンケート有商品)
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N <  %~dp0106.BFC03.EXP.sql  >%EXPFILENAME% 2>>%OUTFILE%
IF NOT %ERRORLEVEL%==0 GOTO ERROR


REM ===== HULFT SEND MOVE =================
ROBOCOPY %~dp0..\EXP %HULFT% %OUTFILENAME% /R:0 /NFL /NP >> %OUTFILE%

REM ===== HULFT SEND =======================
call %~dp0..\..\HULFT\.start_HULFT_SEND.bat %HULFTID% %OUTFILENAME%

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
