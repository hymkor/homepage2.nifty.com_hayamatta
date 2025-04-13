function mirror($src,$dst){
    Get-ChildItem -Path $src | ForEach-Object {
        $name = $_.Name
        if ( $name -in @(".","..","docs",".git","utf8.ps1") ){
            return
        }
        $newname = (Join-Path -Path $dst -ChildPath $name)
        Write-Host ("{0}`n-> {1}" -f $_.FullName,$newname)
        if ( $_.PSIsContainer ){
            if ( -not (Test-Path $newname) ){
                New-Item -Path $newname -ItemType "Directory"
            }
            mirror ($_.FullName) $newname
        } else {
            if ($name -match '\.html?$') {
                nkf32 -w $_.FullName | perl -pe 'binmode(STDIN);binmode(STDOUT);s|"http://hp.vector.co.jp/authors/VA009797|"https://hymkor.github.io/hp.vector.co.jp_VA009797|g' > $newname
            } else {
                Copy-Item $_.FullName $newname -Force
            }
        }
    } | Out-Null
}

$src = (Get-Location)
$dst = (Join-Path -Path $src -ChildPath "docs")
mirror $src $dst
