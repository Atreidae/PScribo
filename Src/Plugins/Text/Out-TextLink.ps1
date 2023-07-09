function Out-TextLink
{
<#
    .SYNOPSIS
        Outputs a link in a text friendly format

        #Todo currently rolled into Out-textParagraph, need to support not in a ParagraphRun
#>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject] $Link
    )
    begin
    {
        ## Fix Set-StrictMode
        if (-not (Test-Path -Path Variable:\Options))
        {
            $options = New-PScriboTextOption;
        }
    }
    process
    {
        Write-host "Hey guys!"
        $convertToAlignedStringParams = @{
            Width       = $options.TextWidth
            Tabs        = $Link.Tabs
            Align       = 'Left'
        }

        if (-not [System.String]::IsNullOrEmpty($Link.Style))
        {
            $LinkStyle = Get-PScriboDocumentStyle -Style $Link.Style
            $convertToAlignedStringParams['Align'] = $LinkStyle.Align
        }

        [System.Text.StringBuilder] $LinkBuilder = New-Object -TypeName 'System.Text.StringBuilder'
        $text = Resolve-PScriboToken -InputObject "$($Link.Text) > ( $($Link.uri))"
        $convertToAlignedStringParams['InputObject'] = "$($Link.Text) > ( $($Link.uri))"
        return (ConvertTo-AlignedString @convertToAlignedStringParams)
    }
}
