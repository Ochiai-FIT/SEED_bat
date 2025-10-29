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
rem 催し送信回答用販売データ作成
rem =====================================
set callbat=bat\000.MS_HANBAI_EVS.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem B/M 催し送信回答用販売データ作成
rem =====================================
set callbat=bat\000.MS_HANBAI_BMS.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 生活応援販売データ_WK作成
rem =====================================
set callbat=bat\000.SO_HANBAI_WK.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 生活応援販売データ作成
rem =====================================
set callbat=bat\000.SO_HANBAI.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全店特売アンケート無 販売データ作成
rem =====================================
set callbat=bat\000.AN_HANBAI_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 店舗単位 納入日(ア無)
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全店特売アンケート無 納入データ作成
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 中間納入日(ア無全割)
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_NEQ_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全品割引納入データ作成
rem =====================================
set callbat=bat\000.AN_ZW_NOUNYU_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全店特売アンケート有 販売データ(反映前)作成
rem =====================================
set callbat=bat\000.AN_HANBAI_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 中間納入日(ア有反映前)
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全店特売アンケート有 納入データ(反映前)作成 新規分
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_NEW.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全店特売アンケート有 納入データ(反映前)作成 更新分
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_UPD.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 全店特売アンケート有 納入データ(反映前)作成 変更無分
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_PRE.LOAD.bat
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
rem 事前発注数量訂正（翌日用）
rem =====================================
rem WH30-1,2を行い、事前発注_店舗(A11TC26)、事前発注_追加商品(A11J04)をWKに準備
set callbat=bat\148.JH_RTN_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

set callbat=bat\149.JH_RTN_ADDSHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

set callbat=bat\000.JH_TEN_SYUSEI_KARIJIME.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 事前発注_発注数量取込中間キー(ア有)
rem =====================================
set callbat=bat\000.JH_HSUU_KEY_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 事前発注_発注数量取込中間キー(ア無)
rem =====================================
set callbat=bat\000.JH_HSUU_KEY_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 事前発注_発注数量取込中間キー
rem =====================================
set callbat=bat\000.JH_HSUU_KEY.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込み 特売エラーファイル(ア有)
rem =====================================
set callbat=bat\000.JH_TOK_ERR_BFR1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込み 特売エラーファイル(ア無)
rem =====================================
set callbat=bat\000.JH_TOK_ERR_NEQ1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込み(ア有)
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_HSUU.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込み(ア無)
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_HSUU.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込日更新(ア有)
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_JHTSUINDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込日更新(ア無)
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_JHTSUINDT.MRG.bat
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
rem 100 催しコード
rem =====================================
set callbat=bat\100.BFC01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 101 ランクマスタ
rem =====================================
set callbat=bat\101.BFC05.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 102 数量パターンマスタ
rem =====================================
set callbat=bat\102.BFC06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 103 数量ランクマスタ
rem =====================================
set callbat=bat\103.BFC07.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 104 通常率パターンマスタ
rem =====================================
set callbat=bat\104.BFC08.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 105 チラシのみ部門
rem =====================================
set callbat=bat\105.BFC41.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 668 完了通知
rem =====================================
set callbat=bat\668.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 107 全特アンケート有基本
rem =====================================
set callbat=bat\107.BFC02.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 106 全特アンケート有商品
rem =====================================
set callbat=bat\106.BFC03.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 669 完了通知
rem =====================================
set callbat=bat\669.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 108 全特アンケート無商品
rem =====================================
set callbat=bat\108.BFC04.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 670 完了通知
rem =====================================
set callbat=bat\670.完了通知.EXP.bat
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
rem 658 完了通知
rem =====================================
set callbat=bat\658.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 119 冷凍食品＿企画
rem =====================================
set callbat=bat\119.BFC22.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 120 冷凍食品＿商品
rem =====================================
set callbat=bat\120.BFC23.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 140 定量特売ファイル　（全店特売）
rem =====================================
rem 展開用冷凍食品(A11.F860I)
set callbat=bat\140.TMWK_A11TC34.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 対象販売データ(ア有)
set callbat=bat\140.ANWK12_HAN_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 対象販売データ(ア無)
set callbat=bat\140.ANWK12_HAN_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 対象納入データ(ア有)
set callbat=bat\140.ANWK12_NOU_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 対象納入データ(ア無)
set callbat=bat\140.ANWK12_NOU_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 全特アンケート有 販売データ(反映後)WK1 ※定量特売納入日データ(ア有)用
set callbat=bat\000.AN_HANBAI_AFT_WK1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 定量特売納入日データ(ア有)
set callbat=bat\140.ANWK13_TC18_A.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem 全特アンケート無 販売データWK1 ※定量特売納入日データ(ア無)用
set callbat=bat\000.AN_HANBAI_NEQ_WK1.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 定量特売納入日データ(ア無)
set callbat=bat\140.ANWK13_TC18_N.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem 定量特売納入日データ(ア有)2
set callbat=bat\140.ANWK13_TC18_A2.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem 定量特売納入日データ(ア無)2
set callbat=bat\140.ANWK13_TC18_N2.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem 定量特売納入日データ(中間ワーク)(ア有)
set callbat=bat\140.ANWK14_TN06_A.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem 定量特売納入日データ(中間ワーク)(ア無)
set callbat=bat\140.ANWK14_TN06_N.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem 定量特売納入日データ(冷食展開)(ア有)
set callbat=bat\140.ANWK14_TN06R_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 定量特売納入日データ(冷食展開)(ア無)
set callbat=bat\140.ANWK14_TN06R_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 定量特売ファイル（全店特売）
set callbat=bat\140.BFB01_Z.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  < %~dp0%callbat% >> %outfile%
if errorlevel 1 goto error

