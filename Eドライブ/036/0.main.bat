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

rem ===== 035 ���i�폜 ======================
set callbat=bat\035.DELETE.bat
>> %outfile% echo %callbat%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 036 �������t+1�X�V ================
set callbat=bat\036.UPDATE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 036 �������t+1�X�V �����o�b�`�p ===
set callbat=bat\036.SYSBATCHDT_TK.MERGE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 039 ���i�o�^���x�����Z�b�g ========
set callbat=bat\039.UPDATE.bat
>> %outfile% echo %callbat%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 037 ���i�\�񔽉f ==================
set callbat=bat\037.UPDATE.bat
>> %outfile% echo %callbat%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 038 ���i�\��폜 ==================
set callbat=bat\038.DELETE.bat
>> %outfile% echo %callbat%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ���Ŏg�p���Ȃ��v�j�̏ꍇ�A�P�̃o�b�`���ɋL��


:SUCCESS
echo %DATE% %TIME% ����������ɏI�����܂��� >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% �G���[���������܂���(RC=1) >> %outfile%
EXIT /B 1
