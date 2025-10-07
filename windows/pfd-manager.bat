@echo off
cd /d "%~dp0"
cls
title PiFluidDisplay Manager
setlocal

:: --- CONFIGURACAO ---
:: Preencha as variaveis abaixo para uma conexao rapida.
set "PI_IP="
set "WINDOWS_IP="
set "SSH_PASSWORD="
:: --- FIM DA CONFIGURACAO ---

:: --- Verificacao de Dependencias ---
echo Verificando a existencia do plink.exe...
where plink.exe >nul 2>&1
if %errorlevel% NEQ 0 (
    cls
    echo.
    echo  ERRO: O programa 'plink.exe' nao foi encontrado.
    echo.
    echo  -----------------------------------------------------------------
    echo   Para continuar, voce precisa do plink.exe:
    echo.
    echo   1. Baixe o 'plink.exe' ^(geralmente a versao 64-bit x86^).
    echo   2. Salve o arquivo 'plink.exe' na mesma pasta deste script.
    echo  -----------------------------------------------------------------
    echo.
    echo   Link para download:
    echo   https://putty.org
    echo   ^(Navege para a secao de download "Download PuTTY"^)
    echo   ^(Procure o plink.exe na secao "Alternative binary files"^)
    echo.
    pause
    exit /b
)
timeout >nul
cls

echo --- PiFluidDisplay Manager ---
echo.

:: --- Obter IPs e Senha ---
if "%PI_IP%"=="" ( set /p PI_IP="[1 de 3] Digite o IP da tela PiFluidDisplay: " )
if "%PI_IP%"=="" ( echo IP do Pi nao fornecido. Saindo. & pause & exit /b )

if "%WINDOWS_IP%"=="" (
    echo. & echo Para encontrar o IP deste PC, abra outro Prompt e digite 'ipconfig'
    set /p WINDOWS_IP="[2 de 3] Digite o IP deste PC com Windows: "
)
if "%WINDOWS_IP%"=="" ( echo IP do Windows nao fornecido. Saindo. & pause & exit /b )

if "%SSH_PASSWORD%"=="" (
    echo. & set /p SSH_PASSWORD="[3 de 3] Digite a senha do usuario 'pi' no Raspberry Pi: "
)
if "%SSH_PASSWORD%"=="" ( echo Senha do SSH nao fornecida. Saindo. & pause & exit /b )


:: --- Comandar o Pi ---
echo.
echo Enviando comando para %PI_IP% se conectar a %WINDOWS_IP%...
echo (Para encerrar, simplesmente feche esta janela)
echo.

:: Executa o plink para se conectar e passar a senha de forma automática sem pausas.
plink.exe -t -pw "%SSH_PASSWORD%" "pi@%PI_IP%" "/home/pi/pi-fluid-display/pfd-connect.sh '%WINDOWS_IP%'"

echo.
echo Conexao encerrada.
endlocal