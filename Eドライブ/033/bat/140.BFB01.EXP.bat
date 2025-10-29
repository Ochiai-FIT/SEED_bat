REM [140][BFB01]
@ECHO OFF

REM ログフォルダ作成
IF NOT EXIST %~DP0..\logs MKDIR %~DP0..\logs

REM コマンドフォルダ作成
IF NOT EXIST %~DP0..\cmd MKDIR %~DP0..\cmd

REM ログファイルの情報
SET OUTFILE=%~DP0../logs/setup.log
SET OUTTIME=%~DP0../logs/time.log

REM ベースフォルダ
SET BASEDIR=%~DP0..

REM 更新対象の情報
SET INFOSCRIPT=%~DP0..\cmd\%~N0.DB2

SET OUTFILENAME=0140
SET EXPFILE=%~DP0../exp/%OUTFILENAME%
SET HULFTID=VFAUO001

REM ===== HULFT SEND DELETE ===============
SET HULFT=D:\HULFTFILES\SEND\%OUTFILENAME%
DEL /Q %HULFT%\*

SET MSG=%DATE% %TIME%  →  EXPORT処理(定量特売ファイル（全店特売）)
ECHO %MSG%
ECHO %MSG% >> %OUTFILE%
"%MYSQLPATH%mysql" %OPTION% -h %HOST% %DB_NAME% -u %USER_ID% -N -e "SELECT RPAD(SHOHNC, 8, ' ') || rpad(FILLER01, 6, ' ') || lpad(COALESCE(CAST(SYOKBN AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(BINK AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(NOKAIS AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(NOSYUR AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(HAKAIS AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(HASYUR AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(NNYNOB AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(NONYB AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(HACHBI AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(HACYB AS CHAR), ''), 1, '0') || lpad(COALESCE(replace (CAST(JZNGENKA AS CHAR), '.', ''), ''), 8, '0') || lpad(COALESCE(replace (CAST(TUIGENKA AS CHAR), '.', ''), ''), 8, '0') || lpad(COALESCE(replace (CAST(GENFU AS CHAR), '.', ''), ''), 8, '0') || lpad(COALESCE(replace (CAST(GENFUK AS CHAR), '.', ''), ''), 8, '0') || lpad(COALESCE(CAST(A_SOBAIFG AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(B_SOBAIFG AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(C_SOBAIFG AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(A_SOBAIFP AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(B_SOBAIFP AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(C_SOBAIFP AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(A_SOBAIFK AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(B_SOBAIFK AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(C_SOBAIFK AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(A_BAIKA_SOTO AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(B_BAIKA_SOTO AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(C_BAIKA_SOTO AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(HEKINP AS CHAR), ''), 5, '0') || lpad(COALESCE(CAST(MISIR AS CHAR), ''), 3, '0') || lpad(COALESCE(CAST(BD1SU AS CHAR), ''), 3, '0') || lpad(COALESCE(CAST(BD2SU AS CHAR), ''), 3, '0') || lpad(COALESCE(CAST(A_BDBAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(A_BD1BAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(A_BD2BAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(B_BDBAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(B_BD1BAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(B_BD2BAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(C_BDBAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(C_BD1BAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(C_BD2BAIKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(SIIRCD AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(NENMAT AS CHAR), ''), 1, '0') || lpad(TEISEK, 1, ' ') || lpad(COALESCE(CAST(TRTEISEK AS CHAR), ''), 1, ' ') || lpad(COALESCE(CAST(TTKBN AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(KZKBN AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(TEFTEI AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(BETUDEN AS CHAR), ''), 1, '0') || lpad(WAPENK, 1, ' ') || lpad(IKKATK, 1, ' ') || lpad(COALESCE(CAST(JIZNUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(SIDENF AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(TEICUTK AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(HOUZAI AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(DSEIK AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(PCKBN AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(HIGAWAK AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(HGEBATFL AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(REDMYFL AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(DATAK AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(SEISUR AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(HENSUR AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(SEITK AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(NONSJ AS CHAR), ''), 2, '0') || lpad(COALESCE(CAST(ATARA AS CHAR), ''), 1, '0') || lpad(RDHMHYO, 1, ' ') || lpad(RDHMMON, 1, ' ') || lpad(RDHMTUE, 1, ' ') || lpad(RDHMWED, 1, ' ') || lpad(RDHMTHU, 1, ' ') || lpad(RDHMFRI, 1, ' ') || lpad(RDHMSAT, 1, ' ') || lpad(RDHMSUN, 1, ' ') || lpad(COALESCE(CAST(NONSU AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(BUNBMC1 AS CHAR), ''), 3, '0') || lpad(COALESCE(CAST(BUNDIC AS CHAR), ''), 2, '0') || lpad(COALESCE(CAST(BUNCHC AS CHAR), ''), 2, '0') || lpad(COALESCE(CAST(BUNSHC AS CHAR), ''), 2, '0') || lpad(COALESCE(CAST(BUNSSC AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(MSSIRE AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(MSIR AS CHAR), ''), 3, '0') || lpad(MSIKK, 1, ' ') || lpad(MSWAP, 1, ' ') || lpad(COALESCE(CAST(MSBIN AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(MOYOK AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(MOYOKA AS CHAR), ''), 6, '0') || lpad(COALESCE(CAST(MOYORE AS CHAR), ''), 3, '0') || lpad(COALESCE(CAST(BUNBMC2 AS CHAR), ''), 3, '0') || lpad(COALESCE(CAST(KANBAN AS CHAR), ''), 4, '0') || lpad(COALESCE(CAST(EDABAN AS CHAR), ''), 2, '0') || lpad(COALESCE(CAST(SHUNO AS CHAR), ''), 4, '0') || lpad(COALESCE(CAST(SMISECD AS CHAR), ''), 3, '0') || lpad(COALESCE(CAST(KZCUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(KOUCUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(TEICUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(TOKCUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(KYUCUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(HACCUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(NONCUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(HSSCUT AS CHAR), ''), 1, '0') || lpad(COALESCE(CAST(ZERO AS CHAR), ''), 1, '0') || lpad(FILLER02, 1, ' ') || lpad(COALESCE(CAST(SYORIK AS CHAR), ''), 2, '0') || rpad(COALESCE(TOKCOME, ''), 30, '　') || rpad(COALESCE(KIKMKJ, ''), 23, '　') || rpad(COALESCE(SANTIMKJ, ''), 20, '　') || lpad(COALESCE(CAST(JIZNB AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(JZHCB AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(JZHCSUB AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(SIHCSYB AS CHAR), ''), 8, '0') || lpad(COALESCE(CAST(TTENRANK AS CHAR), ''), 3, '0') || lpad(COALESCE(CAST(MSF_TBL AS CHAR), ''), 2800, '0') || lpad(KZKUBETU, 1, ' ') || lpad(SYUFLG, 1, ' ') || lpad(HYSYUFLG, 1, ' ') || lpad(JZNLSKSKB, 1, ' ') || lpad(ANKUMUKB, 1, ' ') || lpad(FILLER03, 1, ' ') || lpad(COALESCE(CAST(SAKSEIB AS CHAR), ''), 8, '0') FROM INAWK.BFB01_Z A ORDER BY MOYOK, MOYOKA, MOYORE, BUNBMC2, KANBAN, EDABAN, NNYNOB, HAKAIS, HASYUR, SHOHNC;">%EXPFILE% 2>>%OUTFILE%
IF NOT %ERRORLEVEL%==0 GOTO ERROR

REM ===== HULFT SEND MOVE =================
ROBOCOPY %~dp0..\EXP %HULFT% %OUTFILENAME% /R:0 /NFL /NP >> %OUTFILE%

REM ===== HULFT SEND =======================
rem call %~dp0..\..\HULFT\.start_HULFT_SEND.bat %HULFTID% %OUTFILENAME%

:FINAL
EXIT /B 0

:ERROR
EXIT /B 1
