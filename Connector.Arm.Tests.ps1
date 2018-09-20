#
# This tests whether the ARM template for Logic App API Connector has been properly deployed or not.
#

Param(
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
    [string] [Parameter(Mandatory=$true)] $SrcDirectory,
    [string] [Parameter(Mandatory=$true)] $Username,
    [string] [Parameter(Mandatory=$true)] $Password,
    [string] [Parameter(Mandatory=$true)] $TenantId,
    [bool] [Parameter(Mandatory=$false)] $IsLocal = $false
)

Describe "Deployment Tests for Logic App API Connection for ARM" {
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
    Context "When API connector deployed with parameters" {
        $output = az group deployment validate `
            -g $ResourceGroupName `
            --template-file $SrcDirectory\Connector.Arm.json `
            --parameters `@$SrcDirectory\Connector.Arm.parameters.json `
            --parameters servicePrincipalClientSecret="abcde" `
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
