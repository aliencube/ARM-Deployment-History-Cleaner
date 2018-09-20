#
# This tests whether the ARM template for Storage Account has been properly deployed or not.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $SrcDirectory,
    [string] [Parameter(Mandatory=$true)] $Username,
    [string] [Parameter(Mandatory=$true)] $Password,
    [string] [Parameter(Mandatory=$true)] $TenantId,
    [bool] [Parameter(Mandatory=$false)] $IsLocal = $false
)

Describe "Logic App Deployment Tests" {
    # Init
    BeforeAll {
        if ($IsLocal -eq $false) {
            az login --service-principal -u $Username -p $Password -t $TenantId
        }
    }

    # Teardown
    AfterAll {
    }

    # Tests whether the cmdlet returns value or not.
    Context "When Storage Account deployed with parameters" {
        $guid = [Guid]::NewGuid().ToString().Replace("-", "").Substring(0, 24)
        $output = az group deployment validate `
            -g $ResourceGroupName `
            --template-file $SrcDirectory\StorageAccount.json `
            --parameters `@$SrcDirectory\StorageAccount.parameters.json `
            --parameters storageAccountName=$guid `
            | ConvertFrom-Json
        
        $result = $output.properties

        It "Should be deployed successfully" {
            $result.provisioningState | Should -Be "Succeeded"
        }

        It "Should be the location of" {
            $expected = (az group show -g $ResourceGroupName | ConvertFrom-Json).location
            $resource = $result.validatedResources[0]

            $resource.location | Should -Be $expected
        }
    }
}
