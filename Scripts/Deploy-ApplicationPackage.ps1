$msdeploy = "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"

$source = $args[0]
$destination = $args[1]
$recycleApp = $args[2]
$computerName = $args[3]
$username = $args[4]
$password = $args[5]
$delete = $args | Where-Object { $args.IndexOf($_) -eq 6 } | Select-Object -First 1
$skipDirectory = $args | Where-Object { $args.IndexOf($_) -eq 7 } | Select-Object -First 1
$skipFilesInput = $args | Where-Object { $args.IndexOf($_) -eq 8 } | Select-Object -First 1
$skipPatternsInput = $args | Where-Object { $args.IndexOf($_) -eq 9 } | Select-Object -First 1

$computerNameArgument = "$computerName/MsDeploy.axd?site=$recycleApp"

$directory = Split-Path -Path (Get-Location) -Parent
$baseName = (Get-Item $directory).BaseName
$contentPath = Join-Path (Join-Path $directory $baseName) $source

$targetPath = "$recycleApp$destination"

[System.Collections.ArrayList]$msdeployArguments = 
    "-verb:sync",
    "-allowUntrusted",
    "-source:contentPath=$contentPath",
    ("-dest:" + 
      "contentPath=${targetPath}," +
      "computerName=${computerNameArgument}," + 
      "username=${username}," +
      "password=${password}," +
      "AuthType='Basic'"
    )

if ($delete -NotMatch "true") {
  $msdeployArguments.Add("-enableRule:DoNotDeleteRule")
}

if ($skipDirectory) {
  $msdeployArguments.Add("-skip:Directory=$skipDirectory")
}

if ($skipFilesInput) {
  $skipFiles = $skipFilesInput -split ","
  foreach ($file in $skipFiles) {
    $msdeployArguments.Add("-skip:File=$file")
  }
}

if ($skipPatternsInput) {
  $skipPatterns = $skipPatternsInput -split ","
  foreach ($pattern in $skipPatterns) {
    $msdeployArguments.Add("-skip:regexPattern=$pattern")
  }
}

& $msdeploy $msdeployArguments