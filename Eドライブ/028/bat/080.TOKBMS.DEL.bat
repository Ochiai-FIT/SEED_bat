REM [080][TOKBMS]
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

SET MSG=%DATE% %TIME% INATK.TOKBMS �f���[�g�����i�X��B/M���M�󋵁j
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%

"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "DELETE FROM INATK.TOKBMS WHERE EXISTS (SELECT 1 FROM INAWK.A11TK21 TK21 WHERE TK21.DATAKBN = 1 AND INATK.TOKBMS.SMOYSCD = TK21.SMOYSCD); commit;" >>%OUTFILE% 2>&1
IF %ERRORLEVEL% GTR 1 GOTO ERROR
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv -e "ANALYZE TABLE INATK.TOKBMS;commit;" >>%OUTFILE% 2>&1
IF NOT %ERRORLEVEL%==0 GOTO ERROR

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
