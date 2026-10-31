function Resolve-PScriboLinkSegment
{
<#
    .SYNOPSIS
        Adds resolution details (IsResolved, AnchorName) to a link segment.

    .NOTES
        External links are resolved when their URI scheme is permitted.
        This is an internal function and should not be called directly.
#>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSObject] $Segment
    )
    process
    {
        $isResolved = $false
        if ($Segment.IsExternal)
        {
            $isResolved = Test-PScriboLinkUri -Uri $Segment.Target
        }

        return [PSCustomObject] @{
            Kind        = $Segment.Kind
            Text        = $Segment.Text
            Target      = $Segment.Target
            Id          = $Segment.Id
            IsExternal  = $Segment.IsExternal
            IsResolved  = $isResolved
            AnchorName  = $null
        }
    }
}
