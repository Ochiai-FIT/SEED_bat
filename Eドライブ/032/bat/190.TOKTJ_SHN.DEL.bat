REM [190][TOKTJ_SHN]
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

SET MSG=%DATE% %TIME%  →  DELETE処理(事前発注＿商品)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e  "DELETE FROM INATK.TOKTJ_SHN SHN WHERE EXISTS (SELECT 1 FROM INAIN.BFI02 T1 WHERE SHN.LSTNO = T1.LISTNO AND SHN.BMNCD = T1.BUNBMC); commit;" >>%OUTFILE% 2>&1
IF %ERRORLEVEL% GTR 1 GOTO ERROR
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INATK.TOKTJ_SHN;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
