# Ejecutar sólo en la carpeta original, cuyo repositorio remoto estaba vacío.
# Importa el historial preparado sin reemplazar archivos del árbol de trabajo.
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$bundlePath = Join-Path $projectRoot 'historial.bundle'
if (-not (Test-Path -LiteralPath $bundlePath)) { throw 'No se encontró historial.bundle.' }
$gitArgs = @('-c',"safe.directory=$projectRoot",'-C',$projectRoot)
& git @gitArgs rev-parse --verify HEAD 2>$null
if ($LASTEXITCODE -eq 0) { throw 'Ya existe historial local. Revisarlo antes de importar; no se sobrescribirá.' }
& git @gitArgs fetch $bundlePath main
if ($LASTEXITCODE -ne 0) { throw 'No se pudo importar el historial.' }
& git @gitArgs reset --mixed FETCH_HEAD
if ($LASTEXITCODE -ne 0) { throw 'No se pudo actualizar el índice local.' }
$remote = & git @gitArgs remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    & git @gitArgs remote add origin 'https://github.com/ChipanaGerman/analisis-metodos-numericos-MATLAB.git'
} elseif ($remote -ne 'https://github.com/ChipanaGerman/analisis-metodos-numericos-MATLAB.git') {
    throw 'Origin apunta a otro repositorio. Revísalo antes de publicar.'
}
& git @gitArgs push -u origin main
if ($LASTEXITCODE -ne 0) { throw 'No se pudo publicar. El historial importado se conserva; no se utilizó force.' }
