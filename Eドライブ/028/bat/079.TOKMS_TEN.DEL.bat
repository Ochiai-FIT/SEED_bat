REM [079][TOKMS_TEN]
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

SET MSG=%DATE% %TIME% INATK.TOKMS_TEN �f���[�g�����i�X�ʍÂ����M��_�X�܁j
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%

"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "DELETE FROM INATK.TOKMS_TEN WHERE EXISTS (SELECT 1 FROM INAWK.A11TK15 TK15 WHERE TK15.DATAKBN = 1 AND INATK.TOKMS_TEN.SMOYSCD = TK15.SMOYSCD);commit;" >>%OUTFILE% 2>&1
IF %ERRORLEVEL% GTR 1 GOTO ERROR
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INATK.TOKMS_TEN;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
