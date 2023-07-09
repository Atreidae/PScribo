function New-PScriboTextLink
{
<#
    .SYNOPSIS
        Initializes a new PScribo Link object.

    .NOTES
        This is an internal function and should not be called directly.
#>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions','')]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [AllowEmptyString()]
        [System.String] $Text,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'URI')]
        [System.String] $URI
    )
    process
    {
        $pscriboTextLink = [PSCustomObject] @{
            Type              = 'PScribo.TextLink'
            Text              = $Text
            URI               = $URI
            IsStyleInherited  = $PSCmdlet.ParameterSetName -eq 'Default'
            HasStyle          = $false
            HasInlineStyle    = $false
            IsParagraphRunEnd = $false
            Name              = $null # For legacy Xml output
            Value             = $null # For legacy Xml output
        }
        return $pscriboTextLink
    }
}
