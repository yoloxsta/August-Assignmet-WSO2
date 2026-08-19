# Quick Start Script - API Manager Only
# Fastest way to get started with WSO2

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   WSO2 API Manager - Quick Start" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will start a single WSO2 API Manager instance." -ForegroundColor Yellow
Write-Host "No database setup required - uses built-in H2 database." -ForegroundColor Yellow
Write-Host ""

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor Yellow
$dockerStatus = docker info 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again." -ForegroundColor Red
    exit 1
}
Write-Host "Docker is running." -ForegroundColor Green
Write-Host ""

# Pull and start
Write-Host "Starting WSO2 API Manager..." -ForegroundColor Yellow
docker-compose -f docker-compose.quickstart.yml up -d

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   WSO2 API Manager Starting!" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please wait 2-3 minutes for startup..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Access URLs:" -ForegroundColor White
Write-Host "  Publisher:  https://localhost:9443/publisher" -ForegroundColor White
Write-Host "  DevPortal:  https://localhost:9443/devportal" -ForegroundColor White
Write-Host "  Admin:      https://localhost:9443/admin" -ForegroundColor White
Write-Host "  Carbon:     https://localhost:9443/carbon" -ForegroundColor White
Write-Host ""
Write-Host "Credentials: admin / admin" -ForegroundColor Yellow
Write-Host ""
Write-Host "View logs: docker logs wso2-apim-quickstart -f" -ForegroundColor Gray
Write-Host "Stop:       docker-compose -f docker-compose.quickstart.yml down" -ForegroundColor Gray
Write-Host ""
