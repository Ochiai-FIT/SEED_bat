REM [][]
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
SET INFOSCRIPT=%~DP0..\cmd\%~N0.txt

REM ����



SET MSG=%DATE% %TIME% �v���Z�X�L������
ECHO %MSG%
>> %OUTFILE% ECHO %MSG%


REM �R�}���h
DEL /Q %INFOSCRIPT%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N -e "SELECT 'CALL mysql.rds_kill(' || T1.ID || ');' FROM information_schema.PROCESSLIST T1 WHERE USER IN ('mysqladmin') ORDER BY ID;" >%INFOSCRIPT%
IF NOT %ERRORLEVEL%==0 GOTO ERROR

REM �ؒf
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --force --show-warnings -vv < %INFOSCRIPT% >>%OUTFILE% 2>&1


:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
