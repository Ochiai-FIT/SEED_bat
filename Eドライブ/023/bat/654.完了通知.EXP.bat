REM [654][�����ʒm]
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

SET OUTFILENAME=0654
SET EXPFILE=%~DP0../exp/%OUTFILENAME%
SET HULFTID=VFAUO002

REM ===== HULFT SEND DELETE ===============
SET HULFT=D:\HULFTFILES\SEND\%OUTFILENAME%
DEL /Q %HULFT%\*

SET MSG=%DATE% %TIME%  ��  EXPORT����(�����ʒm 19���ߒ�ʓ����t�@�C��)����t�@�C��
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N -e "SELECT * FROM (SELECT 1 AS DUMMY)DUMMY WHERE 1 = 2" >%EXPFILE% 2>>%OUTFILE%
IF NOT %ERRORLEVEL%==0 GOTO ERROR

REM ===== HULFT SEND MOVE =================
ROBOCOPY %~dp0..\EXP %HULFT% %OUTFILENAME% /R:0 /NFL /NP >> %OUTFILE%

REM ===== HULFT SEND =======================
call %~dp0..\..\HULFT\.start_HULFT_SEND.bat %HULFTID% %OUTFILENAME%

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
