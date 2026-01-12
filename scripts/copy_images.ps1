$root = "C:\Orgagen Web Development\Orgagen"
$dest = Join-Path $root "images"
New-Item -ItemType Directory -Path $dest -Force | Out-Null
$files = Get-ChildItem -Path $root -Recurse -Include *.jpg,*.jpeg,*.png -File -ErrorAction SilentlyContinue

function CopyMatch($patterns, $target){
    $match = $files | Where-Object {
        $n = $_.Name.ToLower()
        $found = $false
        foreach($p in $patterns){ if($n -like "*$p*"){ $found = $true; break } }
        $found
    } | Select-Object -First 1
    if($match){
        Copy-Item $match.FullName -Destination (Join-Path $dest $target) -Force
        Write-Output "Copied $($match.FullName) -> $target"
    } else {
        Write-Output "No file matched patterns: $($patterns -join ',') for target $target"
    }
}

CopyMatch @('field','visit') 'field-visit.jpeg'
CopyMatch @('awareness','traditional','rice') 'awareness-program.jpeg'
CopyMatch @('workshop','crop','nutrition') 'workshop.jpeg'

# copy any remaining images
$other = $files | Where-Object {
    $n = $_.Name.ToLower()
    ($n -notlike '*field*' -and $n -notlike '*visit*' -and $n -notlike '*awareness*' -and $n -notlike '*traditional*' -and $n -notlike '*rice*' -and $n -notlike '*workshop*' -and $n -notlike '*crop*' -and $n -notlike '*nutrition*')
}
foreach($o in $other){
    Copy-Item $o.FullName -Destination (Join-Path $dest $o.Name) -Force
    Write-Output "Copied extra: $($o.FullName)"
}

Write-Output "\nImages now in: $dest"
Get-ChildItem -Path $dest | Select-Object Name,Length | Format-Table -AutoSize
