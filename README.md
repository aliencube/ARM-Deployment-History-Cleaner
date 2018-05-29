# ARM Deployment History Cleaner #

This provides Azure Logic Apps to clean up ARM deployment history.


## Background ##

One Azure Resource Group can only have up to 800 deployment history. If the number of deployment histories exceeds 800, deployment cannot be happending but throwing an error. Therefore, the history needs to be regularly purged. With this Azure Logic App, they can be easily removed within 15 minutes, while using PowerShell takes more than 6 hours.


## Getting Started ##

This ARM template deploys the following Azure resources:

* Azure Storage Account
* Azure Logic Apps
* Connector - ARM
* Connector - Table Storage


### Deployment through Azure Portal ###

Click the button below to deploy the ARM template through Azure Portal:

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faliencube%2FARM-Deployment-History-Cleaner%2Fmaster%2Fazuredeploy.json" target="_blank">
  <img src="https://azuredeploy.net/deploybutton.png" />
</a>


### Deployment through Azure PowerShell ###

Alternatively, deploy it through Azure PowerShell.

1. Login to Azure Resource Manager through PowerShell.

    ```powershell
    Login-AzureRmAccount
    ```
1. Create a resource group.

    ```powershell
    New-AzureRmResourceGroup `
        -Name "[RESOURCE_GROUP_NAME]" `
        -Location "[LOCATION]"
    ```

1. Update `azuredeploy.parameters.json`.
1. Deploy the ARM template. Once deployed, it will return both Azure Functions application URL and ACI endpoint URL.

    ```powershell
    New-AzureRmResourceGroupDeployment `
        -Name RequestBin `
        -ResourceGroupName "[RESOURCE_GROUP_NAME]" `
        -TemplateFile "azuredeploy.json" `
        -TemplateParameterFile "azuredeploy.parameters.json" `
        -Verbose
    ```

1. Send an HTTP request to Azure Logic Apps to delete all deployment history under the resource group. The request payload is:

    ```json
    {
      "resourceGroup": "[RESOURCE_GROUP_NAME]"
    }
    ```

   If the payload is omitted, the resource group that this Logic App is located is automatically chosen by default.

> **NOTE**: This is using nested ARM template deployment. If you are not sure how it works, deploy each ARM template individually in the following order:
>
> 1. `StorageAccount.json`
> 1. `Connector.Arm.json`
> 1. `Connector.TableStorage.json`
> 1. `LogicApp.json`


## Contribution ##

Your contributions are always welcome! All your work should be done in your forked repository. Once you finish your work with corresponding tests, please send us a pull request onto our `master` branch for review.


## License ##

**ARM Deployment History Cleaner** is released under [MIT License](http://opensource.org/licenses/MIT)

> The MIT License (MIT)
>
> Copyright (c) 2018 [aliencube.org](https://aliencube.org)
> 
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
