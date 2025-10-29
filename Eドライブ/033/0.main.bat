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
ROBOCOPY  D:\HULFTFILES\RCV\0194 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%
ROBOCOPY  D:\HULFTFILES\RCV\0195 %~dp0DATA /R:0 /E /NFL /NP /XD backup bkup RcvTemp /MOV >> %OUTFILE%

REM ===== BACKUP COPY ====================
setlocal
set x=%~dp0
set x=%x:~0,-1%
for /F "delims=" %%a in ('echo "%x%"') do set DIRNAME=%%~na
ROBOCOPY %~dp0DATA E:\MDM\%DIRNAME%\%ltime% /R:0 /E /NFL /NP /XD backup bkup RcvTemp >> %outfile%
endlocal

rem =====================================
rem 194 INAIN 事前発注数量入力締め日付ファイル
rem =====================================
set callbat=bat\194.BFB00_SHIME.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 194 INAIF 事前発注数量入力締め日付
rem =====================================
set callbat=bat\194.JH_SHIME_DATE.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 148 事前発注＿店舗（戻り用）
rem =====================================
set callbat=bat\148.JH_RTN_TEN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\148.BFI07.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 149 事前発注＿追加商品（戻り用）
rem =====================================
set callbat=bat\149.JH_RTN_ADDSHN.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem export
set callbat=bat\149.BFI06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 675 完了通知
rem =====================================
set callbat=bat\675.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 150 店舗修正データ(本締め)
rem =====================================
set callbat=bat\150.JH_TEN_SYUSEI.HONJIME.LOAD.bat
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
set callbat=bat\000.JH_TOK_ERR_HSUU.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 150 店数量反映エラーデータ(生鮮)
rem =====================================
set callbat=bat\150.A11TC30_S.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 150 店数量反映エラーデータ(ドライ)
rem =====================================
set callbat=bat\150.A11TC30_D.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 676 完了通知
rem =====================================
set callbat=bat\676.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem WH32-3 P480 納入情報更新 (抽出済納入情報A11.NOUNYU.AFT@])
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_HSUU.MRG.P480.bat
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
rem 事前発注数量取込み 全店特売(アンケート有)_商品更新 DM34-2
rem =====================================
set callbat=bat\000.TOKTG_SHN_JHTSUINDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込み 全店特売(アンケート無)_商品更新 DM34-3
rem =====================================
set callbat=bat\000.TOKSP_SHN_JHTSUINDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込み 全店特売(アンケート有)_納入日更新
rem =====================================
rem データ作成
set callbat=bat\000.JH_TOKTG_NNDT.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat%  >>%outfile% 2>&1
if errorlevel 1 goto error

rem 反映(INATK) 
set callbat=bat\000.TOKTG_NNDT_INATK.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 事前発注数量取込み 全店特売(アンケート無)_納入日更新
rem =====================================
rem データ作成
set callbat=bat\000.JH_TOKSP_NNDT.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat%  >>%outfile% 2>&1
if errorlevel 1 goto error

rem 反映(INATK2)
set callbat=bat\000.TOKSP_NNDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem 反映(INATK) 
set callbat=bat\000.TOKSP_NNDT_INATK.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error


