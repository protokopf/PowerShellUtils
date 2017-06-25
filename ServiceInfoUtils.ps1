<#
.Synopsis
   Checks, whether service exists.
#>
Function Check-ServiceExists
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String] $ServiceName

    )
    Begin{
        $services = Get-Service | Select-Object -ExpandProperty Name
    }

    Process{
        return $services.Contains($ServiceName);
    }
}

<#
.Synopsis
    Checks, whether provided service (by name) matches provided status.

#>
Function Check-ServiceStatus
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceName,

        [ValidateSet("Running", "Stopped")]
        [Parameter(Mandatory=$true)]
        [String]$Status
    )
    Begin{
        $statusedSevices = Get-Service | `
                                Where-Object -FilterScript { return $_.Status -eq $Status;} | `
                                Select-Object -ExpandProperty Name
    }

    Process{
        return $statusedSevices.Contains($ServiceName);
    }
}

<#
.Synopsis
   Checks, whether provided service runs under provided user name.
#>
Function Check-ServiceRunUnder
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        # Справочное описание параметра 1
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$ServiceName,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$AccountName

    )

    Begin
    {
        $servicesUnderAccount = Get-WmiObject win32_service | `
                                    Where-Object -FilterScript {return $_.StartName -eq $AccountName} | `
                                    Select-Object -ExpandProperty Name
    }
    Process
    {
        return $servicesUnderAccount.Contains($ServiceName);
    }
}

<#
.Synopsis
   Returns description of a service.
#>
Function Get-ServiceDescription
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        $ServiceName
    )

    Begin
    {
        $services = Get-WmiObject -Class win32_service
    }
    Process
    {
        return $services | Where-Object -FilterScript {$_.Name -eq $ServiceName} | 
                           Select-Object -ExpandProperty Description;
    }
}

<#
.Synopsis
   Returns state of a service.
#>
Function Get-ServiceState
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        $ServiceName
    )

    Begin
    {
        $services = Get-WmiObject -Class win32_service
    }
    Process
    {
        return $services | Where-Object -FilterScript {$_.Name -eq $ServiceName} | 
                           Select-Object -ExpandProperty State;
    }
}

<#
.Synopsis
   Returns state of a service.
#>
Function Get-ServiceStartName
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        $ServiceName
    )

    Begin
    {
        $services = Get-WmiObject -Class win32_service
    }
    Process
    {
        return $services | Where-Object -FilterScript {$_.Name -eq $ServiceName} | 
                           Select-Object -ExpandProperty StartName;
    }
}

<#
.Synopsis
   Returns specific details value of a service.
#>
Function Get-ServiceDetail
{
    [CmdletBinding()]
    [OutputType([String])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        $ServiceName,
        [Parameter(Mandatory=$true)]
        $DetailName
    )

    Begin
    {
        $services = Get-WmiObject -Class win32_service
    }
    Process
    {
        return $services | Where-Object -FilterScript {$_.Name -eq $ServiceName} | 
                           Select-Object -ExpandProperty $DetailName;
    }
}

