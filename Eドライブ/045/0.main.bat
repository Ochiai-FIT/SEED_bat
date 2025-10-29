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
rem 197 人事基本テーブル
rem =====================================
set callbat=bat\197.sysJINJIKIHON.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 198 所属
rem =====================================
set callbat=bat\198.sysSZK.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 199 部門マスタ
rem =====================================
set callbat=bat\199.mstBMN.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 200 大分類マスタ
rem =====================================
set callbat=bat\200.mstDAIBRUI.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 201 中分類マスタ
rem =====================================
set callbat=bat\201.mstCHUBRUI.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 202 店舗基本マスタ
rem =====================================
set callbat=bat\202.mstTEN.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 203 商品マスタ
rem =====================================
set callbat=bat\203.mstSHN.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 204 ソースコード管理マスタ
rem =====================================
set callbat=bat\204.mstSRCCD.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 205 催しコード
rem =====================================
set callbat=bat\205.tokMOYCD.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 206 生活応援_商品
rem =====================================
set callbat=bat\206.tokSO_SHN.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error
:JUMP
rem =====================================
rem 207 税率マスタ
rem =====================================
set callbat=bat\207.mstZEIRT.EXP.bat
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
echo %DATE% %TIME% 日次処理(Daily)が正常に終了しました >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% エラーが発生しました(RC=1) >> %outfile%
EXIT /B 1
