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
rem AFE02_01へ取り込み ======================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.AFE02_01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.AFE02_01 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

rem ファイルパスの設定
SET INFILENAME=0071
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME%  →  INAIN.AFE02_01 LOAD処理
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAIN.AFE02_01 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1) SET DATA = @1; commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem AFE02へU登録 =========================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.AFE02
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.AFE02 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

SET INFILENAME=0071
SET MSG=%DATE% %TIME% %INFILENAME% → INAIN.AFE02 LOAD処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "INSERT IGNORE INTO INAIN.AFE02 SELECT MID(DATA, 1, 7) AS SYAINCD, MID(DATA, 8, CHAR_LENGTH(SUBSTRING(DATA, 8)) - 38), MID(RIGHT (DATA, 38), 1, 30), MID(RIGHT (DATA, 38), 31, 3), MID(RIGHT (DATA, 38), 34, 3), MID(RIGHT (DATA, 38), 37, 2) FROM INAIN.AFE02_01;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

SET MSG=%DATE% %TIME% INAIN.AFE02 → INAAD.SYSJINJIKIHON LOAD処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
REM 社員マスタの全件差替
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAAD.SYSJINJIKIHON;INSERT ignore INTO INAAD.SYSJINJIKIHON SELECT SYAINCD,SYAINMKJ,SYAINMKN,LPAD(SYOZKCD, 3, '0'),SYOKSCD,SYOKMCD,'batch',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP FROM INAIN.AFE02;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
