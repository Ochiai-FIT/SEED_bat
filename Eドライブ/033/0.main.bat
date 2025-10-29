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
ROBOCOPY  D:\HULFTFILES\RCV\0194 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0195 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%

REM ===== BACKUP COPY ====================
setlocal
set x=%~dp0
set x=%x:~0,-1%
for /F "delims=" %%a in ('echo "%x%"') do set DIRNAME=%%~na
ROBOCOPY %~dp0DATA E:\MDM\%DIRNAME%\%ltime% /R:0 /E /NFL /NP /XD backup bkup RcvTemp >> %outfile%
endlocal

rem =====================================
rem 194 INAIN ���O�������ʓ��͒��ߓ��t�t�@�C��
rem =====================================
set callbat=bat\194.BFB00_SHIME.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 194 INAIF ���O�������ʓ��͒��ߓ��t
rem =====================================
set callbat=bat\194.JH_SHIME_DATE.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 148 ���O�����Q�X�܁i�߂�p�j
rem =====================================
set callbat=bat\148.JH_RTN_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\148.BFI07.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 149 ���O�����Q�ǉ����i�i�߂�p�j
rem =====================================
set callbat=bat\149.JH_RTN_ADDSHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\149.BFI06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 675 �����ʒm
rem =====================================
set callbat=bat\675.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 150 �X�܏C���f�[�^(�{����)
rem =====================================
set callbat=bat\150.JH_TEN_SYUSEI.HONJIME.LOAD.bat
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
set callbat=bat\000.JH_TOK_ERR_HSUU.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 150 �X���ʔ��f�G���[�f�[�^(���N)
rem =====================================
set callbat=bat\150.A11TC30_S.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 150 �X���ʔ��f�G���[�f�[�^(�h���C)
rem =====================================
set callbat=bat\150.A11TC30_D.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 676 �����ʒm
rem =====================================
set callbat=bat\676.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem WH32-3 P480 �[�����X�V (���o�ϔ[�����A11.NOUNYU.AFT@])
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_HSUU.MRG.P480.bat
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
rem ���O�������ʎ捞�� �S�X����(�A���P�[�g�L)_���i�X�V DM34-2
rem =====================================
set callbat=bat\000.TOKTG_SHN_JHTSUINDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞�� �S�X����(�A���P�[�g��)_���i�X�V DM34-3
rem =====================================
set callbat=bat\000.TOKSP_SHN_JHTSUINDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞�� �S�X����(�A���P�[�g�L)_�[�����X�V
rem =====================================
rem �f�[�^�쐬
set callbat=bat\000.JH_TOKTG_NNDT.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat%  >>%outfile% 2>&1
if errorlevel 1 goto error

rem ���f(INATK) 
set callbat=bat\000.TOKTG_NNDT_INATK.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ���O�������ʎ捞�� �S�X����(�A���P�[�g��)_�[�����X�V
rem =====================================
rem �f�[�^�쐬
set callbat=bat\000.JH_TOKSP_NNDT.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat%  >>%outfile% 2>&1
if errorlevel 1 goto error

rem ���f(INATK2)
set callbat=bat\000.TOKSP_NNDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ���f(INATK) 
set callbat=bat\000.TOKSP_NNDT_INATK.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


REM �y�d�v�z���s�ғ��p�̎b��Ή�(INATK2.HATTR_CSV���������ߕ��s�ғ����Ԃ�CRIPS.A11T508����INATK2.HATTR_CSV���쐬)
rem =====================================
rem 000 �X�ʒ��_CSV �쐬�@��
rem =====================================
set callbat=bat\000.HATTR_CSV.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 ��ʕύX�f�[�^ �쐬 ���Ηj�̂ݓo�^�A���폜
rem =====================================
set callbat=bat\000.A11T508.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ��ʕύX�f�[�^�捞�� ���K��ʁQ�X�ʐ���
rem =====================================
set callbat=bat\000.HATSTR_TEN_INATK2.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem ��ʕύX�f�[�^�捞�� ���T��ʁQ�X�ʐ���(�ǉ�)
rem =====================================
set callbat=bat\000.HATJTR_TEN_INATK2.INS.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 195 ���O�����Ϗ��(JH_SUMI�œǂݍ���)
rem =====================================
set callbat=bat\195.BFB11.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� ���O�����Ϗ��
rem =====================================
set callbat=bat\000.JH_SUMI.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �T�Ԕ������������f����(�A�L)
rem =====================================
set callbat=bat\000.JH_WEEKHTDT_DIFF_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �����G���[�t�@�C��(�A�L)
rem =====================================
set callbat=bat\000.JH_TOK_ERR_BFR2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �S���A���P�[�g�L �[���f�[�^(���f�O)�X�V
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �S�X����(�A���P�[�g�L)_�[�����X�V WH42-3
rem =====================================
set callbat=bat\000.TOKTG_NNDT_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �S�X����(�A���P�[�g�L)_���i�X�V WH42-4
rem =====================================
set callbat=bat\000.TOKTG_SHN_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �T�Ԕ������������f����(�A��)
rem =====================================
set callbat=bat\000.JH_WEEKHTDT_DIFF_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �����G���[�t�@�C��(�A��)
rem =====================================
set callbat=bat\000.JH_TOK_ERR_NEQ2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �S���A���P�[�g�� �[���f�[�^�X�V
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �S�X����(�A���P�[�g��)_�[�����X�V WH42-3
rem =====================================
set callbat=bat\000.TOKSP_NNDT_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �T�Ԕ����������捞�� �S�X����(�A���P�[�g��)_���i�X�V WH42-4
rem =====================================
set callbat=bat\000.TOKSP_SHN_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem �����O�A�L�[������ޔ�
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_PRE.LOAD.bat
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
rem 665 �����ʒm
rem =====================================
set callbat=bat\665.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 140 ��ʓ����t�@�C���@�i�S�X�����j
rem =====================================
rem �W�J�p�Ⓚ�H�i
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
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >>%outfile% 2>&1
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
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv <  %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(�A�L)2
set callbat=bat\140.ANWK13_TC18_A2.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(�A��)2
set callbat=bat\140.ANWK13_TC18_N2.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv <  %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(���ԃ��[�N)(�A�L)
set callbat=bat\140.ANWK14_TN06_A.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv <   %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem ��ʓ����[�����f�[�^(���ԃ��[�N)(�A��)
set callbat=bat\140.ANWK14_TN06_N.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%outfile% 2>&1
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
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem export
set callbat=bat\140.BFB01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 657 �����ʒm
rem =====================================
set callbat=bat\657.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 91 wk �񓚗p�̔��f�[�^�쐬
rem =====================================
set callbat=bat\091.ANWK01_AF.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem =====================================
rem 91 �S���A���P�[�g�L���i
rem =====================================
set callbat=bat\091.BFE05.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 90 �S���A���P�[�g�L�X��
rem =====================================
set callbat=bat\090.BFE06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 93 �S���A���P�[�g�����i
rem =====================================
set callbat=bat\093.BFE05.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 92 �S���A���P�[�g���X��
rem =====================================
set callbat=bat\092.BFE06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 666 �����ʒm
rem =====================================
set callbat=bat\666.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 96 �e�X�A���P�[�g
rem =====================================
set callbat=bat\096.BFF12.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 94 ���[�_�[�X�A���P�[�g
rem =====================================
set callbat=bat\094.BFF10.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 95 ���[�_�[�X�A�C�e���A���P�[�g
rem =====================================
set callbat=bat\095.BFF11.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 �ݹ�Čn�[�������ԃf�[�^�ێ�(�O����)
rem =====================================
set callbat=bat\000.AN_NOUNYU_PRE.LOAD.bat
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
