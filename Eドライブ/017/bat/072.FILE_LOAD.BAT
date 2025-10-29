REM [003][FILE_LOAD]
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
rem AFE03へ取り込み ======================================================================
SET MSG=%DATE% %TIME% TRUNCATE AFE03_01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.AFE03_01 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

rem ファイルパスの設定
SET INFILENAME=0072
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME%  →  AFE03_01 LOAD処理
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAIN.AFE03_01 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1) SET DATA = @1; commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem BFG01_PLへU登録 =========================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.AFE03
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.AFE03 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

SET MSG=%DATE% %TIME% %INFILENAME% → INAIN.AFE03 LOAD処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "INSERT IGNORE INTO INAIN.AFE03 SELECT MID(DATA, 1, 3) AS SYOZKCD, MID(DATA, 4, CHAR_LENGTH(SUBSTRING(DATA, 4)) - 50) AS SYOZKMKJ, RIGHT (DATA, 50) AS SYOZKMKN FROM INAIN.AFE03_01;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

SET MSG=%DATE% %TIME% INAIN.AFE03 → INAAD.SYSSZK LOAD処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
REM 所属マスタの全件差替
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e  "TRUNCATE TABLE INAAD.SYSSZK; INSERT ignore INTO INAAD.SYSSZK SELECT LPAD(SYOZKCD, 3, 0),SYOZKMKJ,SYOZKMKN,'batch',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP FROM INAIN.AFE03;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
