<#
.SYNOPSIS
    Retrieves GitHub Copilot AI credit usage for every licensed user in an
    enterprise via the GitHub REST API.

.DESCRIPTION
    Calls GET /enterprises/{enterprise}/settings/billing/ai_credit/usage to pull
    the AI credit usage report for the enterprise. Optionally enumerates all
    Copilot seats via GET /enterprises/{enterprise}/copilot/billing/seats and
    can either:
      * Run a single aggregate query and group results client-side by user
        (default, fewest API calls), or
      * Loop and query per-user (-PerUser switch) for a guaranteed per-user
        breakdown.

    Outputs JSON to STDOUT by default, or to a CSV / JSON file via -OutFile.

    This script targets the scenario where users hold enterprise Copilot
    licenses directly and are NOT members of any organization in the
    enterprise. The -Organization filter is intentionally not exposed.

.PARAMETER Enterprise
    The enterprise slug (URL slug, NOT the display name). Required.

.PARAMETER Token
    GitHub Personal Access Token with `manage_billing:copilot` (classic) or
    the equivalent fine-grained "Enterprise billing" read permission.
    Falls back to the GH_TOKEN or GITHUB_TOKEN environment variable.

.PARAMETER Year
    4-digit year. Defaults to the current year.

.PARAMETER Month
    Month number (1-12). Defaults to the current month.

.PARAMETER Day
    Day of month (1-31). Optional.

.PARAMETER User
    Filter to a single user login (case-insensitive).

.PARAMETER Model
    Filter to a single model name (e.g. claude-sonnet-4).

.PARAMETER PerUser
    Enumerate all Copilot seats and call the usage endpoint once per user.
    Slower but produces a guaranteed per-user rollup.

.PARAMETER OutFile
    Optional output path. Extension determines format:
      *.csv  -> flattened CSV of usageItems
      *.json -> raw JSON aggregate
    Omit to print JSON to STDOUT.

.PARAMETER ApiBase
    API base URL. Defaults to https://api.github.com. Override for GHES.

.EXAMPLE
    .\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -Token $env:GH_TOKEN

.EXAMPLE
    .\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -Year 2026 -Month 5 -OutFile usage-2026-05.csv

.EXAMPLE
    .\Get-CopilotAICreditUsage.ps1 -Enterprise my-enterprise -PerUser -OutFile per-user.csv

.NOTES
    Requires PowerShell 7+ (uses Invoke-RestMethod with -FollowRelLink).
    GitHub data retention: last 24 months only.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Enterprise,

    [string]$Token = $env:GH_TOKEN,

    [int]$Year,
    [int]$Month,
    [int]$Day,

    [string]$User,
    [string]$Model,

    [switch]$PerUser,

    [string]$OutFile,

    [string]$ApiBase = 'https://api.github.com',

    [string]$ApiVersion = '2026-03-10'
)

# ---------- Setup -----------------------------------------------------------

if (-not $Token) { $Token = $env:GITHUB_TOKEN }
if (-not $Token) {
    throw "No token provided. Pass -Token or set `$env:GH_TOKEN / `$env:GITHUB_TOKEN."
}

if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Warning "This script targets PowerShell 7+. Pagination (-FollowRelLink) may not work on PS 5.1."
}

$headers = @{
    'Accept'               = 'application/vnd.github+json'
    'Authorization'        = "Bearer $Token"
    'X-GitHub-Api-Version' = $ApiVersion
    'User-Agent'           = 'Get-CopilotAICreditUsage/1.0'
}

# ---------- Helpers ---------------------------------------------------------

function Invoke-GitHubGet {
    param(
        [Parameter(Mandatory)] [string]$Uri,
        [switch]$Paginate
    )
    try {
        if ($Paginate) {
            Invoke-RestMethod -Method Get -Uri $Uri -Headers $headers -FollowRelLink -MaximumFollowRelLink 100
        } else {
            Invoke-RestMethod -Method Get -Uri $Uri -Headers $headers
        }
    } catch {
        $status = $_.Exception.Response.StatusCode.value__
        $body   = $_.ErrorDetails.Message
        throw "GitHub API call failed ($status): $Uri`n$body"
    }
}

function Build-UsageUri {
    param(
        [string]$Enterprise,
        [hashtable]$Q
    )
    $base = "$ApiBase/enterprises/$Enterprise/settings/billing/ai_credit/usage"
    $pairs = @()
    foreach ($k in $Q.Keys) {
        if ($null -ne $Q[$k] -and "$($Q[$k])" -ne '') {
            $pairs += "$k=$([uri]::EscapeDataString("$($Q[$k])"))"
        }
    }
    if ($pairs.Count -gt 0) { "$base`?$($pairs -join '&')" } else { $base }
}

function Get-Usage {
    param(
        [string]$User = $null
    )
    $q = [ordered]@{}
    if ($Year)  { $q['year']  = $Year  }
    if ($Month) { $q['month'] = $Month }
    if ($Day)   { $q['day']   = $Day   }
    if ($Model) { $q['model'] = $Model }
    if ($User)  { $q['user']  = $User  }
    Invoke-GitHubGet -Uri (Build-UsageUri -Enterprise $Enterprise -Q $q)
}

