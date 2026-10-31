function ConvertTo-PScriboLinkText
{
<#
    .SYNOPSIS
        Replaces link and anchor tokens with a plain text equivalent.

    .DESCRIPTION
        Used by the text based plugins (Text and Json). Anchors are removed and links are
        rendered as 'Display text > (uri)'.

    .NOTES
        This is an internal function and should not be called directly.
#>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [AllowEmptyString()]
        [AllowNull()]
        [System.String] $InputObject
    )
    process
    {
        if ([System.String]::IsNullOrEmpty($InputObject) -or ($InputObject.IndexOf('<!#') -lt 0))
        {
            return $InputObject
        }

        $builder = New-Object -TypeName 'System.Text.StringBuilder'
        foreach ($segment in @(Get-PScriboLinkSegment -Text $InputObject))
        {
            switch ($segment.Kind)
            {
                'Text'
                {
                    [ref] $null = $builder.Append($segment.Text)
                }
                'Link'
                {
                    $displayText = Get-PScriboLinkDisplayText -Segment $segment
                    if ($segment.IsExternal -and (Test-PScriboLinkUri -Uri $segment.Target) -and ($displayText -ne $segment.Target))
                    {
                        [ref] $null = $builder.AppendFormat('{0} > ({1})', $displayText, $segment.Target)
                    }
                    else
                    {
                        [ref] $null = $builder.Append($displayText)
                    }
                }
            }
        }
        return $builder.ToString()
    }
}
