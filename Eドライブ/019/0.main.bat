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
rem 000 �e�\��}�X�^���甽�f�ς��폜
rem =====================================
set callbat=bat\000.YOYAKU.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �������t�X�V
rem =====================================
set callbat=bat\000.SYSBATCHDT.MERGE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���i�}�X�^�X�V�L�[���[�h����
rem =====================================
set callbat=bat\000.MSTSHN_UPDKEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �d����}�X�^�X�V�L�[���[�h����
rem =====================================
set callbat=bat\000.MSTSIR_UPDKEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �X�܊�{�}�X�^�X�V�L�[���[�h����
rem =====================================
set callbat=bat\000.MSTTEN_UPDKEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 463 �W���[�i��_���i�}�X�^
rem =====================================
set callbat=bat\463.A11SHOJ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 464 �W���[�i��_�d���O���[�v���i�}�X�^
rem =====================================
set callbat=bat\464.A11TGSHJ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 465 �W���[�i��_�����R���g���[���}�X�^
rem =====================================
set callbat=bat\465.A11BCMJ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 466 �W���[�i��_�\�[�X�R�[�h�Ǘ��}�X�^
rem =====================================
set callbat=bat\466.A11SRCJ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 653 �����ʒm
rem =====================================
set callbat=bat\653.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 008 ���i��{�}�X�^(�\��)
rem =====================================
set callbat=bat\008.AEA81.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ���i�}�X�^_�\��(�O�񏈗�����)
set callbat=bat\008.MSTSHN_Y_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 009 �d���O���[�v���i(�\��)
rem =====================================
set callbat=bat\009.AEA82.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �d���O���[�v_�\��(�O�񏈗�����)
set callbat=bat\009.MSTSIRGPSHN_Y_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 010 �����R���g���[��(�\��)
rem =====================================
set callbat=bat\010.AEA83.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �����R���g���[��_�\��(�O�񏈗�����)
set callbat=bat\010.MSTBAIKACTL_Y_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 011 �\�[�X�R�[�h�Ǘ�(�\��)
rem =====================================
set callbat=bat\011.AEA84.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �\�[�X�R�[�h�Ǘ�_�\��(�O�񏈗�����)
set callbat=bat\011.MSTSRCCD_Y_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 001 ���i��{�}�X�^
rem =====================================
set callbat=bat\001.AEA81.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ���i�}�X�^(�O�񏈗�����)
set callbat=bat\001.MSTSHN_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 002 �d���O���[�v���i
rem =====================================
set callbat=bat\002.AEA82.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �d���O���[�v���i(�O�񏈗�����)
set callbat=bat\002.MSTSIRGPSHN_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 003 �����R���g���[��
rem =====================================
set callbat=bat\003.AEA83.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �����R���g���[��(�O�񏈗�����)
set callbat=bat\003.MSTBAIKACTL_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 004 �\�[�X�R�[�h�Ǘ�
rem =====================================
set callbat=bat\004.AEA84.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �\�[�X�R�[�h�Ǘ�(�O�񏈗�����))
set callbat=bat\004.MSTSRCCD_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem INAMS2�\��}�X�^���{�}�X�^���f
rem =====================================
set callbat=bat\000.UPDATE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


rem =====================================
rem 007 ���σp�b�N�P��
rem =====================================
set callbat=bat\007.AIA59.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 026 ���i�X�O���[�v
rem =====================================
set callbat=bat\026.AIA57.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 026 �����R���g���[��
rem =====================================
set callbat=bat\026.AEA83.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 026 �����R���g���[��(�\��)
rem =====================================
set callbat=bat\026.AEA83_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 ���i�X�O���[�v�X��
rem =====================================
set callbat=bat\027.AIA58.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 �d���O���[�v���i
rem =====================================
set callbat=bat\027.AEA82.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 �d���O���[�v���i(�\��)
rem =====================================
set callbat=bat\027.AEA82_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 �����R���g���[��
rem =====================================
set callbat=bat\027.AEA83.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 �����R���g���[��(�\��)
rem =====================================
set callbat=bat\027.AEA83_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 �z���p�^�[��
rem =====================================
set callbat=bat\037.AIC55.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 ���i��{�}�X�^
rem =====================================
set callbat=bat\037.AEA81.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 ���i��{�}�X�^(�\��)
rem =====================================
set callbat=bat\037.AEA81_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 �d���O���[�v���i
rem =====================================
set callbat=bat\037.AEA82.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 �d���O���[�v���i(�\��)
rem =====================================
set callbat=bat\037.AEA82_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 038 �G���A�ʔz���p�^�[��
rem =====================================
set callbat=bat\038.AIC56.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 629 �����ʒm
rem =====================================
set callbat=bat\629.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 66 �v���C�X�J�[�h�f�[�^�v���f�[�^�i�{���j
rem =====================================
set callbat=bat\066.AEP20.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


rem =====================================
rem 001 ���i�}�X�^(�O����������)
rem =====================================
set callbat=bat\001.MSTSHN_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 002 �d���O���[�v���i(�O����������)
rem =====================================
set callbat=bat\002.MSTSIRGPSHN_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 003 �����R���g���[��(�O����������)
rem =====================================
set callbat=bat\003.MSTBAIKACTL_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 004 �\�[�X�R�[�h�Ǘ�(�O����������))
rem =====================================
set callbat=bat\004.MSTSRCCD_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 008 ���i�}�X�^_�\��(�O����������)
rem =====================================
set callbat=bat\008.MSTSHN_Y_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 009 �d���O���[�v���i_�\��(�O����������)
rem =====================================
set callbat=bat\009.MSTSIRGPSHN_Y_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 010 �����R���g���[��_�\��(�O����������)
rem =====================================
set callbat=bat\010.MSTBAIKACTL_Y_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 011 �\�[�X�R�[�h�Ǘ�_�\��(�O����������))
rem =====================================
set callbat=bat\011.MSTSRCCD_Y_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 �G���A�ʔz���p�^�[���}�X�^(�O����)
rem =====================================
set callbat=bat\151.MSTAREAHSPTN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 �G���A�ʔz���p�^�[���d����}�X�^(�O����)
rem =====================================
set callbat=bat\151.MSTAREAHSPTNSIR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 �z���p�^�[���}�X�^(�O����)
rem =====================================
set callbat=bat\151.MSTHSPTN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 �z���p�^�[���d����}�X�^(�O����)
rem =====================================
set callbat=bat\151.MSTHSPTNSIR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 ���i�}�X�^(�O����)
rem =====================================
set callbat=bat\151.MSTSHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 ���i�}�X�^_�\��(�O����)
rem =====================================
set callbat=bat\151.MSTSHN_Y.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 �d����}�X�^(�O����)
rem =====================================
set callbat=bat\151.MSTSIR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 �d���O���[�v���i�}�X�^(�O����)
rem =====================================
set callbat=bat\151.MSTSIRGPSHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 �d���O���[�v���i�}�X�^_�\��(�O����)
rem =====================================
set callbat=bat\151.MSTSIRGPSHN_Y.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


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
