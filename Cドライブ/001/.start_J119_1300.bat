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
>> %outhulft% echo %DATE% %TIME%�@�����������J�n���܂�(%calbat%)1300
PUSHD %calbat%
call %calbat%\2.�����A�g13���}�X�^.bat
IF ERRORLEVEL 1 GOTO ERROR

REM �}�X�^13�����Ԓ���
CALL E:\JOB\011\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

EXIT /B 0

:ERROR
>> %outhulft% echo %job% RC=1
EXIT /B 1