REM 【重要】平行稼働用の暫定対応(INATK2.HATTR_CSVが無いため平行稼働期間はCRIPS.A11T508からINATK2.HATTR_CSVを作成)
rem =====================================
rem 000 店別定量_CSV 作成　※
rem =====================================
set callbat=bat\000.HATTR_CSV.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 定量変更データ 作成 ※火曜のみ登録、他削除
rem =====================================
set callbat=bat\000.A11T508.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 定量変更データ取込み 正規定量＿店別数量
rem =====================================
set callbat=bat\000.HATSTR_TEN_INATK2.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 定量変更データ取込み 次週定量＿店別数量(追加)
rem =====================================
set callbat=bat\000.HATJTR_TEN_INATK2.INS.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 195 事前発注済情報(JH_SUMIで読み込み)
rem =====================================
set callbat=bat\195.BFB11.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 事前発注済情報
rem =====================================
set callbat=bat\000.JH_SUMI.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 週間発注処理日反映差分(ア有)
rem =====================================
set callbat=bat\000.JH_WEEKHTDT_DIFF_BFR.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 特売エラーファイル(ア有)
rem =====================================
set callbat=bat\000.JH_TOK_ERR_BFR2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 全特アンケート有 納入データ(反映前)更新
rem =====================================
set callbat=bat\000.AN_NOUNYU_BFR_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 全店特売(アンケート有)_納入日更新 WH42-3
rem =====================================
set callbat=bat\000.TOKTG_NNDT_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 全店特売(アンケート有)_商品更新 WH42-4
rem =====================================
set callbat=bat\000.TOKTG_SHN_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 週間発注処理日反映差分(ア無)
rem =====================================
set callbat=bat\000.JH_WEEKHTDT_DIFF_NEQ.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 特売エラーファイル(ア無)
rem =====================================
set callbat=bat\000.JH_TOK_ERR_NEQ2.LOAD.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 全特アンケート無 納入データ更新
rem =====================================
set callbat=bat\000.AN_NOUNYU_NEQ_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 全店特売(アンケート無)_納入日更新 WH42-3
rem =====================================
set callbat=bat\000.TOKSP_NNDT_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 週間発注処理日取込み 全店特売(アンケート無)_商品更新 WH42-4
rem =====================================
set callbat=bat\000.TOKSP_SHN_WEEKHTDT.MRG.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 処理前ア有納入情報を退避
rem =====================================
set callbat=bat\000.AN_NOUNYU_AFT_PRE.LOAD.bat
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
rem 665 完了通知
rem =====================================
set callbat=bat\665.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 140 定量特売ファイル　（全店特売）
rem =====================================
rem 展開用冷凍食品
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
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv  <  %~dp0%callbat% >>%outfile% 2>&1
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
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv <  %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem 定量特売納入日データ(ア有)2
set callbat=bat\140.ANWK13_TC18_A2.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem 定量特売納入日データ(ア無)2
set callbat=bat\140.ANWK13_TC18_N2.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv <  %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem 定量特売納入日データ(中間ワーク)(ア有)
set callbat=bat\140.ANWK14_TN06_A.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv <   %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem 定量特売納入日データ(中間ワーク)(ア無)
set callbat=bat\140.ANWK14_TN06_N.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%outfile% 2>&1
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
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem export
set callbat=bat\140.BFB01.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 657 完了通知
rem =====================================
set callbat=bat\657.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 91 wk 回答用販売データ作成
rem =====================================
set callbat=bat\091.ANWK01_AF.LOAD.txt
echo %DATE% %TIME% %callbat%
echo %DATE% %TIME% %callbat% >> %outfile%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% --show-warnings -vv < %~dp0%callbat% >>%outfile% 2>&1
if errorlevel 1 goto error

rem =====================================
rem 91 全特アンケート有商品
rem =====================================
set callbat=bat\091.BFE05.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 90 全特アンケート有店舗
rem =====================================
set callbat=bat\090.BFE06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 93 全特アンケート無商品
rem =====================================
set callbat=bat\093.BFE05.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 92 全特アンケート無店舗
rem =====================================
set callbat=bat\092.BFE06.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 666 完了通知
rem =====================================
set callbat=bat\666.完了通知.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 96 各店アンケート
rem =====================================
set callbat=bat\096.BFF12.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 94 リーダー店アンケート
rem =====================================
set callbat=bat\094.BFF10.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 95 リーダー店アイテムアンケート
rem =====================================
set callbat=bat\095.BFF11.EXP.bat
echo %callbat% >> %outfile%
call %~dp0%callbat%
if errorlevel 1 goto error

rem =====================================
rem 000 ｱﾝｹｰﾄ系納入日中間データ保持(前日分)
rem =====================================
set callbat=bat\000.AN_NOUNYU_PRE.LOAD.bat
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
