@echo off
cls

rem 初期値()
set event_output=0

rem 接続情報取得
set curpath=%~dp0..\
call %curpath%._init.bat

rem フォルダ名取得
set folderpath=%~dp0
set folderpath=%folderpath:~0,-1%
for /F "delims=" %%a in ('echo "%folderpath%"') do set foldername=%%~nxa

rem I/F リスト
set readlist=%~dp0list_load.txt
rem I/F 格納先フルパス
set input=%~dp0data
rem I/F 確認用バッチファイル
set checkfile=%~dp0checkfile.bat

rem I/F バックアップ用日時(YYYYMMDDHHMM)取得
set ltime=%date:~-10,4%%date:~-5,2%%date:~-2%%time:~0,2%%time:~3,2%
set ltime=%ltime: =0%

rem 日付取得
set days=%date:~8,2%

rem ログファイル
set outfile=%~dp0logs\setup.log
set outtime=%~dp0logs\time.log
set findfile=%~dp0logs\setup.find.log

rem ログフォルダ作成
if not exist %~dp0logs mkdir %~dp0logs

rem データフォルダ作成
if not exist %input% mkdir %input%

rem エクスポートフォルダ作成
if not exist %~dp0exp mkdir %~dp0exp


rem ログフォルダ・ローテーション
for %%F in (%outfile%) do if %%~zF GEQ 10485760 move /Y %outfile% %outfile%.old
for %%F in (%outtime%) do if %%~zF GEQ 10485760 move /Y %outtime% %outtime%.old

echo %DATE% %TIME% 日次処理(xx.Load_data)の開始 >> %outfile%


rem ================ <プロセス切断> ==============
rem SET callbat=bat\000.DISCONNECT.bat
rem >> %outfile% ECHO %callbat%
rem CALL %~dp0%callbat%
rem IF "%ERRORLEVEL%" EQU "1" GOTO ERROR

rem =====================================
rem 442 部門マスタ
rem =====================================
set callbat=bat\442.部門マスタ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 441T 取引先マスタ
rem =====================================
set callbat=bat\441T.仕入先マスタ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 443T 納品先マスタ
rem =====================================
set callbat=bat\443T.納品先マスタ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error



REM 改行コード除去
CALL %~dp0..\CNV\awk.bat %~dp0exp

REM ファイル名変更
copy %~dp0exp\部門マスタ.csv.cnv %~dp0exp\0442 /Y
copy %~dp0exp\取引先マスタT.csv.cnv %~dp0exp\0441T /Y
copy %~dp0exp\納品先マスタT.csv.cnv %~dp0exp\0443T /Y

REM ===== HULFT SEND DELETE ===============
DEL /Q D:\HULFTFILES\SEND\0442\*
DEL /Q D:\HULFTFILES\SEND\0441T\*
DEL /Q D:\HULFTFILES\SEND\0443T\*

REM ===== HULFT SEND MOVE =================
ROBOCOPY %~dp0EXP D:\HULFTFILES\SEND\0442 0442 /R:0 /NFL /NP >> %OUTFILE%
ROBOCOPY %~dp0EXP D:\HULFTFILES\SEND\0441T 0441T /R:0 /NFL /NP >> %OUTFILE%
ROBOCOPY %~dp0EXP D:\HULFTFILES\SEND\0443T 0443T /R:0 /NFL /NP >> %OUTFILE%

REM ===== HULFT SEND =======================
call %~dp0..\HULFT\.start_HULFT_SEND.bat A11MSW02 0442
call %~dp0..\HULFT\.start_HULFT_SEND.bat A11MSW06 0441T
call %~dp0..\HULFT\.start_HULFT_SEND.bat A11MSW07 0443T

REM ===== BACKUP COPY ====================
setlocal
set x=%~dp0
set x=%x:~0,-1%
for /F "delims=" %%a in ('echo "%x%"') do set DIRNAME=%%~na
ROBOCOPY %~dp0EXP E:\MDM\%DIRNAME%\%ltime% /R:0 /E /NFL /NP /XD backup bkup RcvTemp >> %outfile%
endlocal

:SUCCESS
echo %DATE% %TIME% 日次処理(Daily)が正常に終了しました >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% エラーが発生しました(RC=1) >> %outfile%
EXIT /B 1
