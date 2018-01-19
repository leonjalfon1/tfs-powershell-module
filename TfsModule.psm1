<# 
 .SYNOPSIS
  Useful PowerShell functions to use the TFS Rest API from powershell scripts

 .DESCRIPTION
  PowerShell functions to use the TFS Rest API. 
  For more information about the TFS Rest API visit https://www.visualstudio.com/en-us/docs/integrate/api/overview.

 .USING
  Just import this module from your PowerShell script to use the module functions:
  Import-Module path\to\the\module\TfsModule.psm1

 .CONTRIBUTING
  Please feel free to contribute.
  Adding comments following the format for each function is required.
  For more information contact me directly, leonj@sela.co.il - leonjalfon1@gmail.com

  .NOTES
  Leon Jalfon 
  DevOps & ALM Architect
#>

Write-Host "TFSModule Successfully Imported" -ForegroundColor Green

#======================================================================================================#
# Builds (XAML)
# https://www.visualstudio.com/en-us/docs/integrate/api/xamlbuild/overview
#======================================================================================================#

# Get BuidDefinitionId from BuildDefinitionName
function Get-BuildDefinitionId_XAML
{
    <#
        .SYNOPSIS
        Get a build definition from a BuildDefinitionName

        .DESCRIPTION
        Get a build definition from a BuildDefinitionName using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/xamlbuild/definitions#get-a-build-definition

        .PARAMETER BuildDefinitionName
        Name of the Build Definition
        Example: MyBuildName

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildDefinitionId_XAML -BuildDefinitionName "MyBuildName" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuildDefinitionId for the build "MyBuildName" (as string)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildDefinitionName,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
		$requestUrl = "$CollectionUrl/$TeamProject/_apis/build/definitions?name=$BuildDefinitionName" + "&api-version=$apiVersion"
        $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$buildDefinitionIdJson = $response | ConvertFrom-Json | Select value
		$buildDefinitionId = $buildDefinitionIdJson.value[0].id
		return $buildDefinitionId
	}

	catch
	{
        Write-Host "Failed to get BuildDefinitionId for build {$BuildDefinitionName}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get BuildInfo from BuildId
function Get-BuildInfo_XAML
{
    <#
        .SYNOPSIS
        Get a build information from a specific build

        .DESCRIPTION
        Get a build information from the specified build using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/xamlbuild/builds#get-a-build

        .PARAMETER BuildId
        The build Id
        Example: 373

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildInfo_XAML -BuildId "373" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuildInfo for the specified build (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds/$BuildId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$buildInfo = $response | ConvertFrom-Json
		return $buildInfo
	}

	catch
	{
        Write-Host "Failed to get the BuildInfo for build {$BuildId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get BuildDetails from BuildId
function Get-BuildDetails_XAML
{
    <#
        .SYNOPSIS
        Get a build details from a specific build

        .DESCRIPTION
        Get a build details from the specified build using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/xamlbuild/builds#get-build-details

        .PARAMETER BuildId
        The build Id
        Example: 373

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildDetails_XAML -BuildId "373" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuildDetails for the specified build (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

    try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds/$BuildId/Details" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$buildDetails = $response | ConvertFrom-Json
		return $buildDetails
	}

	catch
	{
        Write-Host "Failed to get BuildDetails for build {$BuildId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get BuildId from BuildDefinitionId and BuildNumber
function Get-BuildIdFromBuildNumber_XAML
{
    <#
        .SYNOPSIS
        Get a BuildId from it's BuildDefinitionName and it's BuildNumber

        .DESCRIPTION
        Get a BuildId from it's BuildDefinitionName and it's BuildNumber using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/xamlbuild/builds#get-a-list-of-builds

        .PARAMETER BuildDefinitionName
        Name of the Build Definition
        Example: MyBuildName

        .PARAMETER BuildNumber
        Build Number
        Example: MyBuildName_1.1.0

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildIdFromBuildNumber_XAML -BuildDefinitionName "MyBuildName" -BuildNumber "MyBuildName_1.1.0" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuildId for the build "MyBuildName_1.1.0" (as string)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildDefinitionId,
        [Parameter(Mandatory=$true)]
        $BuildNumber,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

    try
    {
        $apiVersion = "1.0"
	    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
		$requestUrl = "$CollectionUri/$TeamProject/_apis/build/builds?definitions=$BuildDefinitionId&buildNumber=$BuildNumber" + "&api-version=$apiVersion"
        $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$buildIdJson = $response | ConvertFrom-Json | Select value
		$buildId = $buildIdJson.value[0].id
		return $buildId
    }

    catch
    {
        Write-Host "Failed to get BuildId from Build {$BuildDefinitionId, $BuildNumber}, Exception: $_" -ForegroundColor Red
		return $null
    }
}

# Get Build Reason from BuildId
function Get-BuildReason_XAML
{
    <#
        .SYNOPSIS
        Get a build reason from a specific build

        .DESCRIPTION
        Get a build reason of the specified build using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/xamlbuild/builds#get-a-build

        .PARAMETER BuildId
        The build Id
        Example: 373

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildReason_XAML -BuildId "373" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the Build Reason for the specified build (as string)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds/$BuildId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
        $buildReasonJson = $response | ConvertFrom-Json | Select reason
		$buildReason = $buildReasonJson.reason
		return $buildReason
	}

	catch
	{
		Write-Host "Failed to get the Build Reason for build {$BuildId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get BuidDefinitionInfo from BuildDefinitionId
function Get-BuildDefinitionInfo_XAML
{
    <#
        .SYNOPSIS
        Get BuidDefinitionInfo from BuildDefinitionId

        .DESCRIPTION
        Get BuidDefinitionInfo from BuildDefinitionId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/xamlbuild/definitions#get-a-build-definition

        .PARAMETER BuildDefinitionId
        The build definition Id
        Example: 37

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildDefinitionInfo_XAML -BuildId "37" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuidDefinitionInfo (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildDefinitionId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
		$requestUrl = "$CollectionUrl/$TeamProject/_apis/build/definitions/$BuildDefinitionId" + "?api-version=$apiVersion"
        $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
        return $response.Content
	}

	catch
	{
        Write-Host "Failed to get BuildDefinitionInfo from BuildDefinition {$BuildDefinitionId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get the ChangesetId introduced in a gated check-in (use "Get-BuildDetails" to get the $BuildDetails parameter)
function Get-AssociatedChangesetId_XAML
{
    <#
        .SYNOPSIS
        Get the ChangesetId introduced in a gated check-in using the BuildDetails parameter

        .DESCRIPTION
        Get the ChangesetId introduced in a gated check-in
        This function works only after the build finished (use * to wait for the build to finish)

        .PARAMETER BuildDetails
        Use "Get-BuildDetails_XAML" to get the $BuildDetails parameter
        Example: $buildDetails

        .EXAMPLE
        Get-AssociatedChangesetId_XAML -BuildDetails $buildDetails
        Returns a ChangesetId (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildDetails
    )

	try
	{   
        # Try to get Changeset from the "AssociatedChangeset" object
        $AssociatedChangesetElement = $BuildDetails.value | Where {$_.type -like "AssociatedChangeset"}

        # Try to get Changeset from the "CheckInOutcome" object
        if($AssociatedChangesetElement -eq $null) { $AssociatedChangesetElement = $BuildDetails.value | Where {$_.type -like "CheckInOutcome"} }
        
        # Get the Chanset Id from the AssociatedChangesetElement   
        if($AssociatedChangesetElement.Count > 1) 
        { 
            $ChangesetId = $AssociatedChangesetElement[$AssociatedChangesetElement.Count-1].fields.ChangesetId
        }
        else
        {
            $ChangesetId = $AssociatedChangesetElement.fields.ChangesetId
        }

        # Return the Changeset Id (or null if it's not found)
		return $ChangesetId
	}

	catch
	{
		Write-Host "Failed to get the Associated Changeset Id, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Wait for a build to finish 
function Wait-BuildToFinish_XAML
{
    <#
        .SYNOPSIS
        Wait for a build to finish

        .DESCRIPTION
        Wait for a build to finish using the TFS Rest API version 1.0 (to get BuildInfo)
        https://www.visualstudio.com/en-us/docs/integrate/api/xamlbuild/builds#get-a-build

        .PARAMETER BuildId
		BuildId for the build to wait for
		Example: "367"

        .PARAMETER Timeout
		Maximum minutes to wait
        Optional Parameter
        Default Value: 5 
		Example: 7

        .PARAMETER SleepInterval
		Seconds to wait between each check
        Optional Parameter
        Default Value: 5 
		Example: 10

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Wait-BuildToFinish_XAML -BuildId "367" -Timeout "7" -SleepInterval "10" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns $true if build finish, $false if timeout is reached, $null if exception occur
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        [string]$BuildId,
        [Parameter(Mandatory=$false)]
        [int]$Timeout = 5,
        [Parameter(Mandatory=$false)]
        [int]$SleepInterval = 5,
        [Parameter(Mandatory=$true)]
        [string]$CollectionUrl,
        [Parameter(Mandatory=$true)]
        [string]$TeamProject,
        [Parameter(Mandatory=$true)]
        [string]$Credentials
    )
    
    try
    {
        $timeout = new-timespan -Minutes $Timeout
        $sw = [diagnostics.stopwatch]::StartNew()
        while ($sw.elapsed -lt $timeout)
        {
            $apiVersion = "1.0"
		    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
            $requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds/$BuildId" + "?api-version=$apiVersion"
		    $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		    $buildInfo = $response | ConvertFrom-Json

            if($buildInfo.status -ne "inProgress")
            {
                Write-Host "Build {$BuildId} finished" -ForegroundColor Cyan
                return $true
            }

            $output = "Waiting for the build {$BuildId} to finish ("+ $sw.elapsed.Seconds + " seconds)"
            Write-Host $output -ForegroundColor Gray
            start-sleep -seconds $SleepInterval
        }
 
        Write-Host "Error, Timeout waiting for build {$BuildId} to finish" -ForegroundColor Yellow
        return $false
    }

    catch
    {
        Write-Host "Unexpected Error waiting for build {$BuildId} to finish, Exception $_" -ForegroundColor Red
        return $null
    }
}

#======================================================================================================#
# Builds (VNEXT)
# https://www.visualstudio.com/en-us/docs/integrate/api/build/overview
#======================================================================================================#

# Get BuidDefinitionId from BuildDefinitionName
function Get-BuildDefinitionId
{
    <#
        .SYNOPSIS
        Get a build definition from a BuildDefinitionName

        .DESCRIPTION
        Get a build definition from a BuildDefinitionName using the TFS Rest API version 2.0
        https://www.visualstudio.com/en-us/docs/integrate/api/build/definitions#get-a-build-definition

        .PARAMETER BuildDefinitionName
        Name of the Build Definition
        Example: MyBuildName

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildDefinitionId -BuildDefinitionName "MyBuildName" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuildDefinitionId for the build "MyBuildName" (as string)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildDefinitionName,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "2.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
		$requestUrl = "$CollectionUrl/$TeamProject/_apis/build/definitions?name=$BuildDefinitionName" + "&api-version=$apiVersion"
        $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$buildDefinitionIdJson = $response | ConvertFrom-Json | Select value
		$buildDefinitionId = $buildDefinitionIdJson.value[0].id
		return $buildDefinitionId
	}

	catch
	{
        Write-Host "Failed to get BuildDefinitionId for build {$BuildDefinitionName}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get BuildInfo from BuildId
function Get-BuildInfo
{
    <#
        .SYNOPSIS
        Get a build information from a specific build

        .DESCRIPTION
        Get a build information from the specified build using the TFS Rest API version 2.0
        https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#get-a-build

        .PARAMETER BuildId
        The build Id
        Example: 373

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildInfo -BuildId "373" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuildInfo for the specified build (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "2.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds/$BuildId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$buildInfo = $response | ConvertFrom-Json
		return $buildInfo
	}

	catch
	{
        Write-Host "Failed to get the BuildInfo for build {$BuildId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get BuildDetails from BuildId
function Get-BuildDetails
{
    <#
        .SYNOPSIS
        Get a build details from a specific build

        .DESCRIPTION
        Get a build details from the specified build using the TFS Rest API version 2.0
        https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#get-build-details

        .PARAMETER BuildId
        The build Id
        Example: 373

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildDetails -BuildId "373" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuildDetails for the specified build (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

    try
	{
		$apiVersion = "2.0"
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds/$BuildId/timeline " + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$buildDetails = $response | ConvertFrom-Json
		return $buildDetails
	}

	catch
	{
        Write-Host "Failed to get BuildDetails for build {$BuildId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get BuildId from BuildDefinitionId and BuildNumber
function Get-BuildIdFromBuildNumber
{
    <#
        .SYNOPSIS
        Get a BuildId from it's BuildDefinitionName and it's BuildNumber

        .DESCRIPTION
        Get a BuildId from it's BuildDefinitionName and it's BuildNumber using the TFS Rest API version 2.0
        https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#get-a-list-of-builds

        .PARAMETER BuildDefinitionName
        Name of the Build Definition
        Example: MyBuildName

        .PARAMETER BuildNumber
        Build Number
        Example: MyBuildName_1.1.0

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildIdFromBuildNumber -BuildDefinitionName "MyBuildName" -BuildNumber "MyBuildName_1.1.0" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuildId for the build "MyBuildName_1.1.0" (as string)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildDefinitionId,
        [Parameter(Mandatory=$true)]
        $BuildNumber,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

    try
    {
	    $apiVersion = "2.0"
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
		$requestUrl = "$CollectionUri/$TeamProject/_apis/build/builds?definitions=$BuildDefinitionId&buildNumber=$BuildNumber" + "&api-version=$apiVersion"
        $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$buildIdJson = $response | ConvertFrom-Json | Select value
		$buildId = $buildIdJson.value[0].id
		return $buildId
    }

    catch
    {
        Write-Host "Failed to get BuildId from Build {$BuildDefinitionId, $BuildNumber}, Exception: $_" -ForegroundColor Red
		return $null
    }
}

# Get Build Reason from BuildId
function Get-BuildReason
{
    <#
        .SYNOPSIS
        Get a build reason from a specific build

        .DESCRIPTION
        Get a build reason of the specified build using the TFS Rest API version 2.0
        https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#get-a-build

        .PARAMETER BuildId
        The build Id
        Example: 373

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildReason -BuildId "373" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the Build Reason for the specified build (as string)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
		$apiVersion = "2.0"
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds/$BuildId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
        $buildReasonJson = $response | ConvertFrom-Json | Select reason
		$buildReason = $buildReasonJson.reason
		return $buildReason
	}

	catch
	{
		Write-Host "Failed to get the Build Reason for build {$BuildId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get BuidDefinitionInfo from BuildDefinitionId
function Get-BuildDefinitionInfo
{
    <#
        .SYNOPSIS
        Get BuidDefinitionInfo from BuildDefinitionId

        .DESCRIPTION
        Get BuidDefinitionInfo from BuildDefinitionId using the TFS Rest API version 2.0
        https://www.visualstudio.com/en-us/docs/integrate/api/build/definitions#get-a-build-definition

        .PARAMETER BuildDefinitionId
        The build definition Id
        Example: 37

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-BuildDefinitionInfo -BuildId "37" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the BuidDefinitionInfo (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildDefinitionId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "2.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
		$requestUrl = "$CollectionUrl/$TeamProject/_apis/build/definitions/$BuildDefinitionId" + "?api-version=$apiVersion"
        $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
        return $response.Content
	}

	catch
	{
        Write-Host "Failed to get BuildDefinitionInfo from BuildDefinition {$BuildDefinitionId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Queue build (also with parameters)
function Start-QueueBuild
{
    <#
        .SYNOPSIS
        Queue New Build (also with parameters)

        .DESCRIPTION
        Queue new build using the TFS Rest API version 2.0
        https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#queue-a-build

        .PARAMETER BuildDefinitionId
        The build definition Id
        Example: 37

        .PARAMETER Parameters
        Build parameters
        Example: @{ParamName = ParamValue}

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Start-QueueBuild -BuildDefinitionId "37" -Parameters @{ParamName = ParamValue} -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the response from the queue request, including the created build Id (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuildDefinitionId,
        [Parameter(Mandatory=$true)]
        $Parameters,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

    try
    {
        $apiVersion = "2.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
		$body = @{ definition = @{id = $BuildDefinitionId};parameters = $Parameters }
		$requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds" + "?api-version=$apiVersion"
        $response = Invoke-RestMethod -Method Post -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Body (ConvertTo-Json $body)
		return $response
    }

    catch
    {
        Write-Host "Failed to trigger build {$BuildDefinitionId}, Exception: $_" -ForegroundColor Red
		return $null
    }
}

# Create BuidDefinition from BuidDefinitionInfo
function New-BuildDefinition
{
    <#
        .SYNOPSIS
        Create BuidDefinition from BuidDefinitionInfo

        .DESCRIPTION
        Create BuidDefinition from BuidDefinitionInfo using the TFS Rest API version 2.0
        https://www.visualstudio.com/en-us/docs/integrate/api/build/definitions#create-a-build-definition

        .PARAMETER BuidDefinitionInfo
        The Build Definition Configuration (BuildDefinitionInfo)
        Example: $info = Get-BuildDefinitionInfo ...

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        New-CreateBuildDefinition -BuidDefinitionInfo $info -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the response of the build definition creation request (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $BuidDefinitionInfo,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
		$apiVersion = "2.0"
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials))) 
        $body = $BuidDefinitionInfo
		$requestUrl = "$CollectionUri/$TeamProject/_apis/build/definitions" + "?api-version=$apiVersion"
        $response = Invoke-RestMethod -Method Post -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Body ($body)
	    return $response
    }

	catch
	{
        Write-Host "Failed to create the new BuildDefinition, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Wait for a build to finish 
function Wait-BuildToFinish
{
    <#
        .SYNOPSIS
        Wait for a build to finish

        .DESCRIPTION
        Wait for a build to finish using the TFS Rest API version 2.0 (to get BuildInfo)
        https://www.visualstudio.com/en-us/docs/integrate/api/build/builds#get-a-build

        .PARAMETER BuildId
		BuildId for the build to wait for
		Example: "367"

        .PARAMETER Timeout
		Maximum minutes to wait
        Optional Parameter
        Default Value: 5 
		Example: 7

        .PARAMETER SleepInterval
		Seconds to wait between each check
        Optional Parameter
        Default Value: 5 
		Example: 10

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Wait-BuildToFinish -BuildId "367" -Timeout "7" -SleepInterval "10" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns $true if build finish, $false if timeout is reached, $null if exception occur
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        [string]$BuildId,
        [Parameter(Mandatory=$false)]
        [int]$Timeout = 5,
        [Parameter(Mandatory=$false)]
        [int]$SleepInterval = 5,
        [Parameter(Mandatory=$true)]
        [string]$CollectionUrl,
        [Parameter(Mandatory=$true)]
        [string]$TeamProject,
        [Parameter(Mandatory=$true)]
        [string]$Credentials
    )
    
    try
    {
        $timeout = new-timespan -Minutes $Timeout
        $sw = [diagnostics.stopwatch]::StartNew()
        while ($sw.elapsed -lt $timeout)
        {
            $apiVersion = "2.0"
		    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
            $requestUrl = "$CollectionUrl/$TeamProject/_apis/build/builds/$BuildId" + "?api-version=$apiVersion"
		    $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		    $buildInfo = $response | ConvertFrom-Json

            if($buildInfo.status -ne "inProgress")
            {
                Write-Host "Build {$BuildId} finished" -ForegroundColor Cyan
                return $true
            }

            $output = "Waiting for the build {$BuildId} to finish ("+ $sw.elapsed.Seconds + " seconds)"
            Write-Host $output -ForegroundColor Yellow
            start-sleep -seconds $SleepInterval
        }
 
        Write-Host "Error, Timeout waiting for build {$BuildId} to finish" -ForegroundColor Yellow
        return $false
    }

    catch
    {
        Write-Host "Unexpected Error waiting for build {$BuildId} to finish, Exception $_" -ForegroundColor Red
        return $null
    }
}

#======================================================================================================#
# Version Control (TFVC)
# https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/overview
#======================================================================================================#

# Get ChangesetInfo from ChangesetId
function Get-ChangesetInfo
{
    <#
        .SYNOPSIS
        Get the changeset information from the ChangesetId

        .DESCRIPTION
        Get the changeset information from the ChangesetId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-a-changeset

        .PARAMETER ChangesetId
		Changeset Id
		Example: "16"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-ChangesetInfo -ChangesetId "16" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the ChangesetInformation (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $ChangesetId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/tfvc/changesets/$ChangesetId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$changesetInfo = $response | ConvertFrom-Json
		return $changesetInfo
	}

	catch
	{
		Write-Host "Failed to get the ChangesetInfo for changeset {$ChangesetId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get ChangesetChanges from ChangesetId
function Get-ChangesetChanges
{
    <#
        .SYNOPSIS
        Get the changeset changes from the ChangesetId

        .DESCRIPTION
        Get the changeset changes from the ChangesetId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-list-of-changes-in-a-changeset

        .PARAMETER ChangesetId
		Changeset Id
		Example: "16"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-ChangesetChanges -ChangesetId "16" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the changeset changes (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $ChangesetId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/tfvc/changesets/$ChangesetId/changes" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$changesetChanges = $response | ConvertFrom-Json
		return $changesetChanges
	}

	catch
	{
		Write-Host "Failed to get the ChangesetChanges for changeset {$ChangesetId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get ChangesetWorkItems from ChangesetId
function Get-ChangesetWorkItems
{
    <#
        .SYNOPSIS
        Get the work items associated to a changeset using the ChangesetId

        .DESCRIPTION
        Get the work items associated to a changeset from the ChangesetId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/changesets#get-list-of-associated-work-items

        .PARAMETER ChangesetId
		Changeset Id
		Example: "16"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-ChangesetWorkItems -ChangesetId "16" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the work items associated to a changeset (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $ChangesetId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/tfvc/changesets/$ChangesetId/workitems" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$changesetWorkItems = $response | ConvertFrom-Json
		return $changesetWorkItems
	}

	catch
	{
		Write-Host "Failed to get the Changeset WorkItems for changeset {$ChangesetId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get ShelvesetInfo from ShelvesetId and ShelvesetOwner
function Get-ShelvesetInfo
{
    <#
        .SYNOPSIS
        Get ShelvesetInfo from ShelvesetId and ShelvesetOwner

        .DESCRIPTION
        Get ShelvesetInfo from ShelvesetId and ShelvesetOwner using the TFS Rest API version 1.0-preview.1
        https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/shelvesets#get-a-shelveset

        .PARAMETER ShelvesetName
		Shelveset Name
		Example: "MyShelveset"

        .PARAMETER ShelvesetOwner
		Shelveset Owner (Display Name)
		Example: "Leon Jalfon"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-ShelvesetInfo -ShelvesetName "MyShelveset" -ShelvesetOwner "Leon Jalfon" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the shelveset information (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $ShelvesetName,
        [Parameter(Mandatory=$true)]
        $ShelvesetOwner,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0-preview.1"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/tfvc/shelvesets/$ShelvesetName;$ShelvesetOwner" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$shelvesetInfo = $response | ConvertFrom-Json
		return $shelvesetInfo
	}

	catch
	{
		Write-Host "Failed to get the ShelvesettInfo for shelveset {$ShelvesetName,$ShelvesetOwner}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get ShelvesetChanges from ShelvesetId and ShelvesetOwner
function Get-ShelvesetChanges
{
    <#
        .SYNOPSIS
        Get ShelvesetChanges from ShelvesetId and ShelvesetOwner

        .DESCRIPTION
        Get ShelvesetChanges from ShelvesetId and ShelvesetOwner using the TFS Rest API version 1.0-preview.1
        https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/shelvesets#get-a-shelveset

        .PARAMETER ShelvesetName
		Shelveset Name
		Example: "MyShelveset"

        .PARAMETER ShelvesetOwner
		Shelveset Owner (Display Name)
		Example: "Leon Jalfon"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-ShelvesetChanges -ShelvesetName "MyShelveset" -ShelvesetOwner "Leon Jalfon" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the shelveset Changes (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $ShelvesetName,
        [Parameter(Mandatory=$true)]
        $ShelvesetOwner,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0-preview.1"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/tfvc/shelvesets/$ShelvesetName;$ShelvesetOwner/changes" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$shelvesetChanges = $response | ConvertFrom-Json
		return $shelvesetChanges
	}

	catch
	{
		Write-Host "Failed to get the ShelvesetChanges from shelveset {$ShelvesetName,$ShelvesetOwner}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get ShelvesetWorkItems from ShelvesetId and ShelvesetOwner
function Get-ShelvesetWorkItems
{
    <#
        .SYNOPSIS
        Get Shelveset associated workitems from ShelvesetId and ShelvesetOwner

        .DESCRIPTION
        Get Shelveset associated workitems from ShelvesetId and ShelvesetOwner using the TFS Rest API version 1.0-preview.1
        https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/shelvesets#get-shelveset-work-items

        .PARAMETER ShelvesetName
		Shelveset Name
		Example: "MyShelveset"

        .PARAMETER ShelvesetOwner
		Shelveset Owner (Display Name)
		Example: "Leon Jalfon"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-ShelvesetWorkItems -ShelvesetName "MyShelveset" -ShelvesetOwner "Leon Jalfon" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the shelveset associated workitems (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $ShelvesetName,
        [Parameter(Mandatory=$true)]
        $ShelvesetOwner,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0-preview.1"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/tfvc/shelvesets/$ShelvesetName;$ShelvesetOwner/workitems" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$shelvesetWorkItems = $response | ConvertFrom-Json
		return $shelvesetWorkItems
	}

	catch
	{
		Write-Host "Failed to get the Shelveset WorkItems from shelveset {$ShelvesetName,$ShelvesetOwner}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get Root Branches in Collection
function Get-RootBranches
{
    <#
        .SYNOPSIS
        Get Root Branches in Collection (also including childs and deleted branches)

        .DESCRIPTION
        Get Root Branches in Collection (also including childs and deleted branches) using the TFS Rest API version 1.0-preview.1
        https://www.visualstudio.com/en-us/docs/integrate/api/tfvc/branches#get-a-list-of-root-branches

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .PARAMETER IncludeDeleted
		Include or not deleted branches
        Default: $false
		Example: $true

        .PARAMETER IncludeChildren
		Include or not children branches
        Default: $false
		Example: $true

        .EXAMPLE
        Get-RootBranches -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd" [-IncludeDeleted $true -IncludeChildren $true]
        Returns the root branches in the collection (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials,
        [Parameter(Mandatory=$true)]
        $IncludeDeleted = $false,
        [Parameter(Mandatory=$true)]
        $IncludeChildren = $false
    )

    try
    {
        $apiVersion = "1.0-preview.1"
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        if($IncludeDeleted -eq $false -and $IncludeChildren -eq $false){$requestUrl = "$CollectionUrl/_apis/tfvc/branches?api-version=$apiVersion"}
        elseif($IncludeDeleted -eq $true -and $IncludeChildren -eq $true){$requestUrl = "$CollectionUrl/_apis/tfvc/branches?includeChildren=true&includeDeleted=true&api-version=$apiVersion"}
        elseif($IncludeDeleted -eq $true){$requestUrl = "$CollectionUrl/_apis/tfvc/branches?includeDeleted=true&api-version=$apiVersion"}
        elseif($IncludeChildren -eq $true){$requestUrl = "$CollectionUrl/_apis/tfvc/branches?includeChildren=true&api-version=$apiVersion"} 
        $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
        $responseJson = $response | ConvertFrom-Json
        return $responseJson
    }

    catch
    {
        Write-Host "Failed to get Get-RootBranches from {$CollectionUrl}, Exception: $_" -ForegroundColor Red
        return $null
    }
}

#======================================================================================================#
# Work Item Tracking
# https://www.visualstudio.com/en-us/docs/integrate/api/wit/overview
#======================================================================================================#

# Get WorkItem field value from WorkItemId and WorkItemField
function Get-WorkitemFieldValue
{
    <#
        .SYNOPSIS
        Get WorkItem field value from WorkItemId and WorkItemField

        .DESCRIPTION
        Get WorkItem field value from WorkItemId and WorkItemField using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#with-specific-fields

        .PARAMETER WorkItemId
		Work Item Id
		Example: "15"

        .PARAMETER WorkItemFieldReferenceName
		Work Item Field Reference Name
		Example: "System.Title"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-WorkitemFieldValue -WorkItemId "15" -WorkItemFieldReferenceName "System.Title" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the specified value for the specified field (as string)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $WorkItemId,
        [Parameter(Mandatory=$true)]
        $WorkItemFieldReferenceName,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/wit/workitems/$WorkItemId" + "?fields=" +$WorkItemFieldReferenceName + "&api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$responseJson = $response.Content | ConvertFrom-Json
        return $responseJson.fields.$WorkItemFieldReferenceName
	}
	catch
	{
        Write-Host "Failed to get work item field value from {id: $WorkItemId, field: $WorkItemField}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get a WorkItem by WorkItemId
function Get-WorkItem
{
    <#
        .SYNOPSIS
        Get a specific work item by WorkItemId

        .DESCRIPTION
         Get a specific work item by WorkItemId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#get-a-work-item

        .PARAMETER WorkItemId
		Work Item Id
		Example: 471059

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-WorkItem -WorkItemId "471059" -TeamProject "MyProject" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the work item information (as object)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $WorkItemId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/wit/workitems/$WorkItemId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$responseJson = $response.Content | ConvertFrom-Json
        return $responseJson
	}
	catch
	{
        Write-Host "Failed get Work Item {$WorkItemId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get a WorkItem by WorkItemId
function Get-WorkItemWithLinksAndAttachments
{
    <#
        .SYNOPSIS
        Get a specific work item by WorkItemId with links and attachments

        .DESCRIPTION
         Get a specific work item by WorkItemId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#with-links-and-attachments-1

        .PARAMETER WorkItemId
		Work Item Id
		Example: 471059

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-WorkItem -WorkItemId "471059" -TeamProject "MyProject" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the work item information (as object)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $WorkItemId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/wit/workitems/$WorkItemId`?`$expand=relations" + "&api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$responseJson = $response.Content | ConvertFrom-Json
        return $responseJson
	}
	catch
	{
        Write-Host "Failed get Work Item {$WorkItemId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get a WorkItem by WorkItemId
function Get-WorkItemFullyExpanded
{
    <#
        .SYNOPSIS
        Get a specific work item by WorkItemId fully expanded

        .DESCRIPTION
         Get a specific work item by WorkItemId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#fully-expanded

        .PARAMETER WorkItemId
		Work Item Id
		Example: 471059

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-WorkItem -WorkItemId "471059" -TeamProject "MyProject" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the work item information (as object)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $WorkItemId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/wit/workitems/$WorkItemId`?`$expand=all" + "&api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$responseJson = $response.Content | ConvertFrom-Json
        return $responseJson
	}
	catch
	{
        Write-Host "Failed get Work Item {$WorkItemId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

#======================================================================================================#
# Project and Teams
# https://www.visualstudio.com/en-us/docs/integrate/api/tfs/overview
#======================================================================================================#

# Get a List of Teams in Project
function Get-TeamsInProject
{
    <#
        .SYNOPSIS
        Get a list of teams in a specific team project

        .DESCRIPTION
        Get a list of teams in a specific team project using the TFS Rest API version 2.2
        https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams#get-a-list-of-teams

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-TeamsInProject -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns a list of teams (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

    try
    {
		$apiVersion = "2.2"
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/projects/$TeamProject/teams" + "?api-version=$apiVersion"
		$response = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET
		return $response
    }

    catch
    {
        Write-Host "Failed to retrieve teams for project {$TeamProject}, Exception: $_" -ForegroundColor Red
		return $null
    }
}

# Get Team Project Teams
function Get-TeamMembers
{
    <#
        .SYNOPSIS
        Get a list of team members from a specific team

        .DESCRIPTION
        Get a list of team members from a specific team using the TFS Rest API version 2.2
        https://www.visualstudio.com/en-us/docs/integrate/api/tfs/teams#get-a-teams-members

        .PARAMETER TeamId
		Team Id
		Example: "564e8204-a90b-4432-883b-d4363c6125ca"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER TeamProject
        Team Project Name
        Example: MyProject

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-TeamMembers -TeamId "564e8204-a90b-4432-883b-d4363c6125ca" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -TeamProject "MyProject" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns a list of team members (as object)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $TeamId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

    try
    {
        $apiVersion = "2.2"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/projects/$TeamProject/teams/$TeamId/members/" + "?api-version=$apiVersion"
		$response = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET
		return $response
    }

    catch
    {
        Write-Host "Failed to retrieve team members for team {$TeamId}, Exception: $_" -ForegroundColor Red
		return $null
    }
}

#======================================================================================================#
# Test Management
# https://www.visualstudio.com/en-us/docs/integrate/api/test/overview
#======================================================================================================#

# Get all the test plans from an specific team project
function Get-TestPlansInProject
{
    <#
        .SYNOPSIS
        Get a list with all the test plans in a specific team project

        .DESCRIPTION
        Get a list of test plans in a team project using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/test/plans#get-a-list-of-test-plans

        .PARAMETER TeamProject
		Team Project Name
		Example: MyProject

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-TestPlansInProject -TeamProject "MyProject" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns a list with all the test plans in the specified team project (as object)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/test/plans" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$responseJson = $response.Content | ConvertFrom-Json
        return $responseJson.value
	}
	catch
	{
        Write-Host "Failed to get test plans from {$TeamProject}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get a specific test plan by TestPlanId
function Get-TestPlan
{
    <#
        .SYNOPSIS
        Get a specific test plan by TestPlanId

        .DESCRIPTION
        Get a specific test plan by TestPlanId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/test/plans#get-a-list-of-test-plans

        .PARAMETER TestPlanId
		Test Plan Id
		Example: 13

        .PARAMETER TeamProject
		Team Project Name
		Example: MyProject

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-TestPlan -TestPlanId "13" -TeamProject "MyProject" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns a list with all the test plans in the specified team project (as object)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $TestPlanId,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/test/plans/$TestPlanId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$responseJson = $response.Content | ConvertFrom-Json
        return $responseJson
	}
	catch
	{
        Write-Host "Failed get test plan {$TestPlanId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get a specific test case assignament information in a specific test suite
function Get-TestCaseAssignamentInSuite
{
    <#
        .SYNOPSIS
        Get a specific test case assignament information in a specific test suite

        .DESCRIPTION
        Get a specific test case by TestCaseId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/test/cases#get-a-test-case

        .PARAMETER TestPlanId
		Test Plan Id
		Example: 452760

        .PARAMETER TestSuiteId
		Test Suite Id
		Example: 471108

        .PARAMETER TestCaseId
		Test Case Id
		Example: 471059

        .PARAMETER TeamProject
		Team Project Name
		Example: MyProject

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-TestCaseAssignamentInSuite -TestPlanId "452760" -TestSuiteId "471108" -TestCaseId "471059" -TeamProject "MyProject" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the test case assignament details for a test suite (as object)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $TestPlanId,
        [Parameter(Mandatory=$true)]
        $TestSuiteId,
        [Parameter(Mandatory=$true)]
        $TestCaseId,
        [Parameter(Mandatory=$true)]
        $TeamProject,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/$TeamProject/_apis/test/plans/$TestPlanId/suites/$TestSuiteId/testcases/$TestCaseId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$responseJson = $response.Content | ConvertFrom-Json
        return $responseJson.pointAssignments
	}
	catch
	{
        Write-Host "Failed get test case assignament details for test case {$TestCaseId} in suite {$TestSuiteId} in plan {$TestPlanId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

# Get a specific test plan by TestCaseId
function Get-TestCase
{
    <#
        .SYNOPSIS
        Get a specific test case by TestCaseId

        .DESCRIPTION
        Get a specific test case by TestCaseId using the TFS Rest API version 1.0
        https://www.visualstudio.com/en-us/docs/integrate/api/wit/work-items#get-a-work-item

        .PARAMETER TestCaseId
		Test Case Id
		Example: 471059

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-TestCase -TestCaseId "471059" -TeamProject "MyProject" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns the test case information (as object)
    #>
    
    param
    (
        [Parameter(Mandatory=$true)]
        $TestCaseId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
        $apiVersion = "1.0"
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
        $requestUrl = "$CollectionUrl/_apis/wit/workitems/$TestCaseId" + "?api-version=$apiVersion"
		$response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$responseJson = $response.Content | ConvertFrom-Json
        return $responseJson
	}
	catch
	{
        Write-Host "Failed get test case {$TestCaseId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

#======================================================================================================#
# No Oficial API's
# API's used by TFS but not oficially supported
#======================================================================================================#

# Get User Email from UserId
function Get-UserEmailById
{
    <#
        .SYNOPSIS
        Get User Email from UserId

        .DESCRIPTION
        Get User Email from UserId using the TFS Rest API
        (No oficial supported API)

        .PARAMETER UserId
		User Id
		Example: "761b1cf6-b1d8-40fa-9aa0-f837823782f1"

        .PARAMETER CollectionUrl
		Team Foundation Server Collection Url
		Example: "http://tfsserver:8080/tfs/DefaultCollection"

        .PARAMETER Credentials
        Domain, username and password to access to TFS
        Example: "domain\leonj:MyP@ssw0rd"

        .EXAMPLE
        Get-UserEmailById -UserId "761b1cf6-b1d8-40fa-9aa0-f837823782f1" -CollectionUrl "http://tfsserver:8080/tfs/DefaultCollection" -Credentials "domain\leonj:MyP@ssw0rd"
        Returns a list of team members (as object)
    #>

    param
    (
        [Parameter(Mandatory=$true)]
        $UserId,
        [Parameter(Mandatory=$true)]
        $CollectionUrl,
        [Parameter(Mandatory=$true)]
        $Credentials
    )

	try
	{
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $Credentials)))
		$requestUrl = "$CollectionUrl/_apis/Identities/$UserId"
        $response = Invoke-WebRequest -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -ContentType application/json -Uri $requestUrl -Method GET -UseBasicParsing
		$userProperties = $response | ConvertFrom-Json | Select Properties
        $userEmail = $userProperties.Properties.Mail
		return $userEmail
	}

	catch
	{
        Write-Host "Failed to get user Email by Id for user {$UserId}, Exception: $_" -ForegroundColor Red
		return $null
	}
}

#======================================================================================================#


