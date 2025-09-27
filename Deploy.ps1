# Configuration
$repoUrl = "https://github.com/bhfayyaz1-sudo/fzrepository1.git"
$branch = "main"  # Change to your desired branch
$tempPath = "C:\temp\deployment"
$deployPath = "D:\application"

# Ensure Git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed or not in PATH."
    exit 1
}

# Create temp directory if it doesn't exist
if (-not (Test-Path $tempPath)) {
    New-Item -ItemType Directory -Path $tempPath | Out-Null
}

# Clone or pull latest code
if (-not (Test-Path "$tempPath\.git")) {
    Write-Host "Cloning repository..."
    git clone --branch $branch $repoUrl $tempPath
} else {
    Write-Host "Pulling latest changes..."
    Set-Location $tempPath
    git fetch origin
    git checkout $branch
    git pull origin $branch
}

# Deploy to target path
Write-Host "Deploying to $deployPath..."
if (-not (Test-Path $deployPath)) {
    New-Item -ItemType Directory -Path $deployPath | Out-Null
}

# Copy files
Copy-Item "$tempPath\*" $deployPath -Recurse -Force

Write-Host "✅ Deployment complete!"
