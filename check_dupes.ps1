$tags = Get-Content 'C:\temp\tags_check.txt' | Sort-Object
$grouped = $tags | Group-Object
$duplicates = $grouped | Where-Object { $_.Count -gt 1 }
$duplicates | ForEach-Object { $_.Name }