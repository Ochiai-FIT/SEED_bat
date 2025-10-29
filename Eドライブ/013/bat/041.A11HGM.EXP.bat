REM [041][A11HGM]
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

SET OUTFILENAME=0041
SET EXPFILE=%~DP0../exp/%OUTFILENAME%
SET HULFTID=VECUO009

REM ===== HULFT SEND DELETE ===============
SET HULFT=D:\HULFTFILES\SEND\%OUTFILENAME%
DEL /Q %HULFT%\*

SET MSG=%DATE% %TIME%  ��  EXPORT����(�z���O���[�v)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N -e "SELECT LPAD(HG.HSGPCD, 4, 0) || RPAD(HG.HSGPAN, 20, ' ') || RPAD(HG.HSGPKN, 20, '�@') || LPAD(HG.AREAKBN, 1, 0) || '       ' || LPAD(HG.UPDKBN, 1, 0) || LPAD(HG.SENDFLG, 1, 0) || RPAD(HG.OPERATOR, 20, ' ') || LPAD(DATE_FORMAT(HG.ADDDT, '%%Y%%m%%d'), 8, 0) || LPAD(DATE_FORMAT(HG.UPDDT, '%%Y%%m%%d'), 8, 0) FROM INAMS2K.MSTHSGP HG WHERE HG.UPDKBN <> 1 ORDER BY HG.HSGPCD"  >%EXPFILE% 2>>%OUTFILE%
IF NOT %ERRORLEVEL%==0 GOTO ERROR

REM ===== HULFT SEND MOVE =================
ROBOCOPY %~dp0..\EXP %HULFT% %OUTFILENAME% /R:0 /NFL /NP >> %OUTFILE%

REM ===== HULFT SEND =======================
call %~dp0..\..\HULFT\.start_HULFT_SEND.bat %HULFTID% %OUTFILENAME%

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
