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

REM 25:00

REM ===== 052 �X��B/M���M�� ==
SET CALLBAT=BAT\052.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 053 �X��B/M���M��_���i ==
SET CALLBAT=BAT\053.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 054 �X��B/M���M��_�X�� ==
SET CALLBAT=BAT\054.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 055 �A���P�[�g����_�X�O���[�v ==
SET CALLBAT=BAT\055.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 056 �A���P�[�g����_�X�� ==
SET CALLBAT=BAT\056.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 057 �A���P�[�g����_���i ==
SET CALLBAT=BAT\057.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 058 �S�X����(�A���P�[�g�L)_�̔� ==
REM SET CALLBAT=BAT\058.LOAD.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 059 ���O���� ==
SET CALLBAT=BAT\059.MERGE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 060 ���O����_���σp�b�N�P�� ==
SET CALLBAT=BAT\060.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 061 ���O����_���i ==
SET CALLBAT=BAT\061.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 070 �S�X����(�A���P�[�g�L)_�[���� ==
REM SET CALLBAT=BAT\070.LOAD.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 071 �S�X����(�A���P�[�g�L)_�[���� ==
REM SET CALLBAT=BAT\071.MERGE.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 072 ���O����_�X�� ==
REM SET CALLBAT=BAT\072.LOAD.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 073 �S�X����(�A���P�[�g��)_�[���� ==
REM SET CALLBAT=BAT\073.LOAD.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 074 �S�X����(�A���P�[�g��)_�[���� ==
REM SET CALLBAT=BAT\074.MERGE.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 075 �S�X����(�A���P�[�g�L)_���i ==
REM SET CALLBAT=BAT\075.MERGE.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 076 �S�X����(�A���P�[�g��)_���i ==
REM SET CALLBAT=BAT\076.MERGE.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 080 �S�X����(�A���P�[�g�L)_�[���� ==
REM SET CALLBAT=BAT\080.MERGE.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 082 �S�X����(�A���P�[�g��)_�[���� ==
REM SET CALLBAT=BAT\082.MERGE.BAT
REM >> %OUTFILE% ECHO %CALLBAT%
REM CALL %~DP0%CALLBAT%
REM IF ERRORLEVEL 1 GOTO ERROR

REM ===== 083 �A���P�[�g�č쐬���V�t�g(��{) ==
SET CALLBAT=BAT\083.UPDATE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 084 �A���P�[�g�č쐬���V�t�g(�X�O���[�v) ==
SET CALLBAT=BAT\084.UPDATE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 085 ���O�������X�g�쐬�σt���O�Z�b�g ==
SET CALLBAT=BAT\085.UPDATE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 086 PLU�z�M�σZ�b�g ==
SET CALLBAT=BAT\086.UPDATE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 026 ��ʒ���폜 ==
SET CALLBAT=BAT\026.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 088 ���K���_���i �����폜 ==
SET CALLBAT=BAT\088.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 089 ���K���_�X�ʐ��� �����폜 ==
SET CALLBAT=BAT\089.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 090 ���T���_�X�ʐ��� �����폜 ==
SET CALLBAT=BAT\090.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 091 ����폜 �\�񔭒� ==
SET CALLBAT=BAT\091.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 092 ����폜 �V�X�����X���� ==
SET CALLBAT=BAT\092.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 093 ����폜 �Â��֘A ==
SET CALLBAT=BAT\093.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 094 ����폜 �Ⓚ�H�i ==
SET CALLBAT=BAT\094.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 095 ����폜 ���O���� ==
SET CALLBAT=BAT\095.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 096 ����폜 �d���`�F�b�N�֘A ==
SET CALLBAT=BAT\096.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 097 ����폜 CSV�捞�g���� ==
SET CALLBAT=BAT\097.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 098 ����폜 ���ї��p�^�� ==
SET CALLBAT=BAT\098.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 099 ����폜 ���ї��p�^�� ==
SET CALLBAT=BAT\099.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 100 ����폜 ���O ==
SET CALLBAT=BAT\100.DELETE.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR


REM ===== 050 �Â��������[�h ==
SET CALLBAT=BAT\050.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 064 �Â�����_���i ==
SET CALLBAT=BAT\064.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

REM ===== 065 �Â�����_�X�� ==
SET CALLBAT=BAT\065.LOAD.BAT
>> %OUTFILE% ECHO %CALLBAT%
CALL %~DP0%CALLBAT%
IF ERRORLEVEL 1 GOTO ERROR

rem ���Ŏg�p���Ȃ��v�j�̏ꍇ�A�P�̃o�b�`���ɋL��


:SUCCESS
echo %DATE% %TIME% ����������ɏI�����܂��� >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% �G���[���������܂���(RC=1) >> %outfile%
EXIT /B 1