rem export
set callbat=bat\140.BFB01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 654 完了通知
rem =====================================
set callbat=bat\654.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 109 正規定量＿商品
rem =====================================
set callbat=bat\109.BFC13.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 110 正規定量＿店別数量
rem =====================================
set callbat=bat\110.BFC14.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 112 次週定量＿店別数量
rem =====================================
set callbat=bat\112.BFC16.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 662 完了通知
rem =====================================
set callbat=bat\662.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 144 催し送信　（ＰＬＵ）
rem =====================================
rem 展開用冷凍食品(A11.F858I)
set callbat=bat\144.TMWK_A11TC34.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 変更分全特有催しコード
set callbat=bat\144.TMWK_A11TC01_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 変更分全特無催しコード
set callbat=bat\144.TMWK_A11TC01_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 変更分生活応援催しコード
set callbat=bat\144.TMWK_A11TC01_S.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 回答用販売データ_冷食展開(ア有)
set callbat=bat\144.TMWK40_A11TC13_A.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 回答用販売データ_冷食展開(ア無)
set callbat=bat\144.TMWK40_A11TC13_N.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 全特ア無 回答用販売データ_催し付加
set callbat=bat\144.TMWK41_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 全特ア有 回答用販売データ_催し付加
set callbat=bat\144.TMWK42_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 生活応援 回答用販売データ_催し付加
set callbat=bat\144.TMWK44_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 催し送信 回答用販売データ_催し付加
set callbat=bat\144.TMWK48_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem ＢＭ催し送信 回答用販売データ_催し付加
set callbat=bat\144.TMWK49_A11TC05.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


rem 全特ア無 回答用販売データ_10日分
set callbat=bat\144.TMWK41_A11TC05_01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 全特ア有 回答用販売データ_10日分
set callbat=bat\144.TMWK42_A11TC05_01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 催し送信 回答用販売データ_10日分
set callbat=bat\144.TMWK48_A11TC05_01.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 回答用販売データ_OUEN
set callbat=bat\144.TMWK41_A11TC05_OUEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\144.BFG01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 145 催し送信　（Ｂ／Ｍ）
rem =====================================
rem export
set callbat=bat\145.BFG01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 677 完了通知
rem =====================================
set callbat=bat\677.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 124 新店改装店発注＿発注
rem =====================================
set callbat=bat\124.BFC33.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 125 新店改装店発注＿商品
rem =====================================
set callbat=bat\125.BFC34.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 121 分類割引＿企画
rem =====================================
set callbat=bat\121.BFC24.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 122 分類割引＿対象除外店
rem =====================================
set callbat=bat\122.BFC25.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 123 事前打出＿商品
rem =====================================
set callbat=bat\123.BFC26.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 672 完了通知
rem =====================================
set callbat=bat\672.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 146 催し送信　（分類分割）
rem =====================================
rem =====
set callbat=bat\146.A11TN11.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 678 完了通知
rem =====================================
set callbat=bat\678.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


rem =====================================
rem 処理後ア無納入情報を退避
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_PRE.LOAD.bat
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
