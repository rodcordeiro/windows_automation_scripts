
<#PSScriptInfo

.VERSION 1.0

.GUID 4c5219f9-8291-4540-a485-860e3969fd70

.AUTHOR Rodrigo

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


#>

<# 

.DESCRIPTION 
 Get news from some updates 

#> 
Param()
Begin{
	add-type -AssemblyName System.Windows.Forms
	add-type -AssemblyName System.Drawing
	$URLs = @(
		# "https://yahoo.com/news/rss/world"
		"http://rss.uol.com.br/feed/noticias.xml"
		"http://rss.uol.com.br/feed/tecnologia.xml"
		"https://www.uol.com.br/esporte/futebol/clubes/saopaulo.xml"
		"http://rss.uol.com.br/feed/jogos.xml"
		"https://evotec.xyz/category/powershell/feed/"
		"https://adamtheautomator.com/feed/")

	function ConvertFrom-XML
	{
		[CmdletBinding()]
		param
		(
			[Parameter(Mandatory = $true,ValueFromPipeline)]
			[System.Xml.XmlNode]$node, #we are working through the nodes
			[string]$Prefix='',#do we indicate an attribute with a prefix?
			$ShowDocElement=$false #Do we show the document element? 
		)
		process
		{   #if option set, we skip the Document element
			if ($node.DocumentElement -and !($ShowDocElement)) 
				{ $node = $node.DocumentElement }
			$oHash = [ordered] @{ } # start with an ordered hashtable.
			#The order of elements is always significant regardless of what they are
			write-verbose "calling with $($node.LocalName)"
			if ($null -ne $node.Attributes ) #if there are elements
			# record all the attributes first in the ordered hash
			{
				$node.Attributes | ForEach-Object {
					$oHash.$($Prefix+$_.FirstChild.parentNode.LocalName) = $_.FirstChild.value
				}
			}
			# check to see if there is a pseudo-array. (more than one
			# child-node with the same name that must be handled as an array)
			$node.ChildNodes | #we just group the names and create an empty
			#array for each
			Group-Object -Property LocalName | where-object { $_.count -gt 1 } | select-object Name |
			ForEach-Object{
				write-verbose "pseudo-Array $($_.Name)"
				$oHash.($_.Name) = @() <# create an empty array for each one#>
			};
			foreach ($child in $node.ChildNodes)
			{#now we look at each node in turn.
				write-verbose "processing the '$($child.LocalName)'"
				$childName = $child.LocalName
				if ($child -is [system.xml.xmltext])
				# if it is simple XML text 
				{
					write-verbose "simple xml $childname";
					$oHash.$childname += $child.InnerText
				}
				# if it has a #text child we may need to cope with attributes
				elseif ($child.FirstChild.Name -eq '#text' -and $child.ChildNodes.Count -eq 1)
				{
					write-verbose "text";
					if ($null -ne $child.Attributes) #hah, an attribute
					{
						<#we need to record the text with the #text label and preserve all
						the attributes #>
						$aHash = [ordered]@{ };
						$child.Attributes | foreach-Object {
							$aHash.$($_.FirstChild.parentNode.LocalName) = $_.FirstChild.value
						}
						#now we add the text with an explicit name
						$aHash.'#text' += $child.'#text'
						$oHash.$childname += $aHash
					}
					else
					{ #phew, just a simple text attribute. 
						$oHash.$childname += $child.FirstChild.InnerText
					}
				}
				elseif ($null -ne $child.'#cdata-section')
				# if it is a data section, a block of text that isnt parsed by the parser,
				# but is otherwise recognized as markup
				{
					write-verbose "cdata section";
					$oHash.$childname = $child.'#cdata-section'
				}
				elseif ($child.ChildNodes.Count -gt 1 -and 
							($child | Get-Member -MemberType Property).Count -eq 1)
				{
					$oHash.$childname = @()
					foreach ($grandchild in $child.ChildNodes)
					{
						$oHash.$childname += (ConvertFrom-XML $grandchild)
					}
				}
				else
				{
					# create an array as a value  to the hashtable element
					$oHash.$childname += (ConvertFrom-XML $child)
				}
			}
			$oHash
		}
	} 

	function getNews{
		param([String]$URL)
		[int]$MaxCount = 20
		[xml]$Content = (invoke-webRequest -uri $URL -useBasicParsing).Content
		$Data = ConvertFrom-XML $Content
		# $Data
		# $Data.channel.title.Values
		$values = @()
		foreach ($item in $data.channel.item) {
			$values+=[pscustomobject]@{
					Origin= $Data.channel.title.Values;
					Title= $item.title;
					Description= $item.description
				}
			$Count++
			if ($Count -eq $MaxCount) { 
				break
			}
		}
		$values		
		# return $values		
	}

	function ShowData{
		param(
			[System.collections.ArrayList]$values
		)
		# https://stackoverflow.com/questions/11468423/powershell-creating-custom-datagridview/
		# https://stackoverflow.com/a/15586966/8495797

		$form = New-Object System.Windows.Forms.Form
		$form.Size = New-Object System.Drawing.Size(1200,800)
		$grid = New-Object System.Windows.Forms.DataGridView -Property @{
			    Size=New-Object System.Drawing.Size(1200,800)
			    ColumnHeadersVisible = $true
			    ColumnCount = 3
			}

		$grid.Columns[0].Name = "Origin"
		$grid.Columns[0].SortMode = "Automatic"
		$grid.Columns[0].Width = 150

		$grid.Columns[1].Name = "Title"
		$grid.Columns[1].Width = 350

		$grid.Columns[2].Name = "Description"
		$grid.Columns[2].Width = 600
		foreach ($_ in $values) {
			[void]$grid.Rows.Add($($_.Origin), $($_.Title),$($_.Description))
		}

		$form.Controls.Add($grid)
		$form.ShowDialog()
	}
}
Process{
	$data = @()
	foreach ($url in $urls) {
		$url
		# getNews $url
		$data += getNews $url
	}
	ShowData $data
}
End{

}