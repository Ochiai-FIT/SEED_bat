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
rem PRE2�ޔ�
rem =====================================
set callbat=bat\177.D2WK28_ZZQ102_Z2_PRE2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �������t(�o�b�`)(���t�t�@�C��)������
rem =====================================
set callbat=bat\000.SYSBATCHDT_HA.MERGE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �Â��R�[�h�}�X�^(CCR�p)
rem =====================================
set callbat=bat\000.D2WK_BFC01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���[�h�^�C���p�����[�^(CCR�p)
rem =====================================
set callbat=bat\000.D2WK_PRAM_READTM.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���[�h�^�C���p�^�[���ϊ��p�����[�^(CCR�p)
rem =====================================
set callbat=bat\000.D2WK_PRAM_READTMCNV.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����t�@�C�����[�N1 �S�X����
rem =====================================
set callbat=bat\177.D2WK20_ZZQ102.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����t�@�C�����[�N3 �S�X����
rem =====================================
set callbat=bat\177.D2WK21_ZZQ102.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����f�[�^���[�N4 �S�X����
rem =====================================
set callbat=bat\177.D2WK22_ZZQ102.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����t�@�C�����[�N6(�S�X����)TIR
rem =====================================
set callbat=bat\177.D2WK23_ZZQ102_Z_TIR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����f�[�^���[�N6 �S�X����WK1
rem =====================================
set callbat=bat\177.D2WK23_ZZQ102_Z_WK1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����f�[�^���[�N6 �S�X����
rem =====================================
set callbat=bat\177.D2WK23_ZZQ102_Z.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����f�[�^���[�N7 �S�X����
rem =====================================
set callbat=bat\177.D2WK26_ZZQ102_Z.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����f�[�^���[�N8 �S�X����
rem =====================================
set callbat=bat\177.D2WK27_ZZQ102_Z.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 182 ��������_���i1KASAN
rem =====================================
set callbat=bat\182.D2WK24_ZZQ112_KASAN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 182 ��������_���i1KASAN2
rem =====================================
set callbat=bat\182.D2WK24_ZZQ112_KASAN2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 182 ��������_���i1NUM
rem =====================================
set callbat=bat\182.D2WK24_ZZQ112_NUM.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 182 ��������_���i1SSHNT
rem =====================================
set callbat=bat\182.D2WK24_ZZQ112_SSHNT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 182 ��������_���i1
rem =====================================
set callbat=bat\182.D2WK24_ZZQ112.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����t�@�C�����[�N(�S�X����)
rem =====================================
set callbat=bat\177.D2WK28_ZZQ102_Z.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 182 ��������_���i2
rem =====================================
set callbat=bat\182.D2WK28_ZZQ113_2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 182 ��������_���i3
rem =====================================
set callbat=bat\182.D2WK28_ZZQ113_3.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����t�@�C�����[�N(�S�X����)2
rem =====================================
set callbat=bat\177.D2WK28_ZZQ102_Z2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\177.ZZQ102.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem pre
set callbat=bat\177.D2WK28_ZZQ102_Z2_PRE.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 177 �X�ʒ�ʓ����f�[�^���[�N8 �S�X����(pre)
rem =====================================
set callbat=bat\177.D2WK27_ZZQ102_Z_PRE.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 181 ��������_����
rem =====================================
rem export
set callbat=bat\181.ZZQ104.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem pre
set callbat=bat\181.TOKSO_BMN_PRE.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 182 ��������_���i
rem =====================================
rem export
set callbat=bat\182.ZZQ105.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem pre
set callbat=bat\182.D2WK28_ZZQ113_3_PRE.LOAD.bat
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
echo %DATE% %TIME% ����������ɏI�����܂��� >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% �G���[���������܂���(RC=1) >> %outfile%
EXIT /B 1
