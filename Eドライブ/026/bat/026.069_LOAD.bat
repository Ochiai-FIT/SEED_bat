REM [026][069_LOAD]
@ECHO OFF

REM ���O�t�H���_�쐬
IF NOT EXIST %~DP0..\logs MKDIR %~DP0..\logs

REM �R�}���h�t�H���_�쐬
IF NOT EXIST %~DP0..\cmd MKDIR %~DP0..\cmd

REM ���O�t�@�C���̏��
SET OUTFILE=%~DP0../logs/setup.log
SET OUTTIME=%~DP0../logs/time.log

rem �X�V�Ώۂ̏��
set INFOSCRIPT=%~DP0cmd\%~N0.sql
set INFOSCRIPT=%INFOSCRIPT:\=\\%

REM �x�[�X�t�H���_
SET BASEDIR=%~DP0..

REM �X�V�Ώۂ̏��
SET INFOSCRIPT=%~DP0..\cmd\%~N0.DB2

SET MOTOFILENAME=0069

SET INFILENAME=J069.txt
SET MSG=%DATE% %TIME% %INFILENAME% �� INAMS.MSTKSPAGE LOAD����
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
REM ���݊m�F
IF NOT EXIST DATA\%INFILENAME% GOTO ERROR
IF NOT EXIST DATA\%MOTOFILENAME% GOTO ERROR


rem �t�@�C���p�X�̐ݒ�
set filename=DATA\%INFILENAME%
set filename_tmp=%filename:\=\\%

rem INAMS.MSTKSPAGE �e�[�u���փ��[�h����
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "TRUNCATE TABLE INAMS.MSTKSPAGE; load data local infile '%filename_tmp%' IGNORE into table INAMS.MSTKSPAGE character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1, @2, @3, @4, @5, @6, @7, @8, @9, @10) SET TENCD = NULLIF(@1, ''), BMNCD = NULLIF(@2, ''), BRUICD = NULLIF(@3, ''), PTN = NULLIF(@4, ''), EDABAN = NULLIF(@5, ''), LINENO = NULLIF(@6, ''), SHNCD = NULLIF(@7, ''), OPERATOR = NULLIF(@8, ''), ADDDT = NULLIF(@9, ''), UPDDT = NULLIF(@10, ''); commit;" >>%OUTFILE% 2>&1
IF ERRORLEVEL 1 GOTO ERROR


SET MSG=%DATE% %TIME% %INFILENAME% �� INAMS2.MSTKSPAGE LOAD����
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --local_infile=1 --show-warnings -vv -e "TRUNCATE TABLE INAMS2.MSTKSPAGE; load data local infile '%filename_tmp%' IGNORE into table INAMS2.MSTKSPAGE character set cp932 fields terminated by ',' ESCAPED BY '' lines terminated by '\r\n' (@1, @2, @3, @4, @5, @6, @7, @8, @9, @10) SET TENCD = NULLIF(@1, ''), BMNCD = NULLIF(@2, ''), BRUICD = NULLIF(@3, ''), PTN = NULLIF(@4, ''), EDABAN = NULLIF(@5, ''), LINENO = NULLIF(@6, ''), SHNCD = NULLIF(@7, ''), OPERATOR = NULLIF(@8, ''), ADDDT = NULLIF(@9, ''), UPDDT = NULLIF(@10, ''); commit;" >>%OUTFILE% 2>&1
IF ERRORLEVEL 1 GOTO ERROR


:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
