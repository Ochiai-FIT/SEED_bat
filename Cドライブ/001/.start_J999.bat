@echo off

rem jobNo
set job=999

rem ���O�t�@�C��
set outhulft=%~dp0logs\J%job%.log

rem ���O�t�H���_�쐬
if not exist %~dp0logs mkdir %~dp0logs

rem ���O�t�H���_�E���[�e�[�V����
for %%F in (%outhulft%) do if %%~zF GEQ 10485760 move /Y %outhulft% %outhulft%.old

rem ========== �o�b�`�������s ==========
>> %outhulft% echo %DATE% %TIME%�@HULFT_ERROR�m�F
>> %outhulft% echo %job% RC=1
EXIT /B 1
