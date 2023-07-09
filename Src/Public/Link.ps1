function Link
{
<#
    .SYNOPSIS
        Allows for insertion of Links to external resources or TOC items

    .NOTES
        Hopwfully Ian wont burn me for adding this in
        -UcMadScientist
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [AllowEmptyString()]
        [System.String] $Text, #Text to Display

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [AllowEmptyString()]
        [System.String] $URI #Link to Resource, assumes an internal link if no protocol is specified

 
    )
    begin
    {
        #Test and see if we can run this outside of a paragraph, atm it will just throw an error
        $psCallStack = Get-PSCallStack | Where-Object { $_.FunctionName -ne '<ScriptBlock>' }
        if ($psCallStack[1].FunctionName -ne 'Paragraph<Process>')
        {
            throw $localized.ParagraphRunRootError #todo
        }
    }
    process
    {
        $TextLinkDisplayName = $Text
        if ($Text.Length -gt 20)
        {
            $TextLinkDisplayName = '{0}[..]' -f $Text.Substring(0,16)
        }
        $UriLinkDisplayName = $URI
        if ($Text.Length -gt 20)
        {
            $UriLinkDisplayName = '{0}[..]' -f $URI.Substring(0,16)
        }
        Write-PScriboMessage -Message ($localized.ProcessingParagraghTextLink -f $TextLinkDisplayName,$UriLinkDisplayName)
        return (New-PScriboTextLink @PSBoundParameters)
    }
}
