REM [006][UPDATE]
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


SET INFILENAME=
SET MSG=%DATE% %TIME% INAAD.SYSSHORIDT UPDATE処理(本部=0, 店舗=0）
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "UPDATE INAAD.SYSSHORIDT SET CTLFLG01 = 0, CTLFLG02 = 0, OPERATOR = '006', UPDDT = CURRENT_TIMESTAMP;  COMMIT;" >>%OUTFILE% 2>&1


:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
