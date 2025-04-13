$msdeploy = "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"

$source = $args[0]
$destination = $args[1]
$recycleApp = $args[2]
$computerName = $args[3]
$username = $args[4]
$password = $args[5]
$deleteTarget = $args | Where-Object { $args.IndexOf($_) -eq 6 } | Select-Object -First 1
$skipDirectoriesInput = $args | Where-Object { $args.IndexOf($_) -eq 7 } | Select-Object -First 1
$skipFilesInput = $args | Where-Object { $args.IndexOf($_) -eq 8 } | Select-Object -First 1
$skipPatternsInput = $args | Where-Object { $args.IndexOf($_) -eq 9 } | Select-Object -First 1

Write-Host "------------------------------------"
Write-Host "Starting deployment with parameters:"
Write-Host "Source:               $source"
Write-Host "Destination:          $destination"
Write-Host "Recycle App:          $recycleApp"
Write-Host "Computer Name:        $computerName"
Write-Host "Delete target:        $deleteTarget"
Write-Host "Skip Directories:     $skipDirectoriesInput"
Write-Host "Skip Files:           $skipFilesInput"
Write-Host "Skip Regex Patterns:  $skipPatternsInput"
Write-Host "------------------------------------"

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

if ($deleteTarget -NotMatch "true") {
  $msdeployArguments.Add("-enableRule:DoNotDeleteRule")
}

if ($skipDirectoriesInput) {
  $skipDirs = $skipDirectoriesInput -split ","
  foreach ($dir in $skipDirs) {
    $msdeployArguments.Add("-skip:Directory=$dir")
  }
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