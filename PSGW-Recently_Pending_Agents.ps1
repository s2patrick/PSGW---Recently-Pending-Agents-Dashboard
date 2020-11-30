# This script shows all pending Agents from a SCOM Management Group.
# Script can be used in SCOM 2012 R2 UR2 (or newer) Dashboards using PowerShell Grid Widget.
#
# Author:  Patrick Seidl
# Company: Syliance IT Services
# Website: www.syliance.com
# Blog:    www.SystemCenterRocks.com
#
# Please rate if you like it:
# https://gallery.technet.microsoft.com/systemcenter/PSGW-Recently-Pending-99fb02db

$LastDays = "-7"

$pendingAgents = Get-SCOMPendingManagement

foreach ($pendingAgent in $pendingAgents) {
    $dataObject = $ScriptContext.CreateInstance("xsd://foo!bar/baz")
    if ($pendingAgent.LastModified -ge [DateTime]::Now.AddDays($LastDays)) {
		$foundData = $true
        $dataObject["Id"] = [String]($pendingAgent.AgentName)
        $dataObject["Agent Name"] = [String]($pendingAgent.AgentName)
        $dataObject["Last Modified"] = [String]($pendingAgent.LastModified)
        $dataObject["Pending Type"] = [String]($pendingAgent.AgentPendingActionType)
    }
	if ($error) {
		$dataObject["Error"] = [String]($error)
		$error.clear()
	}
 	$ScriptContext.ReturnCollection.Add($dataObject)
}

if (!($foundData)) {
	$dataObject = $ScriptContext.CreateInstance("xsd://foo!bar/baz")
    $dataObject["Id"] = [String]("NoData")
    $dataObject["Agent Name"] = [String]("No Data within $LastDays days")
    $dataObject["Last Modified"] = [String]("")
    $dataObject["Pending Type"] = [String]("")
	$ScriptContext.ReturnCollection.Add($dataObject)
}
