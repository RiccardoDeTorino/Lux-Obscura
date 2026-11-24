$content = Get-Content 'C:\Users\Rick\Documents\GitRepos\GitRepoLuxObscura\Lux-Obscura\_data\tags.yml' -Raw
$lines = $content -split "`n"

$sections = @()
$currentSection = @{Name = 'ROOT'; Tags = @(); Raw = @()}
$inTags = $false

foreach ($line in $lines) {
    $stripped = $line.Trim()
    if ($stripped -match '^# ===') {
        if ($currentSection.Tags.Count -gt 0 -or $currentSection.Raw.Count -gt 0) {
            $sections += $currentSection
        }
        $currentSection = @{Name = $stripped; Tags = @(); Raw = @($line)}
    } elseif ($stripped -match '^-\s') {
        $tag = $stripped.Substring(2).Trim()
        $currentSection.Tags += @{Tag = $tag; Line = $line}
        $currentSection.Raw += $line
    } else {
        $currentSection.Raw += $line
    }
}

if ($currentSection.Tags.Count -gt 0 -or $currentSection.Raw.Count -gt 0) {
    $sections += $currentSection
}

# Deduplicate within each section (case-insensitive)
foreach ($section in $sections) {
    $seen = @{}
    $uniqueTags = @()
    foreach ($item in $section.Tags) {
        $lower = $item.Tag.ToLower()
        if (-not $seen.ContainsKey($lower)) {
            $seen[$lower] = $true
            $uniqueTags += $item.Line
        }
    }
    $section.Tags = $uniqueTags
}

# Rebuild content
$headerEnd = $content.IndexOf("tags:")
$header = $content.Substring(0, $headerEnd)
$output = $header + "tags:`n"
foreach ($section in $sections) {
    if ($section.Name -ne 'ROOT') {
        $output += $section.Name + "`n"
    }
    foreach ($tagLine in $section.Tags) {
        $output += $tagLine + "`n"
    }
}

[IO.File]::WriteAllText('C:\Users\Rick\Documents\GitRepos\GitRepoLuxObscura\Lux-Obscura\_data\tags.yml', $output, [Text.Encoding]::UTF8)
Write-Host "Done deduplicating"