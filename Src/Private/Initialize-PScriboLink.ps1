function Initialize-PScriboLink
{
<#
    .SYNOPSIS
        Scans a completed document for links and validates them.

    .DESCRIPTION
        Links are resolved when the document is rendered, so forward references are
        supported. This scan runs once the document has been built and records the
        number of links (Properties['Links']) and warns about links that cannot be
        rendered as links.

    .NOTES
        This is an internal function and should not be called directly.
#>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')]
    param
    (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSObject] $PScriboDocument
    )
    process
    {
        $texts = New-Object -TypeName 'System.Collections.ArrayList'
        $stack = New-Object -TypeName 'System.Collections.Stack'
        for ($i = $PScriboDocument.Sections.Count - 1; $i -ge 0; $i--)
        {
            $stack.Push($PScriboDocument.Sections[$i])
        }

        while ($stack.Count -gt 0)
        {
            $item = $stack.Pop()
            switch ($item.Type)
            {
                'PScribo.Section'
                {
                    for ($i = $item.Sections.Count - 1; $i -ge 0; $i--)
                    {
                        $stack.Push($item.Sections[$i])
                    }
                }
                'PScribo.Paragraph'
                {
                    foreach ($paragraphRun in $item.Sections)
                    {
                        [ref] $null = $texts.Add($paragraphRun.Text)
                    }
                }
                'PScribo.Table'
                {
                    foreach ($row in $item.Rows)
                    {
                        foreach ($property in $row.PSObject.Properties)
                        {
                            if ($property.Name -like '*__Style')
                            {
                                continue
                            }
                            foreach ($value in @($property.Value))
                            {
                                if ($value -is [System.String])
                                {
                                    [ref] $null = $texts.Add($value)
                                }
                            }
                        }
                    }
                }
            }
        }

        $linkCount = 0
        $warnedTargets = New-Object -TypeName 'System.Collections.Generic.HashSet[System.String]'
        foreach ($text in $texts)
        {
            if (($null -eq $text) -or ($text.IndexOf('<!#') -lt 0))
            {
                continue
            }
            foreach ($segment in @(Get-PScriboLinkSegment -Text $text))
            {
                if ($segment.Kind -ne 'Link')
                {
                    continue
                }
                $linkCount++
                if ($segment.IsExternal -and (-not (Test-PScriboLinkUri -Uri $segment.Target)) -and $warnedTargets.Add($segment.Target))
                {
                    Write-PScriboMessage -Message ($localized.UnsupportedLinkUriWarning -f $segment.Target) -IsWarning
                }
            }
        }
        $PScriboDocument.Properties['Links'] = $linkCount
    }
}
