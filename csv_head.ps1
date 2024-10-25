param(
    [string]$param1
)

if (-not $param1) {
    Write-Output "First argumet the neme of the folder."
    exit 1
}
$ErrorActionPreference = "Stop"

$folderPath = $param1


# Get all the file names
$csvFiles = Get-ChildItem -Path $folderPath -Filter *.csv

foreach ($file in $csvFiles) {
    #read only header
    $header = Get-Content $file.FullName -TotalCount 1
    $columns = $header -replace '"', '' -split ';'
    $fileName = $file.BaseName
    # Write columnames
    foreach ($column in $columns) {
        Write-Output "$fileName;$column"
    }
}
