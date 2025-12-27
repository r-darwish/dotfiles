Write-Host "==> Starting bootstrap for Windows..."

# Install packages via winget (excluding btop and zellij - not supported on Windows)
Write-Host "==> Installing packages via winget..."
winget install microsoft.powershell Git.Git starship neovim junegunn.fzf lazygit OpenJS.NodeJS peazip yazi sharkdp.fd ripgrep python3 zoxide eza-community.eza dandavison.delta alexx2000.DoubleCommander Microsoft.Sysinternals.Suite

# Setup nvim config (static path on Windows)
Write-Host "==> Setting up nvim..."
$nvimConfigDir = "$env:LOCALAPPDATA\nvim"

if (-not (Test-Path $nvimConfigDir)) {
    Write-Host "Cloning nvim config to: $nvimConfigDir"
    git clone https://github.com/r-darwish/nvim $nvimConfigDir
} else {
    Write-Host "nvim config already exists at: $nvimConfigDir"
}

# Setup PowerShell config (use pwsh.exe to get the correct profile path)
Write-Host "==> Setting up PowerShell..."
$pwshProfilePath = pwsh.exe -NoProfile -Command "echo `$PROFILE"
$pwshConfigDir = Split-Path $pwshProfilePath

if (-not (Test-Path $pwshConfigDir)) {
    New-Item -ItemType Directory -Path $pwshConfigDir -Force | Out-Null
}

$pwshRepoDir = Join-Path $pwshConfigDir "repository"
if (-not (Test-Path $pwshRepoDir)) {
    Write-Host "Cloning PowerShell config to: $pwshRepoDir"
    git clone https://github.com/r-darwish/PowerShell $pwshRepoDir
} else {
    Write-Host "PowerShell config already exists at: $pwshRepoDir"
}

# Create or update PowerShell Core profile to source the cloned config
$profileContent = @"
# Source the cloned PowerShell configuration
`$repoProfile = Join-Path (Split-Path `$PROFILE) "repository\Microsoft.PowerShell_profile.ps1"
if (Test-Path `$repoProfile) {
    . `$repoProfile
}
"@

if (-not (Test-Path $pwshProfilePath)) {
    Write-Host "Creating PowerShell profile at: $pwshProfilePath"
    New-Item -ItemType File -Path $pwshProfilePath -Force | Out-Null
    Set-Content -Path $pwshProfilePath -Value $profileContent
} else {
    # Check if profile already sources the repository
    $currentContent = Get-Content $pwshProfilePath -Raw
    if ($currentContent -notmatch "repository\\Microsoft\.PowerShell_profile\.ps1") {
        Write-Host "Updating PowerShell profile to source repository config"
        Add-Content -Path $pwshProfilePath -Value "`n$profileContent"
    }
}

# Install PowerShell modules
Write-Host "==> Installing PowerShell modules..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
pwsh -c "Install-Module PSFzf,Microsoft.WinGet.Client,Microsoft.Powershell.ConsoleGuiTools -Force"

Write-Host "==> Bootstrap complete!"
Write-Host "nvim config: $nvimConfigDir"
Write-Host "PowerShell config: $pwshRepoDir"
Write-Host "PowerShell profile: $pwshProfilePath"
