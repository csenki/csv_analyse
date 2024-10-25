param(
    [string]$param1
)


if (-not $param1) {
    Write-Output "First argumet the neme of the folder."
    exit 1
}
$ErrorActionPreference = "Stop"

$bufferSize = 18192

$folderPath = $param1


$csvFiles = Get-ChildItem -Path $folderPath -Filter *.csv 
Write-Output "file_name;column;empty;nonEmpty;maxlength"
# V�gigmegy�nk minden CSV f�jlon
foreach ($file in $csvFiles) {
        
    $reader = [System.IO.StreamReader]::new($file.FullName,[System.Text.Encoding]::Default, $bufferSize)
    # First line the header
    $header = Get-Content $file.FullName -TotalCount 1
    $columns = $header -replace '"', '' -split ';'
    $columns_len2=$columns.Length + 1
    $columnName = New-Object object[] $columns_len2
    $emptyCount= New-Object object[] $columns_len2
    $nonEmptyCount= New-Object object[] $columns_len2
    $maxLength=New-Object object[] $columns_len2
    for ($i = 0; $i -lt $columns.Length; $i++) {
        $a=$columns[$i]
		$columnName[$i] = $a		

        $emptyCount[$i] = 0
        $nonEmptyCount[$i] = 0
        $maxLength[$i] = 0
	}
		try {
			# Read lines from file
			while (($row = $reader.ReadLine()) -ne $null) {
				$fields = $row -split ';'
				for ($i = 0; $i -lt $columns.Length; $i++) {
					$field = $fields[$i].Trim('"')
					if ([string]::IsNullOrWhiteSpace($field)) {
						$emptyCount[$i]++
					} else {
						$nonEmptyCount[$i]++
						if ($field.Length -gt $maxLength[$i]) {
							$maxLength[$i] = $field.Length
						}
					}
				}
			}
		}	
		finally {
			$reader.Close()
			}
        # Write results
		for ($i = 0; $i -lt $columns.Length; $i++) {
			$cn=$columnName[$i]
			$empty=$emptyCount[$i]
			$nonEmpty=$nonEmptyCount[$i]
			$max=$maxLength[$i]
			Write-Output "$($file.Name);$cn;$empty;$nonEmpty;$max"
		}
    
	
		Remove-Variable columnName
        Remove-Variable emptyCount
        Remove-Variable nonEmptyCount
        Remove-Variable maxLength
}
