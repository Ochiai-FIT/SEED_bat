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


rem INAIN.A11SIZE_01へ取り込み ======================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.A11SIZE_01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.A11SIZE_01 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

rem ファイルパスの設定
SET INFILENAME=0067
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME%  →  BFG01_PLU_01 LOAD処理
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAIN.A11SIZE_01 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1) SET DATA = @1; commit;" >>%OUTFILE% 2>&1
rem IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem INAIN.A11SIZE へU登録 =========================================================================

SET MSG=%DATE% %TIME% TRUNCATE INAIN.A11SIZE
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e  "TRUNCATE TABLE INAIN.A11SIZE ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

SET INFILENAME=0067
SET MSG=%DATE% %TIME% %INFILENAME% → INAIN.A11SIZE LOAD処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "INSERT IGNORE INTO INAIN.A11SIZE SELECT MID(DATA, 1, 14) AS SHOHINCD, MID(DATA, 15, 4) AS SHOHIN_SIZE_W, MID(DATA, 19, 3) AS SHOHIN_SIZE_H, MID(DATA, 23, 4) AS SHOHIN_SIZE_D FROM INAIN.A11SIZE_01;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


SET MSG=%DATE% %TIME% INAAD.A11SIZE DELETE処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "DELETE FROM INAAD.A11SIZE T1 WHERE EXISTS (SELECT 1 FROM INAIN.A11SIZE T2 WHERE T2.SHOHINCD=T1.SHOHINCD);commit;">>%OUTFILE% 2>&1


SET MSG=%DATE% %TIME% INAIN.A11SIZE → INAAD.A11SIZE LOAD処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
REM 商品サイズメンテデータ
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "INSERT IGNORE INTO INAAD.A11SIZE (SELECT SHOHINCD,SHOHIN_SIZE_W,SHOHIN_SIZE_H,SHOHIN_SIZE_D FROM INAIN.A11SIZE);commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
