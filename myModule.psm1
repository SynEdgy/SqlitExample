# My Module File

function Get-myModuleConfig
{
    [CmdletBinding()]
    param
    (
        [Parameter(DontShow)]
        [string]
        $ConfigFile,

        [Parameter()]
        [switch]
        $Force
    )

    if  ($null -eq $script:MyModuleDBConfig -or $Force)
    {
        if ([string]::IsNullOrEmpty($ConfigFile))
        {
            # Retrieve configuration from the current's module config subdirectory
            $ConfigFile = Get-PSSqliteDBConfigFile
        }
        else
        {
            Write-Verbose -Message ('Loading configuration from {0}' -f $ConfigFile)
        }

        $script:MyModuleDBConfig = Get-PSSqliteDBConfig -ConfigFile $ConfigFile

    }

    return $script:MyModuleDBConfig
}

function Initialize-myModuleDB
{
    [CmdletBinding()]
    param
    (
        [Parameter(DontShow)]
        [synedgy.PSSqlite.SqliteDBConfig]
        $SqliteDBConfig = (Get-myModuleConfig),

        [Parameter()]
        [switch]
        $Force
    )

    if ($null -eq $SqliteDBConfig)
    {
        Write-Error -Message 'Configuration could not be loaded.'
        return
    }

    Write-Verbose -Message 'Initializing database...'
    Initialize-PSSqliteDatabase -DatabaseConfig $SqliteDBConfig -Verbose:$Verbose.IsPresent -Force:$Force -Debug:$Debug.IsPresent
}

function Get-Car
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [string]
        $Make,
        
        [Parameter()]
        [string]
        $Model,

        [Parameter()]
        [string]
        $Colour,

        [Parameter()]
        [int]
        $Year
    )

    $getPSSqliteRowParams = @{
        SqliteDBConfig = (Get-myModuleConfig)
        TableName = 'Cars'
        ClauseData = $PSBoundParameters
        verbose = $Verbose.IsPresent -or $VerbosePreference -in @('Continue', 'Inquire')
    }

    Get-PSSqliteRow @getPSSqliteRowParams
}

function Set-Car
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Int64]
        $id,
    
        [Parameter()]
        [string]
        $Make,

        [Parameter()]
        [string]
        $Model,

        [Parameter()]
        [string]
        $Colour,

        [Parameter()]
        [int]
        $Year
    )

    $setPSSqliteRowParams = @{
        SqliteDBConfig = (Get-myModuleConfig)
        TableName = 'Cars'
        ClauseData = @{
            id = $id
        }
        RowData = $PSBoundParameters
        verbose = $Verbose.IsPresent -or $VerbosePreference -in @('Continue', 'Inquire')
    }

    Set-PSSqliteRow @setPSSqliteRowParams
}

function New-Car
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Make,

        [Parameter(Mandatory)]
        [string]
        $Model,

        [Parameter(Mandatory)]
        [string]
        $Colour,

        [Parameter()]
        [int]
        $Year
    )

    $newPSSqliteRowParams = @{
        SqliteDBConfig = (Get-myModuleConfig)
        TableName = 'Cars'
        RowData = $PSBoundParameters
        verbose = $Verbose.IsPresent -or $VerbosePreference -in @('Continue', 'Inquire')
    }

    New-PSSqliteRow @newPSSqliteRowParams
}

function Remove-Car
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [Int64]
        $id
    )

    $removePSSqliteRowParams = @{
        SqliteDBConfig = (Get-myModuleConfig)
        TableName = 'Cars'
        ClauseData = @{
            id = $id
        }
        verbose = $Verbose.IsPresent -or $VerbosePreference -in @('Continue', 'Inquire')
    }

    Remove-PSSqliteRow @removePSSqliteRowParams
}