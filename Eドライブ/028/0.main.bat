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

REM ===== HULFT REV MOVE =================
DEL /Q %~dp0\DATA\*
ROBOCOPY  D:\HULFTFILES\RCV\0079 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0080 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%

REM ===== BACKUP COPY ====================
setlocal
set x=%~dp0
set x=%x:~0,-1%
for /F "delims=" %%a in ('echo "%x%"') do set DIRNAME=%%~na
ROBOCOPY %~dp0DATA E:\MDM\%DIRNAME%\%ltime% /R:0 /E /NFL /NP /XD backup bkup RcvTemp >> %outfile%
endlocal

rem =====================================
rem 79 催し送信状況ファイル（ＰＬＵ）
rem =====================================
set callbat=bat\079.BFG01_PLU.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 wk 店別催し送信状況ワーク
rem =====================================
set callbat=bat\079.A11TK13.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 wk 店別催し送信状況_商品ワーク
rem =====================================
set callbat=bat\079.A11TK14.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 wk 店別催し送信状況_店舗ワーク
rem =====================================
set callbat=bat\079.A11TK15.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 店別催し送信状況 削除
rem =====================================
set callbat=bat\079.TOKMS.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 店別催し送信状況 ロード
rem =====================================
set callbat=bat\079.TOKMS.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 店別催し送信状況_商品 削除
rem =====================================
set callbat=bat\079.TOKMS_SHN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 店別催し送信状況_商品 ロード
rem =====================================
set callbat=bat\079.TOKMS_SHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 店別催し送信状況_店舗 削除
rem =====================================
set callbat=bat\079.TOKMS_TEN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 79 店別催し送信状況_店舗 ロード
rem =====================================
set callbat=bat\079.TOKMS_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 催し送信状況ファイル（Ｂ／Ｍ）
rem =====================================
set callbat=bat\080.BFG01_BM.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 wk 店別B/M送信状況ワーク
rem =====================================
set callbat=bat\080.A11TK21.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 wk 店別B/M送信状況_商品ワーク
rem =====================================
set callbat=bat\080.A11TK10.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 wk 店別B/M送信状況_店舗ワーク
rem =====================================
set callbat=bat\080.A11TK11.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 店別B/M送信状況 削除
rem =====================================
set callbat=bat\080.TOKBMS.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 店別B/M送信状況 ロード
rem =====================================
set callbat=bat\080.TOKBMS.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 店別B/M送信状況_商品 削除
rem =====================================
set callbat=bat\080.TOKBMS_SHN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 店別B/M送信状況_商品 ロード
rem =====================================
set callbat=bat\080.TOKBMS_SHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 店別B/M送信状況_店舗 削除
rem =====================================
set callbat=bat\080.TOKBMS_TEN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 80 店別B/M送信状況_店舗 ロード
rem =====================================
set callbat=bat\080.TOKBMS_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

:SUCCESS
echo %DATE% %TIME% 処理が正常に終了しました >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% エラーが発生しました(RC=1) >> %outfile%
EXIT /B 1
