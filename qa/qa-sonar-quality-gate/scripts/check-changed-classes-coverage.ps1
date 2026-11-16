param(
    [string]$BaseRef = "origin/develop",
    [double]$MinimumCoverage = 80,
    [switch]$CreateSessionBaseline,
    [string]$SessionBaselineFile = ".sonar-correction-session-baseline.json"
)

$ErrorActionPreference = "Stop"

function Normalize-RelativePath {
    param([string]$PathValue)
    return $PathValue.Replace("\", "/")
}

function Get-FileHashMap {
    $root = Get-Location
    $files = Get-ChildItem -Path "src/main/java" -Recurse -File -Filter "*.java" -ErrorAction SilentlyContinue
    $map = @{}

    foreach ($file in $files) {
        $relative = Resolve-Path -Relative $file.FullName
        if ($relative.StartsWith(".\")) {
            $relative = $relative.Substring(2)
        } elseif ($relative.StartsWith("./")) {
            $relative = $relative.Substring(2)
        }
        $relative = Normalize-RelativePath $relative
        $hash = (Get-FileHash -Algorithm SHA256 $file.FullName).Hash
        $map[$relative] = $hash
    }

    return $map
}

function Write-SessionBaseline {
    param([string]$BaselinePath)

    $hashMap = Get-FileHashMap
    $payload = [pscustomobject]@{
        generatedAt = (Get-Date).ToString("o")
        files       = $hashMap
    }

    $json = $payload | ConvertTo-Json -Depth 8
    Set-Content -Path $BaselinePath -Value $json -Encoding UTF8
}

function Read-SessionBaseline {
    param([string]$BaselinePath)

    if (-not (Test-Path $BaselinePath)) {
        throw "Session baseline file not found: '$BaselinePath'."
    }

    return (Get-Content $BaselinePath -Raw | ConvertFrom-Json)
}

function Get-ChangedJavaClassesFromSessionBaseline {
    param([string]$BaselinePath)

    $baseline = Read-SessionBaseline -BaselinePath $BaselinePath
    $currentMap = Get-FileHashMap

    $baselineMap = @{}
    $baseline.files.PSObject.Properties | ForEach-Object {
        $baselineMap[$_.Name] = [string]$_.Value
    }

    $changed = New-Object System.Collections.Generic.List[string]
    foreach ($path in $currentMap.Keys) {
        if (-not $baselineMap.ContainsKey($path)) {
            $changed.Add($path)
            continue
        }
        if ($baselineMap[$path] -ne $currentMap[$path]) {
            $changed.Add($path)
        }
    }

    return $changed
}

function Resolve-BaseRef {
    param([string]$Candidate)

    & git rev-parse --verify $Candidate *> $null
    if ($LASTEXITCODE -eq 0) {
        return $Candidate
    }

    & git rev-parse --verify "develop" *> $null
    if ($LASTEXITCODE -eq 0) {
        return "develop"
    }

    throw "Could not resolve base reference '$Candidate' nor 'develop'."
}

function Get-ChangedJavaClasses {
    param([string]$ResolvedBaseRef)

    $files = & git diff --relative --name-only "$ResolvedBaseRef...HEAD" -- "src/main/java/**/*.java"
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to list changed classes with git diff."
    }

    return @($files | Where-Object { $_ -and $_.Trim().EndsWith(".java") })
}

function To-JaCoCoClassName {
    param([string]$RelativePath)

    $normalized = Normalize-RelativePath $RelativePath
    $prefix = "src/main/java/"
    if (-not $normalized.StartsWith($prefix)) {
        throw "Invalid path for a production Java class: $RelativePath"
    }

    return $normalized.Substring($prefix.Length).Replace(".java", "")
}

function Read-JaCoCoReport {
    $reportPath = Join-Path (Get-Location) "target/site/jacoco/jacoco.xml"
    if (-not (Test-Path $reportPath)) {
        throw "JaCoCo report not found at '$reportPath'. Run 'mvn test' first."
    }
    return [xml](Get-Content $reportPath)
}

function Get-LineCoverage {
    param(
        [xml]$Report,
        [string]$ClassName
    )

    $classNode = $Report.report.package.class | Where-Object { $_.name -eq $ClassName }
    if (-not $classNode) {
        throw "Class '$ClassName' not found in jacoco.xml."
    }

    $lineCounter = $classNode.counter | Where-Object { $_.type -eq "LINE" }
    if (-not $lineCounter) {
        throw "LINE counter not found for '$ClassName'."
    }

    $covered = [double]$lineCounter.covered
    $missed = [double]$lineCounter.missed
    $total = $covered + $missed

    if ($total -eq 0) {
        return 100
    }

    return [math]::Round(($covered * 100.0) / $total, 1)
}

if ($CreateSessionBaseline) {
    Write-SessionBaseline -BaselinePath $SessionBaselineFile
    Write-Host "Session baseline created at '$SessionBaselineFile'." -ForegroundColor Green
    exit 0
}

$changedClasses = @()
if (Test-Path $SessionBaselineFile) {
    $changedClasses = Get-ChangedJavaClassesFromSessionBaseline -BaselinePath $SessionBaselineFile
    if ($changedClasses.Count -eq 0) {
        Write-Host "No production Java class was changed in this session." -ForegroundColor Yellow
        exit 0
    }
} else {
    $resolvedBaseRef = Resolve-BaseRef -Candidate $BaseRef
    $changedClasses = Get-ChangedJavaClasses -ResolvedBaseRef $resolvedBaseRef
}

if ($changedClasses.Count -eq 0) {
    Write-Host "No changed production Java class to validate." -ForegroundColor Yellow
    exit 0
}

$report = Read-JaCoCoReport
$results = New-Object System.Collections.Generic.List[object]
$failed = $false

foreach ($file in $changedClasses) {
    $className = To-JaCoCoClassName -RelativePath $file
    $coverage = Get-LineCoverage -Report $report -ClassName $className
    $status = if ($coverage -ge $MinimumCoverage) { "OK" } else { "FAIL" }
    if ($status -eq "FAIL") {
        $failed = $true
    }

    $results.Add([pscustomobject]@{
            ClassPath       = $className
            LineCoveragePct = $coverage
            MinRequiredPct  = $MinimumCoverage
            Status          = $status
        })
}

$results | Sort-Object Status, LineCoveragePct | Format-Table -AutoSize

if ($failed) {
    throw "Changed classes below $MinimumCoverage% coverage were found."
}

Write-Host "Coverage of changed classes meets the minimum of $MinimumCoverage%." -ForegroundColor Green
