REM [190][BFI02]
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


rem INAIN.BFI02テーブルクリア
SET MSG=%DATE% %TIME% TRUNCATE INAIN.BFI02
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e  "TRUNCATE TABLE INAIN.BFI02 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem BFI02_01へ取り込み ======================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.BFI02_01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.BFI02_01 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

rem ファイルパスの設定
SET INFILENAME=0190
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME%  →  BFI02_01 LOAD処理
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAIN.BFI02_01 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1) SET DATA = @1; commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem BFI02へU登録 =========================================================================

SET MSG=%DATE% %TIME%  →  LOAD処理(事前発注＿商品)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e  "INSERT IGNORE INTO INAIN.BFI02 SELECT MID(DATA, 1, 6) AS LISTNO, MID(DATA, 7, 3) AS BUNBMC, MID(DATA, 10, 8) AS SORTNO, MID(DATA, 18, 14) AS SHOCD, MID(DATA, 32, 1) AS BINK, MID(DATA, 33, 2) AS BINKMKJ, MID(DATA, 35, 20) AS SANTIMKJ, MID(DATA, 55, 20) AS SHOMKJ, MID(DATA, 75, 3) AS ODS, MID(DATA, 78, 3) AS TANIMKJK, MID(DATA, 81, 1) AS NOUKE, MID(DATA, 82, 4) AS JYURYO, MID(DATA, 86, 30) AS TOKCOME, MID(DATA, 116, 6) AS HEKINJI, MID(DATA, 122, 20) AS OPERTO, MID(DATA, 142, 8) AS TOURKB, MID(DATA, 150, 8) AS KOSINB FROM INAIN.BFI02_01;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INAIN.BFI02;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
