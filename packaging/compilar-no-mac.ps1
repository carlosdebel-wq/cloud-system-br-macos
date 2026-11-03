param([ValidateSet('arm64','intel')][string]$Architecture = 'arm64')
$ErrorActionPreference='Stop'
if (-not $IsMacOS) { throw 'Esta compilacao requer um Mac; o Windows apenas prepara os arquivos.' }
$projectRoot=(Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$source=Join-Path $projectRoot 'source'
$env:CRAFT_TARGET=if($Architecture -eq 'arm64'){'macos-clang-arm64'}else{'macos-64-clang'}
$machine=(& uname -m).Trim()
if(($Architecture -eq 'arm64' -and $machine -ne 'arm64') -or ($Architecture -eq 'intel' -and $machine -ne 'x86_64')){throw 'Use um Mac da arquitetura selecionada; compilacao cruzada nao homologada.'}
$env:SIGN_PACKAGE='False'
$env:SYSTEMBR_PYTHON=(Get-Command python3 -ErrorAction Stop).Source
& xcode-select -p
if($LASTEXITCODE -ne 0){throw 'Instale as ferramentas Xcode/Command Line Tools no Mac.'}
$master=Join-Path $HOME 'craft/CraftMaster/CraftMaster'
$masterRevision='8a19d8fcab223b8b27126d98a46ed824b5948665'
if(-not(Test-Path -LiteralPath (Join-Path $master 'CraftMaster.py'))){
    New-Item -ItemType Directory -Force -Path $master | Out-Null
    & git -C $master init
    if($LASTEXITCODE -ne 0){throw 'Falha ao iniciar a pasta isolada do CraftMaster'}
    & git -C $master remote add origin https://invent.kde.org/kde/craftmaster.git
    if($LASTEXITCODE -ne 0){throw 'Falha ao configurar origem oficial do CraftMaster'}
    & git -C $master fetch --depth=1 origin $masterRevision
    if($LASTEXITCODE -ne 0){throw 'Falha ao obter revisao fixada do CraftMaster'}
    & git -C $master checkout --detach FETCH_HEAD
    if($LASTEXITCODE -ne 0){throw 'Falha ao selecionar revisao do CraftMaster'}
}
$actualRevision=(& git -C $master rev-parse HEAD).Trim()
if($actualRevision -ne $masterRevision){throw 'A pasta CraftMaster existente usa outra revisao. Use um ambiente separado; ela nao sera sobrescrita.'}
$craft=Join-Path $source '.github/workflows/.craft.ps1'
function Invoke-MacCraft {
    & $craft @args
    if($LASTEXITCODE -ne 0){throw 'Etapa do Craft falhou; conferir a saida antes de continuar.'}
}
Invoke-MacCraft --setup
Invoke-MacCraft -c --unshelve (Join-Path $source '.craft.shelf')
Invoke-MacCraft -c --set "srcDir=$source" owncloud/owncloud-client
Invoke-MacCraft -c --set buildNumber=18041 owncloud/owncloud-client
Invoke-MacCraft -c --set enableAutoUpdater=false owncloud/owncloud-client
Invoke-MacCraft -c --set enableCrashReporter=false owncloud/owncloud-client
Invoke-MacCraft -c --install-deps owncloud/owncloud-client
Invoke-MacCraft -c --no-cache owncloud/owncloud-client
$buildRoot=Join-Path $HOME "craft/$($env:CRAFT_TARGET)/build/owncloud/owncloud-client"
$apps=@(Get-ChildItem -LiteralPath $buildRoot -Filter 'owncloud.app' -Directory -Recurse | Where-Object {$_.FullName -match '/work/[^/]+/bin/owncloud.app$'})
if($apps.Count -ne 1){throw 'Nao foi possivel identificar um unico app compilado. Confira o caminho de compilacao do Craft.'}
Invoke-MacCraft -c --run bash (Join-Path $PSScriptRoot 'empacotar-macos.sh') $apps[0].FullName (Join-Path $projectRoot "binaries/$Architecture")
