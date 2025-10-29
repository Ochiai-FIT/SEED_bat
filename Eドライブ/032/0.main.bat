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
ROBOCOPY  D:\HULFTFILES\RCV\0189 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0190 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0191 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0192 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0193 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%

REM ===== BACKUP COPY ====================
setlocal
set x=%~dp0
set x=%x:~0,-1%
for /F "delims=" %%a in ('echo "%x%"') do set DIRNAME=%%~na
ROBOCOPY %~dp0DATA E:\MDM\%DIRNAME%\%ltime% /R:0 /E /NFL /NP /XD backup bkup RcvTemp >> %outfile%
endlocal

rem =====================================
rem 189 事前発注
rem =====================================
set callbat=bat\189.BFI01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 189 事前発注 マージ
rem =====================================
set callbat=bat\189.TOKTJ.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 事前発注＿商品
rem =====================================
set callbat=bat\190.BFI02.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 事前発注＿商品 削除
rem =====================================
set callbat=bat\190.TOKTJ_SHN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 事前発注＿商品 マージ
rem =====================================
set callbat=bat\190.TOKTJ_SHN.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 事前発注_店舗 削除
rem =====================================
set callbat=bat\190.TOKTJ_TEN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 190 事前発注_追加商品 削除
rem =====================================
set callbat=bat\190.TOKTJ_ADDSHN.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 191 事前発注＿店舗
rem =====================================
set callbat=bat\191.BFI03.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 191 事前発注＿店舗 マージ
rem =====================================
set callbat=bat\191.TOKTJ_TEN.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 192 事前発注＿平均パック単価
rem =====================================
set callbat=bat\192.BFI04.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 192 事前発注＿平均パック単価 削除
rem =====================================
set callbat=bat\192.TOKTJ_AVGPTANKA.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 192 事前発注＿平均パック単価 マージ
rem =====================================
set callbat=bat\192.TOKTJ_AVGPTANKA.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 アンケート結果作成キー
rem =====================================
set callbat=bat\000.AN_CRE_KEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 アンケート結果_店グループ反映レコードロード
rem =====================================
set callbat=bat\000.AN_QATENGP_DIFF.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 アンケート結果_店舗反映分レコードロード
rem =====================================
set callbat=bat\000.AN_QATEN_DIFF.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 アンケート結果_商品反映分レコードロード
rem =====================================
set callbat=bat\000.AN_QASHN_DIFF.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 INATK2 アンケート結果_店グループ マージ
rem =====================================
set callbat=bat\000.TOKTG_QAGP_INATK2.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 INATK2 アンケート結果_店舗 マージ
rem =====================================
set callbat=bat\000.TOKTG_QATEN_INATK2.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 INATK2 アンケート結果_商品 マージ
rem =====================================
set callbat=bat\000.TOKTG_QASHN_INATK2.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 アンケート再作成日クリア
rem =====================================
set callbat=bat\000.TOKTG_KHN_QADT_CLEAR.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果作成 アンケート再作成日強制クリア
rem =====================================
set callbat=bat\000.TOKTG_TENGP_QADT_CLEAR.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全店特売(ｱﾝｹｰﾄ有)_商品対象店舗作成
rem =====================================
set callbat=bat\000.ANWK_A11TC44.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果反映(販売情報)
rem =====================================
rem 販売データ(ア有)作成
set callbat=bat\000.AN_HANBAI_AFT.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem P230:販売日スライド実施
set callbat=bat\000.AN_HANBAI_DT.LOAD.AFT.DEL.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 中間納入日(ア有反映後)
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果反映(納入情報) 対象
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_TRG.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果反映(納入情報) 対象外1
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_NOTRG1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果反映(納入情報) 対象外2
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_NOTRG2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 中間納入日(ア有全割反映前)
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_BFR_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート結果(全品割引納入データ)
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 中間納入日(ア有全割反映後)
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_AFT_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全特アンケート有 納入データ 全品割引(反映後) 対象
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_AFT_TRG.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全特アンケート有 納入データ 全品割引(反映後) 対象外
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_AFT_NOTRG.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全特アンケート有 納入データ 全品割引(反映後) 事前発注
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_AFT_JZEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 131 予約発注_企画
rem =====================================
set callbat=bat\131.BFC29.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 128 予約発注＿商品
rem =====================================
set callbat=bat\128.BFC30.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 129 予約発注＿納入日
rem =====================================
set callbat=bat\129.BFC31.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 130 予約発注＿店舗
rem =====================================
set callbat=bat\130.BFC32.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 116 生活応援＿商品
rem =====================================
set callbat=bat\116.BFC19.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 115 生活応援＿部門
rem =====================================
set callbat=bat\115.BFC18.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 659 完了通知
rem =====================================
set callbat=bat\659.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 127 アンケート付き送りつけ＿商品
rem =====================================
set callbat=bat\127.BFC28.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 126 アンケート付き送りつけ＿催し
rem =====================================
set callbat=bat\126.BFC27.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 142 定量特売ファイル　（事前打出）
rem =====================================
rem 定量特売ファイル(事前打出)
set callbat=bat\142.BFB01_J.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\142.BFB01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 674 完了通知
rem =====================================
set callbat=bat\674.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 147 新改装店発注データ
rem =====================================
rem 新店改装店発注
set callbat=bat\147.THWK01_A10TSKD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\147.A10TSKD.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 673 完了通知
rem =====================================
set callbat=bat\673.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem DM84 全店特売(アンケート有)-販売送信
rem =====================================
rem データ作成
set callbat=bat\000.AN_TOKTG_HB.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%OUTFILE% 2>&1
if errorlevel 1 goto error

rem 反映
set callbat=bat\000.TOKTG_HB.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem DM85 全店特売(アンケート有)-納入送信
rem =====================================
rem データ作成
set callbat=bat\000.AN_TOKTG_NNDT.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%OUTFILE% 2>&1
if errorlevel 1 goto error

rem 反映
set callbat=bat\000.TOKTG_NNDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 193 INAIN 事前発注対象日付ファイル
rem =====================================
set callbat=bat\193.BFB00.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 193 INAIF 事前発注対象日付
rem =====================================
set callbat=bat\193.JH_DATE.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注リスト出力日設定 事前発注リスト出力日反映差分(ア有)
rem =====================================
set callbat=bat\000.JH_LIST_DIFF_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注リスト出力日設定 全特アンケート有 納入データ(反映前)更新
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_JLSTCREDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注リスト出力日設定 全店特売(アンケート有)_商品更新 
rem =====================================
set callbat=bat\000.TOKTG_SHN_JLSTCREDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注リスト出力日設定 全店特売（アンケート有）_基本更新
rem =====================================
set callbat=bat\000.TOKTG_KHN_JLSTCREFLG.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注リスト出力日設定 事前発注リスト出力日反映差分(ア無)
rem =====================================
set callbat=bat\000.JH_LIST_DIFF_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注リスト出力日設定 全特アンケート無 納入データ更新
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_JLSTCREDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注リスト出力日設定 全店特売(アンケート無)_商品更新
rem =====================================
set callbat=bat\000.TOKSP_SHN_JLSTCREDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem アンケート有納入情報作成 DM97
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_HSUU.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 処理後ア有納入情報を退避
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
echo %DATE% %TIME% 処理が正常に終了しました >> %outfile%

:LAST
EXIT /B 0

:ERROR
ECHO %DATE% %TIME% %callbat% エラーが発生しました(RC=1) >> %outfile%
EXIT /B 1
