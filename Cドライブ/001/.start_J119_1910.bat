@echo off

rem jobNo
set job=119

rem ���O�t�@�C��
set outhulft=%~dp0logs\J%job%.log

rem ���O�t�H���_�쐬
if not exist %~dp0logs mkdir %~dp0logs

rem ���O�t�H���_�E���[�e�[�V����
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old


rem ========== �^�[�Q�b�g���Ԃ��w��=======
rem HHMISS�`���i���Ԃ̐擪��0��t���Ȃ��j
rem set targetTime=193000
set targetTime=190500

:chekTime
rem ========== ���t�擾 =================
rem ���Ԃ��擾(HHMIDD)�擾
set nowTime=%time:~0,2%%time:~3,2%%time:~6,2%
echo %nowTime% %targetTime%

if %nowTime% LSS %targetTime% goto wait


rem ========== �o�b�`�������s ==========
set calbat=E:\job\%job%
>> %outhulft% echo %DATE% %TIME%�@�����������J�n���܂�(%calbat%)1910
PUSHD %calbat%
call %calbat%\7.�����A�g19��.bat
IF ERRORLEVEL 1 GOTO ERROR

REM ����2��(�{��)
CALL E:\JOB\023\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM CCR ����19������
CALL E:\JOB\112\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM CCR �}�X�^21������
CALL E:\JOB\113\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

EXIT /B 0

:ERROR
>> %outhulft% echo %job% RC=1
EXIT /B 1


rem ========== �ҋ@ ====================
:wait
>> %outhulft% echo %DATE% %TIME% �w�莞��(%targetTime%)�܂őҋ@���܂�...

timeout /t 30 >nul
goto chekTime

