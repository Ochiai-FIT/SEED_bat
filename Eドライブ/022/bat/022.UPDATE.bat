REM [015][UPDATE]
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


SET INFILENAME=
SET MSG=%DATE% %TIME% ���i INAMS.MSTSHN UPDATE�����i���M�t���O=1 & �v���C�X�J�[�h���s�t���O=1�j
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "UPDATE INAMS.MSTSHN SET PCARD_OPFLG = 0 WHERE PCARD_OPFLG=1 AND SENDFLG=1; COMMIT;" >>%OUTFILE% 2>&1

SET MSG=%DATE% %TIME% ���i�X�O���[�v INAMS.MSTSHNTENGP UPDATE�����i���M�t���O=1 & �v���C�X�J�[�h���s�t���O=1�j
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "UPDATE INAMS.MSTSHNTENGP SET PCARD_OPFLG = 0 WHERE PCARD_OPFLG=1 AND SENDFLG=1; COMMIT;" >>%OUTFILE% 2>&1

SET MSG=%DATE% %TIME% ���i�Q�\�� INAMS.MSTSHN_Y UPDATE�����i���M�t���O=1 & �v���C�X�J�[�h���s�t���O=1�j
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "UPDATE INAMS.MSTSHN_Y SET PCARD_OPFLG = 0 WHERE PCARD_OPFLG=1 AND SENDFLG=1; COMMIT;" >>%OUTFILE% 2>&1


rem IF NOT %ERRORLEVEL%==0 GOTO ERROR


:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
