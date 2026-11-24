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

# GLOBAL deduplication - track which section each tag first appears in
$globalSeen = @{}
$sectionTags = @{}  # section name -> list of unique tag lines for that section

foreach ($section in $sections) {
    $uniqueForSection = @()
    foreach ($item in $section.Tags) {
        $lower = $item.Tag.ToLower()
        if (-not $globalSeen.ContainsKey($lower)) {
            $globalSeen[$lower] = $true
            $uniqueForSection += $item.Line
        }
    }
    $sectionTags[$section.Name] = $uniqueForSection
}

# Rebuild content
$headerEnd = $content.IndexOf("tags:")
$header = $content.Substring(0, $headerEnd)
$output = $header + "tags:`n"
foreach ($section in $sections) {
    if ($section.Name -ne 'ROOT') {
        $output += $section.Name + "`n"
    }
    $uniqueForSection = $sectionTags[$section.Name]
    foreach ($tagLine in $uniqueForSection) {
        $output += $tagLine + "`n"
    }
}

[IO.File]::WriteAllText('C:\Users\Rick\Documents\GitRepos\GitRepoLuxObscura\Lux-Obscura\_data\tags.yml', $output, [Text.Encoding]::UTF8)
Write-Host "Done global deduplicating. Total unique tags: $($globalSeen.Count)"