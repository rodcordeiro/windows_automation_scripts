<#
.SYNOPSIS
	Lists the latest news
.DESCRIPTION
	This PowerShell script lists the latest RSS feed news.
.PARAMETER RSS_URL
	Specifies the URL to the RSS feed
.PARAMETER MaxCount
	Specifies the number of news to list
.EXAMPLE
	PS> ./list-news
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz / License: CC0
#>

# param([string]$RSS_URL = "https://yahoo.com/news/rss/world", [int]$MaxCount = 20)
param([string]$RSS_URL = "http://rss.uol.com.br/feed/noticias.xml", [int]$MaxCount = 5)
try {
	[xml]$Content = (invoke-webRequest -uri $RSS_URL -useBasicParsing).Content
	[int]$Count = 0
	$data = ConvertFrom-XML $Content
	
	# $Data = @{}
	# $values = @()
	$table = New-Object System.Data.Datatable
	[void]$table.Columns.Add("Origin")
	[void]$table.Columns.Add("Title")
	[void]$table.Columns.Add("Description")

	foreach ($item in $data.channel.item) {
		[void]$table.Rows.Add($Data.channel.title.Values,$item.title,$item.description)
		# $values+=[pscustomobject]@{
		# 		Origin= $Data.channel.title.Values;
		# 		Title= $item.title;
		# 		Description= $item.description
		# 	}
		$Count++
		if ($Count -eq $MaxCount) { 
			# $data.add($Content.rss.channel.title,$values);
			# $values = @();
			break
		}
	}
	$table
	# $Values
	# ConvertTo-MarkdownTable -Rows $Values -Columns Origin,Title,Description -OutFile './teste.md'
	# "`n $($Content.rss.channel.title) "
	# "`n "

	# [int]$Count = 0
	# foreach ($item in $Content.rss.channel.item) {
	# 	"$([char]0xE0B1) $($item.title)"
	# 	$item
	# 	$Count++
	# 	if ($Count -eq $MaxCount) { break }
	# }
	exit 0 # success
} catch {
	" Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}