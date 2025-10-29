REM [195][BFB11]
@ECHO OFF

REM ���O�t�H���_�쐬
IF NOT EXIST %~DP0..\logs MKDIR %~DP0..\logs

REM �R�}���h�t�H���_�쐬
IF NOT EXIST %~DP0..\cmd MKDIR %~DP0..\cmd

REM ���O�t�@�C���̏��
SET OUTFILE=%~DP0../logs/setup.log
SET OUTTIME=%~DP0../logs/time.log

REM �x�[�X�t�H���_
SET BASEDIR=%~DP0..

REM �X�V�Ώۂ̏��
SET INFOSCRIPT=%~DP0..\cmd\%~N0.DB2

SET MSG=%DATE% %TIME% TRUNCATE INAIN.BFB11
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.BFB11 ;COMMIT;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem INAIN.BFB11_01�֎�荞�� ======================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.BFB11_01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.BFB11_01 ;COMMIT;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

rem �t�@�C���p�X�̐ݒ�
SET INFILENAME=0195
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME%  ��  INAIN.BFB11_01 LOAD����
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAIN.BFB11_01 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1) SET DATA = @1; commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

rem INAIN.BFB11��U�o�^ =========================================================================


SET MSG=%DATE% %TIME%  ��  LOAD����(���O�����Ϗ��)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "INSERT IGNORE INTO INAIN.BFB11 SELECT MID(DATA, 1, 3) AS MISECD, MID(DATA, 4, 8) AS SHOHNC, MID(DATA, 12, 6) AS FILLER01, MID(DATA, 18, 1) AS BINK, MID(DATA, 19, 8) AS NNYNOB, MID(DATA, 27, 3) AS BUNBMC, MID(DATA, 30, 1) AS MOYOK, MID(DATA, 31, 6) AS MOYOKA, MID(DATA, 37, 3) AS MOYORE, MID(DATA, 40, 4) AS KANBAN, MID(DATA, 44, 9) AS FILLER02, MID(DATA, 53, 8) AS SAKSEIB FROM INAIN.BFB11_01;commit" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INAIN.BFB11;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
