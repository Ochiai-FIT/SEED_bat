@echo off
REM �󋵊m�F
REM Get-ExecutionPolicy

REM �|���V�[�ύX�i�Ǘ��Ҍ����ŊJ���j
REM Set-ExecutionPolicy RemoteSigned

REM �J�����g�t�H���_�Œ�
pushd %~dp0

REM �v���Z�X�`�F�b�N��Ƀo�b�`�J�n
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "%~dp0\.process.ps1 .start.bat;exit $LASTEXITCODE"

IF ERRORLEVEL 1 EXIT /B 1
EXIT /B 0

