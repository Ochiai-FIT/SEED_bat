REM [074][AASTF]
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

rem AASTFへ取り込み ======================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.AASTF_01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.AASTF_01; commit;" >>%OUTFILE% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

rem ファイルパスの設定
SET INFILENAME=0074
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME%  →  BFG01_PLU_01 LOAD処理
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAIN.AASTF_01 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1) SET DATA = @1; commit;" >>%OUTFILE% 2>&1
rem IF ERRORLEVEL 1 GOTO ERROR


rem AASTFへU登録 =========================================================================


SET MSG=%DATE% %TIME% TRUNCATE INAIN.AASTF
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.AASTF ;commit;" >>%OUTFILE% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

SET MSG=%DATE% %TIME%  →  LOAD処理(削除可ファイル)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "INSERT IGNORE INTO INAIN.AASTF SELECT MID(DATA, 1, 13) AS SHOCD, MID(DATA, 14, 3) AS BUNBMC, MID(DATA, 17, 3) AS BUNDIC, MID(DATA, 19, 2) AS BUNCHC, MID(DATA, 21, 2) AS BUNSHC, MID(DATA, 23, 1) AS BUNSSC, MID(DATA, 24, 10) AS SHOMKN, MID(DATA, 44, 6) AS HSIREC, MID(DATA, 50, 1) AS SYOKBN, MID(DATA, 51, 5) AS GENKA1, MID(DATA, 66, 4) AS BAITE1, MID(DATA, 60, 4) AS BAIFU1, MID(DATA, 64, 1) AS TASIRF, MID(DATA, 65, 1) AS TEFTEI, MID(DATA, 66, 5) AS TOURKB, MID(DATA, 71, 5) AS HENKOB, MID(DATA, 76, 1) AS IRYOTMFL, MID(DATA, 77, 24) AS FILLER FROM INAIN.AASTF_01;commit;" >>%OUTFILE% 2>&1
IF ERRORLEVEL 1 GOTO ERROR
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INAIN.AASTF;commit;" >>%OUTFILE% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
