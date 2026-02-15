# Script auxiliar para configurar Keycloak
# Requer: jq instalado (ou fazer manualmente via UI)

Write-Host "Configurando Keycloak via API..." -ForegroundColor Yellow

$KEYCLOAK_URL = "http://localhost:8081"
$ADMIN_USER = "admin"
$ADMIN_PASS = "admin"

# Obter token admin
Write-Host "Obtendo token de admin..."
$TOKEN = (Invoke-RestMethod -Uri "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" `
    -Method POST `
    -ContentType "application/x-www-form-urlencoded" `
    -Body @{
        username = $ADMIN_USER
        password = $ADMIN_PASS
        grant_type = "password"
        client_id = "admin-cli"
    }).access_token

Write-Host "Token obtido!"

# Criar realm fiapx
Write-Host "Criando realm 'fiapx'..."
$realmBody = @{
    realm = "fiapx"
    enabled = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri "$KEYCLOAK_URL/admin/realms" `
    -Method POST `
    -Headers @{ Authorization = "Bearer $TOKEN" } `
    -ContentType "application/json" `
    -Body $realmBody

Write-Host "Realm criado!"

# Criar client
Write-Host "Criando client 'fiapx-client'..."
$clientBody = @{
    clientId = "fiapx-client"
    enabled = $true
    publicClient = $true
    directAccessGrantsEnabled = $true
    standardFlowEnabled = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri "$KEYCLOAK_URL/admin/realms/fiapx/clients" `
    -Method POST `
    -Headers @{ Authorization = "Bearer $TOKEN" } `
    -ContentType "application/json" `
    -Body $clientBody

Write-Host "Client criado!"

# Criar user
Write-Host "Criando usuário 'testuser'..."
$userBody = @{
    username = "testuser"
    email = "test@fiapx.com"
    enabled = $true
    emailVerified = $true
    firstName = "Test"
    lastName = "User"
} | ConvertTo-Json

Invoke-RestMethod -Uri "$KEYCLOAK_URL/admin/realms/fiapx/users" `
    -Method POST `
    -Headers @{ Authorization = "Bearer $TOKEN" } `
    -ContentType "application/json" `
    -Body $userBody

Write-Host "Usuário criado!"
Write-Host "✅ Keycloak configurado com sucesso!" -ForegroundColor Green