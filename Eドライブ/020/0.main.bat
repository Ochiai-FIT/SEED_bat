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
rem 028 �X�܊�{�}�X�^
rem =====================================
set callbat=bat\028.AFA01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 030 �X�ܕ���}�X�^
rem =====================================
set callbat=bat\030.AFA02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 029 �X�܎���
rem =====================================
set callbat=bat\029.AIB02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 031 �X�ܕ������
rem =====================================
set callbat=bat\031.AIB03.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 032 �X�ܗj���ʔ�������
rem =====================================
set callbat=bat\032.AIB07.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 033 �X�܋x��
rem =====================================
set callbat=bat\033.AIB06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 632 �����ʒm
rem =====================================
set callbat=bat\632.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 034 �d����}�X�^
rem =====================================
set callbat=bat\034.AFB01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 035 �z���p�^�[���d����
rem =====================================
set callbat=bat\035.AIC52.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 036 �G���A�ʔz���p�^�[���d����
rem =====================================
set callbat=bat\036.AIC53.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 039 �����d����Q���d����
rem =====================================
set callbat=bat\039.AIC57.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 040 �����d����Q�X��
rem =====================================
set callbat=bat\040.AIC58.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 635 �����ʒm
rem =====================================
set callbat=bat\635.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 087 �����p�����d����
rem =====================================
rem �����p�����d����
set callbat=bat\087.HA_A11MSIR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\087.A11MSIR.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 041 �z���O���[�v
rem =====================================
set callbat=bat\041.A11HGM.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 042 �z���X�O���[�v
rem =====================================
set callbat=bat\042.A11HGT.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 043 �z���X�O���[�v�X��
rem =====================================
set callbat=bat\043.A11HGT.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 043 �G���A�ʔz���p�^�[���d����
rem =====================================
set callbat=bat\043.AIC53.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 043 �G���A�ʔz���p�^�[��
rem =====================================
set callbat=bat\043.AIC56.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 638 �����ʒm
rem =====================================
set callbat=bat\638.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 44 ����}�X�^
rem =====================================
set callbat=bat\044.AFC01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 45 �啪�ރ}�X�^
rem =====================================
set callbat=bat\045.ARD02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 46 �����ރ}�X�^
rem =====================================
set callbat=bat\046.ARD03.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 47 �����ރ}�X�^
rem =====================================
set callbat=bat\047.ARD04.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 48 �������ރ}�X�^
rem =====================================
set callbat=bat\048.ARD05.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 49 �p�r���ޑ啪�ރ}�X�^
rem =====================================
set callbat=bat\049.ARD02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 50 �p�r���ޒ����ރ}�X�^
rem =====================================
set callbat=bat\050.ARD03.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 51 �p�r���ޏ����ރ}�X�^
rem =====================================
set callbat=bat\051.ARD04.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 52 ���ꕪ�ޑ啪�ރ}�X�^
rem =====================================
set callbat=bat\052.ARD02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 53 ���ꕪ�ޒ����ރ}�X�^
rem =====================================
set callbat=bat\053.ARD03.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 54 ���ꕪ�ޏ����ރ}�X�^
rem =====================================
set callbat=bat\054.ARD04.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 55 �l�t���ޑ啪�ރ}�X�^
rem =====================================
set callbat=bat\055.ARD02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 56 �l�t���ޒ����ރ}�X�^
rem =====================================
set callbat=bat\056.ARD03.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 57 �l�t���ޏ����ރ}�X�^
rem =====================================
set callbat=bat\057.ARD04.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 641 �����ʒm
rem =====================================
set callbat=bat\641.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 58 ���[�h�^�C��
rem =====================================
set callbat=bat\058.AIF51.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 59 ���[�J�[
rem =====================================
set callbat=bat\059.AFD02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 60 �ŗ�
rem =====================================
set callbat=bat\060.AIF52.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 61 ����
rem =====================================
set callbat=bat\061.A11NAME.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 062 ���̕ϊ��G���[�f�[�^
rem =====================================
set callbat=bat\062.A11ERR.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 644 �����ʒm
rem =====================================
set callbat=bat\644.�����ʒm.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 081 �����p���i�}�X�^
rem =====================================
rem �����p���i�}�X�^
set callbat=bat\081.HA_A11SHOH.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\081.A11SHOH.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 088 �����p���i�}�X�^�i�\��j
rem =====================================
rem �����p���i�}�X�^�i�\��j
set callbat=bat\088.HA_A11SHOH_Y.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\088.A11SHOH.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 083 �����p�X�ܕ���}�X�^
rem =====================================
rem �����p�X�ܕ���}�X�^
set callbat=bat\083.HA_A11TBMH.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\083.A11TBMH.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 082 �����p�d�������X�ܓW�J
rem =====================================
rem �����p�d�������X�ܓW�J
set callbat=bat\082.HA_A11TSH.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\082.A11TSH.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 089 �����p�d�������X�ܓW�J�i�\��j
rem =====================================
rem �����p�d�������X�ܓW�J�i�\��j
set callbat=bat\089.HA_A11TSH_Y.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\089.A11TSH.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 084 �����p�z���p�^�[���d����
rem =====================================
rem �����p�z���p�^�[���d����
set callbat=bat\084.HA_A11HSR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\084.A11HSR.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 085 �����p�z���p�^�[���d����X�܁i�G���A�j
rem =====================================
rem �����p�z���p�^�[���d����X�܁i�G���A�j
set callbat=bat\085.HA_A11EHSR_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\085.A11EHSR.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 086 �����p�z���p�^�[���d����X�܁i�X�f�j
rem =====================================
rem �����p�z���p�^�[���d����X�܁i�X�f�j
set callbat=bat\086.HA_A11EHSR_G.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\086.A11EHSR.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 647 �����ʒm
rem =====================================
set callbat=bat\647.�����ʒm.EXP.bat
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
