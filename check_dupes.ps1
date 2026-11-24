$tags = @()
Get-Content 'C:\Users\Rick\Documents\GitRepos\GitRepoLuxObscura\Lux-Obscura\_data\tags.yml' | ForEach-Object {
    if ($_.TrimStart().StartsWith('-')) {
        $tags += $_.Trim()
    }
}
$tags | Group-Object | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Name