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
rem 000 各予約マスタから反映済を削除
rem =====================================
set callbat=bat\000.YOYAKU.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 処理日付更新
rem =====================================
set callbat=bat\000.SYSBATCHDT.MERGE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 商品マスタ更新キーロード処理
rem =====================================
set callbat=bat\000.MSTSHN_UPDKEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 仕入先マスタ更新キーロード処理
rem =====================================
set callbat=bat\000.MSTSIR_UPDKEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 店舗基本マスタ更新キーロード処理
rem =====================================
set callbat=bat\000.MSTTEN_UPDKEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 463 ジャーナル_商品マスタ
rem =====================================
set callbat=bat\463.A11SHOJ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 464 ジャーナル_仕入グループ商品マスタ
rem =====================================
set callbat=bat\464.A11TGSHJ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 465 ジャーナル_売価コントロールマスタ
rem =====================================
set callbat=bat\465.A11BCMJ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 466 ジャーナル_ソースコード管理マスタ
rem =====================================
set callbat=bat\466.A11SRCJ.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 653 完了通知
rem =====================================
set callbat=bat\653.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 008 商品基本マスタ(予約)
rem =====================================
set callbat=bat\008.AEA81.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 商品マスタ_予約(前回処理結果)
set callbat=bat\008.MSTSHN_Y_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 009 仕入グループ商品(予約)
rem =====================================
set callbat=bat\009.AEA82.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 仕入グループ_予約(前回処理結果)
set callbat=bat\009.MSTSIRGPSHN_Y_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 010 売価コントロール(予約)
rem =====================================
set callbat=bat\010.AEA83.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 売価コントロール_予約(前回処理結果)
set callbat=bat\010.MSTBAIKACTL_Y_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 011 ソースコード管理(予約)
rem =====================================
set callbat=bat\011.AEA84.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ソースコード管理_予約(前回処理結果)
set callbat=bat\011.MSTSRCCD_Y_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 001 商品基本マスタ
rem =====================================
set callbat=bat\001.AEA81.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 商品マスタ(前回処理結果)
set callbat=bat\001.MSTSHN_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 002 仕入グループ商品
rem =====================================
set callbat=bat\002.AEA82.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 仕入グループ商品(前回処理結果)
set callbat=bat\002.MSTSIRGPSHN_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 003 売価コントロール
rem =====================================
set callbat=bat\003.AEA83.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 売価コントロール(前回処理結果)
set callbat=bat\003.MSTBAIKACTL_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 004 ソースコード管理
rem =====================================
set callbat=bat\004.AEA84.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ソースコード管理(前回処理結果))
set callbat=bat\004.MSTSRCCD_LT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem INAMS2予約マスタ→本マスタ反映
rem =====================================
set callbat=bat\000.UPDATE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


rem =====================================
rem 007 平均パック単価
rem =====================================
set callbat=bat\007.AIA59.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 026 商品店グループ
rem =====================================
set callbat=bat\026.AIA57.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 026 売価コントロール
rem =====================================
set callbat=bat\026.AEA83.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 026 売価コントロール(予約)
rem =====================================
set callbat=bat\026.AEA83_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 商品店グループ店舗
rem =====================================
set callbat=bat\027.AIA58.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 仕入グループ商品
rem =====================================
set callbat=bat\027.AEA82.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 仕入グループ商品(予約)
rem =====================================
set callbat=bat\027.AEA82_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 売価コントロール
rem =====================================
set callbat=bat\027.AEA83.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 027 売価コントロール(予約)
rem =====================================
set callbat=bat\027.AEA83_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 配送パターン
rem =====================================
set callbat=bat\037.AIC55.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 商品基本マスタ
rem =====================================
set callbat=bat\037.AEA81.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 商品基本マスタ(予約)
rem =====================================
set callbat=bat\037.AEA81_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 仕入グループ商品
rem =====================================
set callbat=bat\037.AEA82.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 037 仕入グループ商品(予約)
rem =====================================
set callbat=bat\037.AEA82_Y.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 038 エリア別配送パターン
rem =====================================
set callbat=bat\038.AIC56.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 629 完了通知
rem =====================================
set callbat=bat\629.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 66 プライスカードデータ要求データ（本部）
rem =====================================
set callbat=bat\066.AEP20.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


rem =====================================
rem 001 商品マスタ(前日処理結果)
rem =====================================
set callbat=bat\001.MSTSHN_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 002 仕入グループ商品(前日処理結果)
rem =====================================
set callbat=bat\002.MSTSIRGPSHN_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 003 売価コントロール(前日処理結果)
rem =====================================
set callbat=bat\003.MSTBAIKACTL_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 004 ソースコード管理(前日処理結果))
rem =====================================
set callbat=bat\004.MSTSRCCD_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 008 商品マスタ_予約(前日処理結果)
rem =====================================
set callbat=bat\008.MSTSHN_Y_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 009 仕入グループ商品_予約(前日処理結果)
rem =====================================
set callbat=bat\009.MSTSIRGPSHN_Y_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 010 売価コントロール_予約(前日処理結果)
rem =====================================
set callbat=bat\010.MSTBAIKACTL_Y_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 011 ソースコード管理_予約(前日処理結果))
rem =====================================
set callbat=bat\011.MSTSRCCD_Y_PD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 エリア別配送パターンマスタ(前日分)
rem =====================================
set callbat=bat\151.MSTAREAHSPTN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 エリア別配送パターン仕入先マスタ(前日分)
rem =====================================
set callbat=bat\151.MSTAREAHSPTNSIR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 配送パターンマスタ(前日分)
rem =====================================
set callbat=bat\151.MSTHSPTN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 配送パターン仕入先マスタ(前日分)
rem =====================================
set callbat=bat\151.MSTHSPTNSIR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 商品マスタ(前日分)
rem =====================================
set callbat=bat\151.MSTSHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 商品マスタ_予約(前日分)
rem =====================================
set callbat=bat\151.MSTSHN_Y.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 仕入先マスタ(前日分)
rem =====================================
set callbat=bat\151.MSTSIR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 仕入グループ商品マスタ(前日分)
rem =====================================
set callbat=bat\151.MSTSIRGPSHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 151 仕入グループ商品マスタ_予約(前日分)
rem =====================================
set callbat=bat\151.MSTSIRGPSHN_Y.LOAD.bat
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
