function Get-PScriboLinkDisplayText
{
<#
    .SYNOPSIS
        Returns the text to display for a link segment.

    .NOTES
        This is an internal function and should not be called directly.
#>
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSObject] $Segment
    )
    process
    {
        if (-not [System.String]::IsNullOrEmpty($Segment.Text))
        {
            return $Segment.Text
        }
        return $Segment.Target
    }
}