function Get-AllSeats {
    $uri = "$ApiBase/enterprises/$Enterprise/copilot/billing/seats?per_page=100"
    # -FollowRelLink returns an array of pages
    $pages = Invoke-GitHubGet -Uri $uri -Paginate
    if ($pages -isnot [System.Collections.IEnumerable]) { $pages = @($pages) }
    $all = @()
    foreach ($p in $pages) { if ($p.seats) { $all += $p.seats } }
    return $all
}

function Flatten-Usage {
    param([Parameter(Mandatory)] $Report, [string]$ForUser)
    $period = $Report.timePeriod
    $rows = @()
    if ($Report.usageItems) {
        foreach ($item in $Report.usageItems) {
            $rows += [pscustomobject]@{
                Enterprise     = $Report.enterprise
                Year           = $period.year
                Month          = $period.month
                Day            = $period.day
                User           = if ($ForUser) { $ForUser } else { $Report.user }
                Product        = $item.product
                Sku            = $item.sku
                Model          = $item.model
                UnitType       = $item.unitType
                PricePerUnit   = $item.pricePerUnit
                GrossQuantity  = $item.grossQuantity
                GrossAmountUSD = $item.grossAmount
                NetQuantity    = $item.netQuantity
                NetAmountUSD   = $item.netAmount
            }
        }
    }
    return $rows
}

# ---------- Main ------------------------------------------------------------

Write-Host "Enterprise:    $Enterprise" -ForegroundColor Cyan
Write-Host "API base:      $ApiBase"
Write-Host "API version:   $ApiVersion"
Write-Host "Mode:          $(if ($PerUser) { 'Per-user (enumerate seats)' } else { 'Aggregate single call' })"
Write-Host ""

$rows = @()
$rawReports = @()

if ($PerUser) {
    Write-Host "Listing Copilot seats..." -ForegroundColor Yellow
    $seats = Get-AllSeats
    $logins = $seats |
        Where-Object { $_.assignee -and $_.assignee.login } |
        ForEach-Object { $_.assignee.login } |
        Sort-Object -Unique
    Write-Host "Found $($logins.Count) unique licensed users."

    $i = 0
    foreach ($login in $logins) {
        $i++
        Write-Progress -Activity "Fetching AI credit usage" -Status "$login ($i/$($logins.Count))" -PercentComplete (($i / [Math]::Max($logins.Count,1)) * 100)
        try {
            $report = Get-Usage -User $login
            $rawReports += $report
            $rows += Flatten-Usage -Report $report -ForUser $login
        } catch {
            Write-Warning "Failed for $login : $_"
        }
    }
    Write-Progress -Activity "Fetching AI credit usage" -Completed
} else {
    Write-Host "Fetching aggregate usage..." -ForegroundColor Yellow
    $report = Get-Usage -User $User
    $rawReports += $report
    $rows += Flatten-Usage -Report $report
}

# ---------- Output ----------------------------------------------------------

if (-not $OutFile) {
    # JSON to STDOUT
    $rawReports | ConvertTo-Json -Depth 10
    return
}

$ext = [System.IO.Path]::GetExtension($OutFile).ToLowerInvariant()
switch ($ext) {
    '.csv' {
        $rows | Export-Csv -Path $OutFile -NoTypeInformation -Encoding UTF8
        Write-Host "Wrote $($rows.Count) row(s) to $OutFile" -ForegroundColor Green
    }
    '.json' {
        $rawReports | ConvertTo-Json -Depth 10 | Set-Content -Path $OutFile -Encoding UTF8
        Write-Host "Wrote raw JSON to $OutFile" -ForegroundColor Green
    }
    default {
        throw "Unsupported -OutFile extension '$ext'. Use .csv or .json."
    }
}

# ---------- Summary ---------------------------------------------------------

if ($rows.Count -gt 0) {
    $totalNet = ($rows | Measure-Object -Property NetAmountUSD -Sum).Sum
    $totalQty = ($rows | Measure-Object -Property NetQuantity -Sum).Sum
    Write-Host ""
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host ("  Line items:        {0}" -f $rows.Count)
    Write-Host ("  Total net credits: {0:N2}" -f $totalQty)
    Write-Host ("  Total net amount:  `${0:N4} USD" -f $totalNet)
    $topUsers = $rows |
        Group-Object User |
        ForEach-Object {
            [pscustomobject]@{
                User      = $_.Name
                Credits   = ($_.Group | Measure-Object NetQuantity -Sum).Sum
                AmountUSD = ($_.Group | Measure-Object NetAmountUSD -Sum).Sum
            }
        } |
        Sort-Object AmountUSD -Descending |
        Select-Object -First 10
    if ($topUsers.Count -gt 0 -and $topUsers[0].User) {
        Write-Host ""
        Write-Host "Top users by spend:" -ForegroundColor Cyan
        $topUsers | Format-Table -AutoSize
    }
}
