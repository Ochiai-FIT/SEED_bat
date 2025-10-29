@echo off
cls

rem �����l()
set event_output=0

rem �ڑ����擾
set curpath=%~dp0..\
call %curpath%._init.bat

rem �t�H���_���擾
set folderpath=%~dp0
set folderpath=%folderpath:~0,-1%
for /F "delims=" %%a in ('echo "%folderpath%"') do set foldername=%%~nxa

rem I/F ���X�g
set readlist=%~dp0list_load.txt
rem I/F �i�[��t���p�X
set input=%~dp0data
rem I/F �m�F�p�o�b�`�t�@�C��
set checkfile=%~dp0checkfile.bat

rem I/F �o�b�N�A�b�v�p����(YYYYMMDDHHMM)�擾
set ltime=%date:~-10,4%%date:~-5,2%%date:~-2%%time:~0,2%%time:~3,2%
set ltime=%ltime: =0%

rem ���t�擾
set days=%date:~8,2%

rem ���O�t�@�C��
set outfile=%~dp0logs\setup.log
set outtime=%~dp0logs\time.log
set findfile=%~dp0logs\setup.find.log

rem ���O�t�H���_�쐬
if not exist %~dp0logs mkdir %~dp0logs

rem �f�[�^�t�H���_�쐬
if not exist %input% mkdir %input%

rem �G�N�X�|�[�g�t�H���_�쐬
if not exist %~dp0exp mkdir %~dp0exp


rem ���O�t�H���_�E���[�e�[�V����
for %%F in (%outfile%) do if %%~zF GEQ 10485760 move /Y %outfile% %outfile%.old
for %%F in (%outtime%) do if %%~zF GEQ 10485760 move /Y %outtime% %outtime%.old

echo %DATE% %TIME% ��������(xx.Load_data)�̊J�n >> %outfile%


rem ================ <�v���Z�X�ؒf> ==============
rem SET callbat=bat\000.DISCONNECT.bat
rem >> %outfile% ECHO %callbat%
rem CALL %~dp0%callbat%
rem IF "%ERRORLEVEL%" EQU "1" GOTO ERROR

rem =====================================
rem 445 �V�X�����X����
rem =====================================
rem �V�X�����X����
set callbat=bat\445.THWK01_A10TSKD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\445.�V�X�����X����.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 446 �\�񔭒�
rem =====================================
rem �\�񔭒��f�[�^���[�N(���N)
set callbat=bat\446.D2WK50_A10TTD_S.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �\�񔭒��f�[�^���[�N(�h���C)
set callbat=bat\446.D2WK51_A10TTD_D.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\446.�\�񔭒�.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


REM ���s�R�[�h����
CALL %~dp0..\CNV\awk.bat %~dp0exp

REM �t�@�C�����ύX
copy %~dp0exp\0446.csv.cnv %~dp0exp\0446 /Y
copy %~dp0exp\0445.csv.cnv %~dp0exp\0445 /Y

REM ===== HULFT SEND DELETE ===============
DEL /Q D:\HULFTFILES\SEND\0446\*
DEL /Q D:\HULFTFILES\SEND\0445\*

REM ===== HULFT SEND MOVE =================
ROBOCOPY %~dp0EXP D:\HULFTFILES\SEND\0446 0446 /R:0 /NFL /NP >> %OUTFILE%
ROBOCOPY %~dp0EXP D:\HULFTFILES\SEND\0445 0445 /R:0 /NFL /NP >> %OUTFILE%

REM ===== HULFT SEND =======================
call %~dp0..\HULFT\.start_HULFT_SEND.bat MDMUR030 0446
call %~dp0..\HULFT\.start_HULFT_SEND.bat MDMUR031 0445


REM ===== BACKUP COPY ====================
setlocal
set x=%~dp0
set x=%x:~0,-1%
for /F "delims=" %%a in ('echo "%x%"') do set DIRNAME=%%~na
ROBOCOPY %~dp0EXP E:\MDM\%DIRNAME%\%ltime% /R:0 /E /NFL /NP /XD backup bkup RcvTemp >> %outfile%
endlocal


:SUCCESS
echo %DATE% %TIME% ��������(Daily)������ɏI�����܂��� >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% �G���[���������܂���(RC=1) >> %outfile%
EXIT /B 1
