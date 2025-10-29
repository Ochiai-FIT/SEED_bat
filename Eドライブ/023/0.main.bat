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
rem �Â����M�񓚗p�̔��f�[�^�쐬
rem =====================================
set callbat=bat\000.MS_HANBAI_EVS.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem B/M �Â����M�񓚗p�̔��f�[�^�쐬
rem =====================================
set callbat=bat\000.MS_HANBAI_BMS.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���������̔��f�[�^_WK�쐬
rem =====================================
set callbat=bat\000.SO_HANBAI_WK.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���������̔��f�[�^�쐬
rem =====================================
set callbat=bat\000.SO_HANBAI.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S�X�����A���P�[�g�� �̔��f�[�^�쐬
rem =====================================
set callbat=bat\000.AN_HANBAI_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �X�ܒP�� �[����(�A��)
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S�X�����A���P�[�g�� �[���f�[�^�쐬
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���Ԕ[����(�A���S��)
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_NEQ_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S�i�����[���f�[�^�쐬
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S�X�����A���P�[�g�L �̔��f�[�^(���f�O)�쐬
rem =====================================
set callbat=bat\000.AN_HANBAI_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���Ԕ[����(�A�L���f�O)
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S�X�����A���P�[�g�L �[���f�[�^(���f�O)�쐬 �V�K��
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_NEW.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S�X�����A���P�[�g�L �[���f�[�^(���f�O)�쐬 �X�V��
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_UPD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �S�X�����A���P�[�g�L �[���f�[�^(���f�O)�쐬 �ύX����
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_PRE.LOAD.bat
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
rem ���O�������ʒ����i�����p�j
rem =====================================
rem WH30-1,2���s���A���O����_�X��(A11TC26)�A���O����_�ǉ����i(A11J04)��WK�ɏ���
set callbat=bat\148.JH_RTN_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

set callbat=bat\149.JH_RTN_ADDSHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

set callbat=bat\000.JH_TEN_SYUSEI_KARIJIME.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 ���O����_�������ʎ捞���ԃL�[(�A�L)
rem =====================================
set callbat=bat\000.JH_HSUU_KEY_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 ���O����_�������ʎ捞���ԃL�[(�A��)
rem =====================================
set callbat=bat\000.JH_HSUU_KEY_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 ���O����_�������ʎ捞���ԃL�[
rem =====================================
set callbat=bat\000.JH_HSUU_KEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞�� �����G���[�t�@�C��(�A�L)
rem =====================================
set callbat=bat\000.JH_TOK_ERR_BFR1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞�� �����G���[�t�@�C��(�A��)
rem =====================================
set callbat=bat\000.JH_TOK_ERR_NEQ1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞��(�A�L)
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_HSUU.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞��(�A��)
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_HSUU.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞���X�V(�A�L)
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_JHTSUINDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞���X�V(�A��)
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_JHTSUINDT.MRG.bat
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
rem 100 �Â��R�[�h
rem =====================================
set callbat=bat\100.BFC01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 101 �����N�}�X�^
rem =====================================
set callbat=bat\101.BFC05.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 102 ���ʃp�^�[���}�X�^
rem =====================================
set callbat=bat\102.BFC06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 103 ���ʃ����N�}�X�^
rem =====================================
set callbat=bat\103.BFC07.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 104 �ʏ헦�p�^�[���}�X�^
rem =====================================
set callbat=bat\104.BFC08.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 105 �`���V�̂ݕ���
rem =====================================
set callbat=bat\105.BFC41.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 668 �����ʒm
rem =====================================
set callbat=bat\668.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 107 �S���A���P�[�g�L��{
rem =====================================
set callbat=bat\107.BFC02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 106 �S���A���P�[�g�L���i
rem =====================================
set callbat=bat\106.BFC03.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 669 �����ʒm
rem =====================================
set callbat=bat\669.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 108 �S���A���P�[�g�����i
rem =====================================
set callbat=bat\108.BFC04.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 670 �����ʒm
rem =====================================
set callbat=bat\670.�����ʒm.EXP.bat
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
rem 658 �����ʒm
rem =====================================
set callbat=bat\658.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 119 �Ⓚ�H�i�Q���
rem =====================================
set callbat=bat\119.BFC22.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 120 �Ⓚ�H�i�Q���i
rem =====================================
set callbat=bat\120.BFC23.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 140 ��ʓ����t�@�C���@�i�S�X�����j
rem =====================================
rem �W�J�p�Ⓚ�H�i(A11.F860I)
set callbat=bat\140.TMWK_A11TC34.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �Ώ۔̔��f�[�^(�A�L)
set callbat=bat\140.ANWK12_HAN_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �Ώ۔̔��f�[�^(�A��)
set callbat=bat\140.ANWK12_HAN_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �Ώ۔[���f�[�^(�A�L)
set callbat=bat\140.ANWK12_NOU_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �Ώ۔[���f�[�^(�A��)
set callbat=bat\140.ANWK12_NOU_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �S���A���P�[�g�L �̔��f�[�^(���f��)WK1 ����ʓ����[�����f�[�^(�A�L)�p
set callbat=bat\000.AN_HANBAI_AFT_WK1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(�A�L)
set callbat=bat\140.ANWK13_TC18_A.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem �S���A���P�[�g�� �̔��f�[�^WK1 ����ʓ����[�����f�[�^(�A��)�p
set callbat=bat\000.AN_HANBAI_NEQ_WK1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(�A��)
set callbat=bat\140.ANWK13_TC18_N.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(�A�L)2
set callbat=bat\140.ANWK13_TC18_A2.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(�A��)2
set callbat=bat\140.ANWK13_TC18_N2.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(���ԃ��[�N)(�A�L)
set callbat=bat\140.ANWK14_TN06_A.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(���ԃ��[�N)(�A��)
set callbat=bat\140.ANWK14_TN06_N.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(��H�W�J)(�A�L)
set callbat=bat\140.ANWK14_TN06R_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(��H�W�J)(�A��)
set callbat=bat\140.ANWK14_TN06R_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ��ʓ����t�@�C���i�S�X�����j
set callbat=bat\140.BFB01_Z.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  < %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem export
set callbat=bat\140.BFB01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 654 �����ʒm
rem =====================================
set callbat=bat\654.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 109 ���K��ʁQ���i
rem =====================================
set callbat=bat\109.BFC13.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 110 ���K��ʁQ�X�ʐ���
rem =====================================
set callbat=bat\110.BFC14.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 112 ���T��ʁQ�X�ʐ���
rem =====================================
set callbat=bat\112.BFC16.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 662 �����ʒm
rem =====================================
set callbat=bat\662.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 144 �Â����M�@�i�o�k�t�j
rem =====================================
rem �W�J�p�Ⓚ�H�i(A11.F858I)
set callbat=bat\144.TMWK_A11TC34.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �ύX���S���L�Â��R�[�h
set callbat=bat\144.TMWK_A11TC01_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �ύX���S�����Â��R�[�h
set callbat=bat\144.TMWK_A11TC01_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �ύX�����������Â��R�[�h
set callbat=bat\144.TMWK_A11TC01_S.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �񓚗p�̔��f�[�^_��H�W�J(�A�L)
set callbat=bat\144.TMWK40_A11TC13_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �񓚗p�̔��f�[�^_��H�W�J(�A��)
set callbat=bat\144.TMWK40_A11TC13_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �S���A�� �񓚗p�̔��f�[�^_�Â��t��
set callbat=bat\144.TMWK41_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �S���A�L �񓚗p�̔��f�[�^_�Â��t��
set callbat=bat\144.TMWK42_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �������� �񓚗p�̔��f�[�^_�Â��t��
set callbat=bat\144.TMWK44_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �Â����M �񓚗p�̔��f�[�^_�Â��t��
set callbat=bat\144.TMWK48_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �a�l�Â����M �񓚗p�̔��f�[�^_�Â��t��
set callbat=bat\144.TMWK49_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


rem �S���A�� �񓚗p�̔��f�[�^_10����
set callbat=bat\144.TMWK41_A11TC05_01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �S���A�L �񓚗p�̔��f�[�^_10����
set callbat=bat\144.TMWK42_A11TC05_01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �Â����M �񓚗p�̔��f�[�^_10����
set callbat=bat\144.TMWK48_A11TC05_01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem �񓚗p�̔��f�[�^_OUEN
set callbat=bat\144.TMWK41_A11TC05_OUEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\144.BFG01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 145 �Â����M�@�i�a�^�l�j
rem =====================================
rem export
set callbat=bat\145.BFG01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 677 �����ʒm
rem =====================================
set callbat=bat\677.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 124 �V�X�����X�����Q����
rem =====================================
set callbat=bat\124.BFC33.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 125 �V�X�����X�����Q���i
rem =====================================
set callbat=bat\125.BFC34.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 121 ���ފ����Q���
rem =====================================
set callbat=bat\121.BFC24.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 122 ���ފ����Q�Ώۏ��O�X
rem =====================================
set callbat=bat\122.BFC25.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 123 ���O�ŏo�Q���i
rem =====================================
set callbat=bat\123.BFC26.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 672 �����ʒm
rem =====================================
set callbat=bat\672.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 146 �Â����M�@�i���ޕ����j
rem =====================================
rem =====
set callbat=bat\146.A11TN11.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 678 �����ʒm
rem =====================================
set callbat=bat\678.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


rem =====================================
rem ������A���[������ޔ�
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_PRE.LOAD.bat
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
