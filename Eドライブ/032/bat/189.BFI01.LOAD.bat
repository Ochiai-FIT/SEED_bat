REM [189][BFI01]
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

rem INAIN.BFI01テーブルクリア
SET MSG=%DATE% %TIME% TRUNCATE INAIN.BFI01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.BFI01 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem BFI01_01へ取り込み ======================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.BFI01_01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.BFI01_01 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

rem ファイルパスの設定
SET INFILENAME=0189
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME%  →  INAIN.BFI01_01 LOAD処理
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAIN.BFI01_01 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1) SET DATA = @1; commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem BFI01へU登録 =========================================================================

SET MSG=%DATE% %TIME%  →  LOAD処理(事前発注)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e"INSERT IGNORE INTO INAIN.BFI01 SELECT MID(DATA, 1, 6) AS LISTNO, MID(DATA, 7, 10) AS TITLE, MID(DATA, 17, 8) AS HAKAIS, MID(DATA, 25, 8) AS HASYUR, MID(DATA, 33, 8) AS KESKAB, MID(DATA, 41, 8) AS KESSYUB, MID(DATA, 49, 8) AS SOUSIME, MID(DATA, 57, 20) AS OPERTO, MID(DATA, 77, 8) AS TOURKB, MID(DATA, 85, 8) AS KOSINB FROM INAIN.BFI01_01;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INAIN.BFI01 ;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
