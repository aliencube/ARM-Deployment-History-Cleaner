#
# This invokes pester test run.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $TestDirectory,
    [string] [Parameter(Mandatory=$true)] $SrcDirectory,
    [string] [Parameter(Mandatory=$true)] $OutputDirectory,
    [string] [Parameter(Mandatory=$true)] $BuildNumber,
    [string] [Parameter(Mandatory=$true)] $Username,
    [string] [Parameter(Mandatory=$true)] $Password,
    [string] [Parameter(Mandatory=$true)] $TenantId,
    [bool] [Parameter(Mandatory=$false)] $IsLocal = $false
)

$parameters = @{ ResourceGroupName = $ResourceGroupName; SrcDirectory = $SrcDirectory; Username = $Username; Password = $Password; TenantId = $TenantId; IsLocal = $IsLocal }

$outputFile = "$OutputDirectory\TEST-$TestDirectory-$BuildNumber.xml"
$script = @{ Path = $TestDirectory; Parameters = $parameters }

Invoke-Pester -Script $script -OutputFile $outputFile -OutputFormat NUnitXml -EnableExit
