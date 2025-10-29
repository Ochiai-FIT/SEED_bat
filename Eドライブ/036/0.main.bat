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

rem ===== 035 商品削除 ======================
set callbat=bat\035.DELETE.bat
>> %outfile% echo %callbat%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 036 処理日付+1更新 ================
set callbat=bat\036.UPDATE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 036 処理日付+1更新 特売バッチ用 ===
set callbat=bat\036.SYSBATCHDT_TK.MERGE.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 039 商品登録限度数リセット ========
set callbat=bat\039.UPDATE.bat
>> %outfile% echo %callbat%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 037 商品予約反映 ==================
set callbat=bat\037.UPDATE.bat
>> %outfile% echo %callbat%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ===== 038 商品予約削除 ==================
set callbat=bat\038.DELETE.bat
>> %outfile% echo %callbat%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 他で使用しないＷＫの場合、１つのバッチ内に記載


:SUCCESS
echo %DATE% %TIME% 処理が正常に終了しました >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% エラーが発生しました(RC=1) >> %outfile%
EXIT /B 1
