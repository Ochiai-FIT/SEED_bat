
Param(
  [System.string]$ShellName # バッチ名
)

$logfile="process.log"
$pidfile="pid.txt"
$return=0
$now=Get-Date -format "yyyy/MM/dd HH:mm:ss"
Write-Output ($now+" 開始します("+$pid+")") | out-file $logfile Default -append

$filepid = 0
$runspid = -1
if (Test-Path $pidfile) {
    $filepid = Get-Content -Path $pidfile
    Write-Output ($now+" 確認するPID："+$filepid+"") | out-file $logfile  Default -append
    $runspid = Get-WmiObject win32_process -filter processid=$filepid | Select -ExpandProperty ProcessId
    Write-Output ($now+" 実行結果："+$runspid+"") | out-file $logfile  Default -append
}

if($filepid -eq $runspid){

    Write-Output ($now+" 実行中...終了します("+$filepid+")") | out-file $logfile Default -append
    $return=1

}else{

    Write-Output ($now+" 非実行("+$pid+")") | out-file $logfile  Default -append
    $teraWait = Start-Process -FilePath $ShellName -PassThru
    Write-Output $teraWait.id | out-file $pidfile  Default
    echo $teraWait.id

    Write-Output ($now+" 実行中("+$pid+")") | out-file $logfile  Default -append
    Wait-Process -Id ($teraWait.id)
    $return=$teraWait.ExitCode
    $now=Get-Date -format "yyyy/MM/dd HH:mm:ss"
    Write-Output ($now+" 終了しました("+$pid+")") | out-file $logfile  Default -append
    Remove-Item $pidfile

}
exit $return

