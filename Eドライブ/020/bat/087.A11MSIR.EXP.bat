REM [087][A11MSIR]
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

SET OUTFILENAME=0087
SET EXPFILE=%~DP0../exp/%OUTFILENAME%
SET HULFTID=VEGUO009

REM ===== HULFT SEND DELETE ===============
SET HULFT=D:\HULFTFILES\SEND\%OUTFILENAME%
DEL /Q %HULFT%\*

SET MSG=%DATE% %TIME%  ��  EXPORT����(�����p�z���p�^�[���d����X�܁i�X�f�j)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N -e "SELECT LPAD(SHIRECD, 6, 0) || LPAD(TENCD, 3, 0) || LPAD(SHIRECD_J, 6, 0) || LPAD(INPUTNO, 2, 0) || RPAD(FILLER, 5, ' ') || LPAD(UPDKBN, 1, 0) || LPAD(SEND_FLG, 1, 0) || RPAD(OPERATOR, 20, ' ') || LPAD(ADD_YMD, 8, 0) || LPAD(UPD_YMD, 8, 0) FROM INAIF.HA_A11MSIR ORDER BY SHIRECD, TENCD;" >%EXPFILE% 2>>%OUTFILE%
IF NOT %ERRORLEVEL%==0 GOTO ERROR

REM ===== HULFT SEND MOVE =================
ROBOCOPY %~dp0..\EXP %HULFT% %OUTFILENAME% /R:0 /NFL /NP >> %OUTFILE%

REM ===== HULFT SEND =======================
call %~dp0..\..\HULFT\.start_HULFT_SEND.bat %HULFTID% %OUTFILENAME%

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
