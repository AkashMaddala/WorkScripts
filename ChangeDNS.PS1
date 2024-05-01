cls
$netadapter=get-netadapter | where status -eq 'up'
set-dnsclientserveraddress -interfaceindex($netadapter.ifIndex) -serveraddresses ("153.91.26.71","1.1.1.1")
pause