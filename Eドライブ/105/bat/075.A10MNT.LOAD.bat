REM [075][A10MNT]
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

rem A10MNT_01�֎�荞�� ======================================================================
SET MSG=%DATE% %TIME% TRUNCATE INAIN.A10MNT_01
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "TRUNCATE TABLE INAIN.A10MNT_01 ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

rem �t�@�C���p�X�̐ݒ�
SET INFILENAME=0075
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

SET MSG=%DATE% %TIME%  ��  A10MNT_01 LOAD����
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "load data local infile '%filename_tmp%' IGNORE into table INAIN.A10MNT_01 character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1) SET DATA = @1; commit;" >>%OUTFILE% 2>&1
rem IF NOT %ERRORLEVEL%==0 GOTO ERROR


rem A10MNT��U�o�^ =========================================================================

SET MSG=%DATE% %TIME% TRUNCATE INAIN.A10MNT
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e  "TRUNCATE TABLE INAIN.A10MNT ;commit;">>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

SET INFILENAME=0075
SET MSG=%DATE% %TIME%  ��  LOAD����(���i�}�X�^�ꊇ�ύX�f�[�^)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e  "INSERT IGNORE INTO INAIN.A10MNT SELECT MID(DATA, 1, 14) AS SHCD, MID(DATA, 15, 6) SIIREOLD, MID(DATA, 21, 6) SIIRENEW, MID(DATA, 27, 9) YBUNOLD, MID(DATA, 36, 9) YBUNNEW, MID(DATA, 45, 9) URBUNOLD, MID(DATA, 54, 9) URBUNNEW, MID(DATA, 63, 9) HBUNODCS, MID(DATA, 72, 1) HBUNOSS, MID(DATA, 73, 9) HBUNNDCS, MID(DATA, 82, 1) HBUNNSS, MID(DATA, 83, 3) HAIOLD, MID(DATA, 86, 3) HAINEW, MID(DATA, 89, 1) ERSHCD, MID(DATA, 90, 1) ERSIRCD, MID(DATA, 91, 1) ERYBUN, MID(DATA, 92, 1) ERURBUN, MID(DATA, 93, 1) ERHBUN, MID(DATA, 94, 1) ERHAP, MID(DATA, 95, 8) SAKUSEI, MID(DATA, 103, 8) FILLER FROM INAIN.A10MNT_01;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INAIN.A10MNT;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
