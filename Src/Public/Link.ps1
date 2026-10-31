function Link
{
<#
    .SYNOPSIS
        Inserts a hyperlink to an external resource into a paragraph.

    .DESCRIPTION
        Link returns a paragraph run, so it is used within a Paragraph script block
        alongside Text. Only http, https, ftp, mailto and tel URIs are rendered as links;
        anything else is rendered as plain text and a warning is written.

    .PARAMETER Text
        The text to display.

    .PARAMETER Uri
        The URI of the external resource.

    .PARAMETER NoSpace
        Do not add a space after the link.

    .PARAMETER Style
        Character style applied to the link text.

    .EXAMPLE
        Paragraph {
            Text 'Source code is on '
            Link 'GitHub' -Uri 'https://github.com/iainbrighton/PScribo'
        }
#>
    [CmdletBinding(DefaultParameterSetName = 'Uri')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Uri')]
        [AllowEmptyString()]
        [System.String] $Text,

        [Parameter(Mandatory, Position = 1, ParameterSetName = 'Uri')]
        [ValidateNotNullOrEmpty()]
        [System.String] $Uri,

        [Parameter(ParameterSetName = 'Uri')]
        [System.Management.Automation.SwitchParameter] $NoSpace,

        [Parameter(ParameterSetName = 'Uri')]
        [AllowNull()]
        [System.String] $Style
    )
    process
    {
        $linkDisplayName = $Text
        if ($Text.Length -gt 20)
        {
            $linkDisplayName = '{0}[..]' -f $Text.Substring(0, 16)
        }
        $targetDisplayName = $Uri
        if ($Uri.Length -gt 20)
        {
            $targetDisplayName = '{0}[..]' -f $Uri.Substring(0, 16)
        }
        Write-PScriboMessage -Message ($localized.ProcessingLink -f $linkDisplayName, $targetDisplayName)

        $newPScriboParagraphRunParams = @{
            Text    = New-PScriboLinkToken -Target $Uri -Text $Text
            NoSpace = $NoSpace
        }
        if (-not [System.String]::IsNullOrEmpty($Style))
        {
            $newPScriboParagraphRunParams['Style'] = $Style
        }
        return (New-PScriboParagraphRun @newPScriboParagraphRunParams)
    }
}
