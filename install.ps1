$pythonInstalled = Get-Command python -ErrorAction SilentlyContinue

if (-not $pythonInstalled) {
    Write-Host "Python no está instalado. Por favor, instala Python desde https://www.python.org/downloads/"
    exit
}

$pipInstalled = Get-Command pip -ErrorAction SilentlyContinue

if (-not $pipInstalled) {
    Write-Host "pip no está instalado. Asegúrate de que pip esté incluido en tu instalación de Python."
    exit
}

try {
    pip install requests
    Write-Host "La librería 'requests' se ha instalado correctamente."
} catch {
    Write-Host "Error al instalar 'requests'."
}

$apiKey = Read-Host "API KEY"
[Environment]::SetEnvironmentVariable("API_KEY", $apiKey, [EnvironmentVariableTarget]::Machine)
Write-Host "La clave API se ha guardado en la variable de entorno 'API_KEY'."

$scriptUrl = "https://raw.githubusercontent.com/v019-exe/shellgemini/refs/heads/windows/shellgemini.py"
$scriptPath = "$env:USERPROFILE\shellgemini.py"

try {
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
    Write-Host "El script 'shellgemini.py' se ha descargado en: $scriptPath"
} catch {
    Write-Host "Error al descargar 'shellgemini.py'"
}

$batchFilePath = "$env:USERPROFILE\shellgemini.bat"
$batchContent = @"
@echo off
python "$scriptPath" %*
"@
$batchContent | Out-File -FilePath $batchFilePath -Encoding ascii
Write-Host "El comando 'shellgemini' se ha creado en: $batchFilePath"

$existingPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

if (-not $existingPath.Split(';') -contains $env:USERPROFILE) {
    [System.Environment]::SetEnvironmentVariable("Path", "$existingPath;$env:USERPROFILE", [System.EnvironmentVariableTarget]::User)
    Write-Host "El directorio del usuario se ha agregado al PATH del usuario."
} else {
    Write-Host "El directorio del usuario ya estaba en el PATH del usuario."
}

Write-Host "Instalación completa. Ahora puedes ejecutar 'shellgemini <pregunta>' desde cualquier terminal."
