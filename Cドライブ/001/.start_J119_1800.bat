@echo off

rem jobNo
set job=119

rem ���O�t�@�C��
set outhulft=%~dp0logs\J%job%.log

rem ���O�t�H���_�쐬
if not exist %~dp0logs mkdir %~dp0logs

rem ���O�t�H���_�E���[�e�[�V����
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old

rem ========== �o�b�`�������s ==========
set calbat=E:\job\%job%
>> %outhulft% echo %DATE% %TIME%�@�����������J�n���܂�(%calbat%)1800
PUSHD %calbat%
call %calbat%\6.�����A�g18��.bat
IF ERRORLEVEL 1 GOTO ERROR

REM ����18��������
CALL E:\JOB\014\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM CCR ����18������
CALL E:\JOB\111\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

EXIT /B 0

:ERROR
>> %outhulft% echo %job% RC=1
EXIT /B 1
