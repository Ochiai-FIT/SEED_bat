@echo off

rem jobNo
set job=119

rem ���O�t�@�C��
set outhulft=%~dp0logs\J%job%.log

rem ���O�t�H���_�쐬
if not exist %~dp0logs mkdir %~dp0logs

rem ���O�t�H���_�E���[�e�[�V����
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old

REM REBOOT����t�@�C��
SET FILENAME=E:\JOB\REBOOT\processing
TYPE NUL > %FILENAME%

rem ========== �o�b�`�������s ==========
set calbat=E:\job\%job%
>> %outhulft% echo %DATE% %TIME%�@�����������J�n���܂�(%calbat%)2300
PUSHD %calbat%


REM ����3��(�{��)�p��
CALL E:\JOB\033\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM CCR ����23������
CALL E:\JOB\115\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM �������t�J�E���g�A�b�v
CALL E:\JOB\036\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM �㏈���i�Â��������[�h�`�j
CALL E:\JOB\050\._run.bat
IF ERRORLEVEL 1 GOTO ERROR

REM REBOOT����t�@�C���폜
DEL %FILENAME%

EXIT /B 0

:ERROR
>> %outhulft% echo %job% RC=1
EXIT /B 1
