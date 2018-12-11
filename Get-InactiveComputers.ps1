<#
.Synopsis
Get-InactiveComputers lists user objects that have not logged in over a specified amount of time
.Description

.Parameter Domain 
Target domain
.Parameter Days
Number of days since login
.Example
Get-InactiveDomains -Domain ad.contoso.com -Days 30

Name               Description                                                       Stamp
----               -----------                                                       -----
Mickey Mouse       Testing account - Do not delete                                   2018-08-23_03:42:25
#>

Param(
    [Parameter(Mandatory = $True)]
    [string]$Domain,
    [Parameter(Mandatory = $False)]
    [string]$Days = 90
)

import-module activedirectory 
$time = (Get-Date).Adddays( - ($Days))
  
# Get all AD computers with lastLogonTimestamp less than time
Get-ADComputer -server $Domain -Filter {LastLogonTimeStamp -lt $time} -Properties Description, LastLogonTimeStamp | 
  
# Output hostname and lastLogonTimestamp into CSV 
select-object Name, Description, @{Name = "Stamp"; Expression = {[DateTime]::FromFileTime($_.lastLogonTimestamp)}} 