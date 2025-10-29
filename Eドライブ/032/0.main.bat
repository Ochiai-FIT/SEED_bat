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

REM ===== HULFT REV MOVE =================
DEL /Q %~dp0\DATA\*
ROBOCOPY  D:\HULFTFILES\RCV\0189 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0190 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0191 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0192 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0193 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%

REM ===== BACKUP COPY ====================
setlocal
set x=%~dp0
set x=%x:~0,-1%
for /F "delims=" %%a in ('echo "%x%"') do set DIRNAME=%%~na
ROBOCOPY %~dp0DATA E:\MDM\%DIRNAME%\%ltime% /R:0 /E /NFL /NP /XD backup bkup RcvTemp >> %outfile%
endlocal

rem =====================================
rem 189 ���O����
rem =====================================
set callbat=bat\189.BFI01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 189 ���O���� �}�[�W
rem =====================================
set callbat=bat\189.TOKTJ.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 ���O�����Q���i
rem =====================================
set callbat=bat\190.BFI02.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 ���O�����Q���i �폜
rem =====================================
set callbat=bat\190.TOKTJ_SHN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 ���O�����Q���i �}�[�W
rem =====================================
set callbat=bat\190.TOKTJ_SHN.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 ���O����_�X�� �폜
rem =====================================
set callbat=bat\190.TOKTJ_TEN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 ���O����_�ǉ����i �폜
rem =====================================
set callbat=bat\190.TOKTJ_ADDSHN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 191 ���O�����Q�X��
rem =====================================
set callbat=bat\191.BFI03.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 191 ���O�����Q�X�� �}�[�W
rem =====================================
set callbat=bat\191.TOKTJ_TEN.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 192 ���O�����Q���σp�b�N�P��
rem =====================================
set callbat=bat\192.BFI04.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 192 ���O�����Q���σp�b�N�P�� �폜
rem =====================================
set callbat=bat\192.TOKTJ_AVGPTANKA.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 192 ���O�����Q���σp�b�N�P�� �}�[�W
rem =====================================
set callbat=bat\192.TOKTJ_AVGPTANKA.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 �A���P�[�g���ʍ쐬�L�[
rem =====================================
set callbat=bat\000.AN_CRE_KEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 �A���P�[�g����_�X�O���[�v���f���R�[�h���[�h
rem =====================================
set callbat=bat\000.AN_QATENGP_DIFF.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 �A���P�[�g����_�X�ܔ��f�����R�[�h���[�h
rem =====================================
set callbat=bat\000.AN_QATEN_DIFF.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 �A���P�[�g����_���i���f�����R�[�h���[�h
rem =====================================
set callbat=bat\000.AN_QASHN_DIFF.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 INATK2 �A���P�[�g����_�X�O���[�v �}�[�W
rem =====================================
set callbat=bat\000.TOKTG_QAGP_INATK2.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 INATK2 �A���P�[�g����_�X�� �}�[�W
rem =====================================
set callbat=bat\000.TOKTG_QATEN_INATK2.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 INATK2 �A���P�[�g����_���i �}�[�W
rem =====================================
set callbat=bat\000.TOKTG_QASHN_INATK2.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 �A���P�[�g�č쐬���N���A
rem =====================================
set callbat=bat\000.TOKTG_KHN_QADT_CLEAR.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʍ쐬 �A���P�[�g�č쐬�������N���A
rem =====================================
set callbat=bat\000.TOKTG_TENGP_QADT_CLEAR.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S�X����(�ݹ�ėL)_���i�ΏۓX�܍쐬
rem =====================================
set callbat=bat\000.ANWK_A11TC44.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʔ��f(�̔����)
rem =====================================
rem �̔��f�[�^(�A�L)�쐬
set callbat=bat\000.AN_HANBAI_AFT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem P230:�̔����X���C�h���{
set callbat=bat\000.AN_HANBAI_DT.LOAD.AFT.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���Ԕ[����(�A�L���f��)
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʔ��f(�[�����) �Ώ�
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_TRG.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʔ��f(�[�����) �ΏۊO1
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_NOTRG1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g���ʔ��f(�[�����) �ΏۊO2
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_NOTRG2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���Ԕ[����(�A�L�S�����f�O)
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_BFR_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g����(�S�i�����[���f�[�^)
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���Ԕ[����(�A�L�S�����f��)
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_AFT_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S���A���P�[�g�L �[���f�[�^ �S�i����(���f��) �Ώ�
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_AFT_TRG.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S���A���P�[�g�L �[���f�[�^ �S�i����(���f��) �ΏۊO
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_AFT_NOTRG.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S���A���P�[�g�L �[���f�[�^ �S�i����(���f��) ���O����
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_AFT_JZEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 131 �\�񔭒�_���
rem =====================================
set callbat=bat\131.BFC29.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 128 �\�񔭒��Q���i
rem =====================================
set callbat=bat\128.BFC30.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 129 �\�񔭒��Q�[����
rem =====================================
set callbat=bat\129.BFC31.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 130 �\�񔭒��Q�X��
rem =====================================
set callbat=bat\130.BFC32.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 116 ���������Q���i
rem =====================================
set callbat=bat\116.BFC19.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 115 ���������Q����
rem =====================================
set callbat=bat\115.BFC18.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 659 �����ʒm
rem =====================================
set callbat=bat\659.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 127 �A���P�[�g�t��������Q���i
rem =====================================
set callbat=bat\127.BFC28.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 126 �A���P�[�g�t��������Q�Â�
rem =====================================
set callbat=bat\126.BFC27.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 142 ��ʓ����t�@�C���@�i���O�ŏo�j
rem =====================================
rem ��ʓ����t�@�C��(���O�ŏo)
set callbat=bat\142.BFB01_J.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\142.BFB01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 674 �����ʒm
rem =====================================
set callbat=bat\674.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 147 �V�����X�����f�[�^
rem =====================================
rem �V�X�����X����
set callbat=bat\147.THWK01_A10TSKD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\147.A10TSKD.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 673 �����ʒm
rem =====================================
set callbat=bat\673.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem DM84 �S�X����(�A���P�[�g�L)-�̔����M
rem =====================================
rem �f�[�^�쐬
set callbat=bat\000.AN_TOKTG_HB.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%OUTFILE% 2>&1
if errorlevel 1 goto error

rem ���f
set callbat=bat\000.TOKTG_HB.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem DM85 �S�X����(�A���P�[�g�L)-�[�����M
rem =====================================
rem �f�[�^�쐬
set callbat=bat\000.AN_TOKTG_NNDT.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%OUTFILE% 2>&1
if errorlevel 1 goto error

rem ���f
set callbat=bat\000.TOKTG_NNDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 193 INAIN ���O�����Ώۓ��t�t�@�C��
rem =====================================
set callbat=bat\193.BFB00.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 193 INAIF ���O�����Ώۓ��t
rem =====================================
set callbat=bat\193.JH_DATE.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������X�g�o�͓��ݒ� ���O�������X�g�o�͓����f����(�A�L)
rem =====================================
set callbat=bat\000.JH_LIST_DIFF_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������X�g�o�͓��ݒ� �S���A���P�[�g�L �[���f�[�^(���f�O)�X�V
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_JLSTCREDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������X�g�o�͓��ݒ� �S�X����(�A���P�[�g�L)_���i�X�V 
rem =====================================
set callbat=bat\000.TOKTG_SHN_JLSTCREDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������X�g�o�͓��ݒ� �S�X�����i�A���P�[�g�L�j_��{�X�V
rem =====================================
set callbat=bat\000.TOKTG_KHN_JLSTCREFLG.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������X�g�o�͓��ݒ� ���O�������X�g�o�͓����f����(�A��)
rem =====================================
set callbat=bat\000.JH_LIST_DIFF_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������X�g�o�͓��ݒ� �S���A���P�[�g�� �[���f�[�^�X�V
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_JLSTCREDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������X�g�o�͓��ݒ� �S�X����(�A���P�[�g��)_���i�X�V
rem =====================================
set callbat=bat\000.TOKSP_SHN_JLSTCREDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �A���P�[�g�L�[�����쐬 DM97
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_HSUU.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ������A�L�[������ޔ�
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_PRE.LOAD.bat
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
