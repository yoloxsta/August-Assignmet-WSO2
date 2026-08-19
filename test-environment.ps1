# WSO2 Lab Test Script
# Run this script to verify all WSO2 services are running correctly

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   WSO2 Lab Environment Test" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Function to test a service
function Test-Service {
    param (
        [string]$Name,
        [string]$Url,
        [int]$ExpectedStatus = 200
    )
    
    Write-Host "Testing $Name..." -ForegroundColor Yellow
    
    try {
        # Skip SSL verification
        Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
        
        $response = Invoke-WebRequest -Uri $Url -Method Get -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Host "  [OK] $Name is responding (Status: $($response.StatusCode))" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "  [WARNING] $Name returned status: $($response.StatusCode)" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "  [FAIL] $Name is not responding: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Check Docker containers
Write-Host "Checking Docker containers..." -ForegroundColor Yellow
$containers = docker-compose ps -q 2>&1
if ($LASTEXITCODE -eq 0 -and $containers) {
    docker-compose ps
    Write-Host ""
}
else {
    Write-Host "No containers running. Start with: docker-compose up -d" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Testing WSO2 services..." -ForegroundColor Yellow
Write-Host ""

# Test MySQL
Write-Host "1. MySQL Database" -ForegroundColor Cyan
Test-Service -Name "MySQL" -Url "http://localhost:3306"
Write-Host ""

# Test API Manager
Write-Host "2. API Manager" -ForegroundColor Cyan
Test-Service -Name "APIM Publisher" -Url "https://localhost:9443/publisher"
Write-Host ""

# Test Identity Server
Write-Host "3. Identity Server" -ForegroundColor Cyan
Test-Service -Name "Identity Server" -Url "https://localhost:9444/carbon"
Write-Host ""

# Test Micro Integrator
Write-Host "4. Micro Integrator" -ForegroundColor Cyan
Test-Service -Name "MI Health Check" -Url "http://localhost:8290/health"
Write-Host ""

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "   Test Summary" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If all services show [OK], your WSO2 lab is ready!" -ForegroundColor Green
Write-Host "If some services show [FAIL], wait a few minutes and run this test again." -ForegroundColor Yellow
Write-Host ""
Write-Host "Note: WSO2 services take 2-5 minutes to fully start up." -ForegroundColor Yellow
Write-Host ""
