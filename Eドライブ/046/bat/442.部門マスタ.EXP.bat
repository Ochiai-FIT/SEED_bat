REM [442][����}�X�^]
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


SET MSG=%DATE% %TIME%  ��  EXPORT����(�X�}�N��_����}�X�^)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%

SET OUTFILENAME=%~DP0..\exp\����}�X�^.csv
ECHO %OUTFILENAME% >> %OUTFILE%

REM ���M�t���O<>1�̂�
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N -e "SELECT LPAD(T1.BMNCD, 3, 0) || '       ' || CONVERT(LEFT (CAST(CONVERT(RPAD(TRIM(TRAILING '�@' FROM COALESCE(T1.BMNKN, '')), 20, ' ') USING SJIS) AS BINARY), 20) USING SJIS) || RPAD(COALESCE(T1.BMNAN, ''), 10, ' ') || LPAD(COALESCE(T1.UPDKBN, 0), 1, 0) || RPAD('', 23, ' ') FROM INAMS.MSTBMN T1 WHERE T1.SENDFLG <> 0 ORDER BY T1.BMNCD;" >%OUTFILENAME% 2>>%OUTFILE%
IF NOT %ERRORLEVEL%==0 GOTO ERROR


:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
