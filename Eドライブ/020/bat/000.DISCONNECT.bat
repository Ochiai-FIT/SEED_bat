REM [][]
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
SET INFOSCRIPT=%~DP0..\cmd\%~N0.txt

REM 引数



SET MSG=%DATE% %TIME% プロセスキル処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%


REM コマンド
DEL /Q %INFOSCRIPT%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N -e "SELECT 'CALL mysql.rds_kill(' || T1.ID || ');' FROM information_schema.PROCESSLIST T1 WHERE USER IN ('mysqladmin') ORDER BY ID;" >%INFOSCRIPT%
IF NOT %ERRORLEVEL%==0 GOTO ERROR

REM 切断
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --force --show-warnings -vv < %INFOSCRIPT% >>%OUTFILE% 2>&1


:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
