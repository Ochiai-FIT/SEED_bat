REM [182][D2WK28_ZZQ113_3]
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

SET INFILENAME=D2WK28_ZZQ113_3.csv
SET DATAFILE=%~DP0../data/%INFILENAME%
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME% INAWK.D2WK28_ZZQ113_3(生活応援_商品3) テーブルクリア処理
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAWK.D2WK28_ZZQ113_3 ;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

SET MSG=%DATE% %TIME% INAWK.D2WK28_ZZQ113_3(生活応援_商品3) データファイル作成
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N < %~dp0182.D2WK28_ZZQ113_3.LOAD.sql >%DATAFILE% 2>>%OUTFILE%
IF NOT %ERRORLEVEL%==0 GOTO ERROR

SET MSG=%DATE% %TIME% INAWK.D2WK28_ZZQ113_3(生活応援_商品3) ロード処理（ワークテーブル作成）
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAWK.D2WK28_ZZQ113_3 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @24, @25, @26, @27, @28, @29, @30, @31) SET REC_HAN_KBN = NULLIF(@1, '<NULL>'), MISE = NULLIF(@2, '<NULL>'), MOYOK = NULLIF(@3, '<NULL>'), MOYOKA = NULLIF(@4, '<NULL>'), MOYORE = NULLIF(@5, '<NULL>'), BUNBMC = NULLIF(@6, '<NULL>'), KANBAN = NULLIF(@7, '<NULL>'), SHOCD = NULLIF(@8, '<NULL>'), MAKRNMKJ = NULLIF(@9, '<NULL>'), SHOMKJ = NULLIF(@10, '<NULL>'), KIKMKJ = NULLIF(@11, '<NULL>'), MISIR = NULLIF(@12, '<NULL>'), SAITEISU = NULLIF(@13, '<NULL>'), GENKA = NULLIF(@14, '<NULL>'), A_SOBAIFG = NULLIF(@15, '<NULL>'), B_SOBAIFG = NULLIF(@16, '<NULL>'), C_SOBAIFG = NULLIF(@17, '<NULL>'), A_RANK = NULLIF(@18, '<NULL>'), B_RANK = NULLIF(@19, '<NULL>'), C_RANK = NULLIF(@20, '<NULL>'), POPCD = NULLIF(@21, '<NULL>'), POPSIZE = NULLIF(@22, '<NULL>'), POPSU = NULLIF(@23, '<NULL>'), MSF = NULLIF(@24, '<NULL>'), KOSINKB = NULLIF(@25, '<NULL>'), SOSINFLG = NULLIF(@26, '<NULL>'), OPERTO = NULLIF(@27, '<NULL>'), TOURKB = NULLIF(@28, '<NULL>'), KOSINB = NULLIF(@29, '<NULL>'), HACHBI = NULLIF(@30, '<NULL>'), NNYNOB = NULLIF(@31, '<NULL>');commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INAWK.D2WK28_ZZQ113_3;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
