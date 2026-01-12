$root = "C:\Orgagen Web Development\Orgagen"
$dest = Join-Path $root "images"
$map = @(
    @{pattern = "field visit"; target = "field-visit.jpeg"},
    @{pattern = "awareness camp"; target = "awareness-program.jpeg"},
    @{pattern = "workshop"; target = "workshop.jpeg"}
)

foreach($m in $map){
    $f = Get-ChildItem -Path $root -Recurse -File -Include *.jpg,*.jpeg,*.png -ErrorAction SilentlyContinue |
         Where-Object { $_.DirectoryName.ToLower() -like "*" + $m.pattern + "*" } | Select-Object -First 1
    if($f){
        Copy-Item $f.FullName -Destination (Join-Path $dest $m.target) -Force
        Write-Output "Copied $($f.FullName) -> $($m.target)"
    } else {
        Write-Output "No file found for pattern: $($m.pattern)"
    }
}

Write-Output "`nFinal images in ${dest}:"
Get-ChildItem -Path $dest | Select-Object Name,Length | Format-Table -AutoSize
