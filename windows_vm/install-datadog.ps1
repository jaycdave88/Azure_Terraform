$directoyPath="C:\Temp";
if(!(Test-Path -path $directoyPath))  
{  
    New-Item -ItemType directory -Path $directoyPath
    Write-Host "Folder path has been created successfully at: " $directoyPath
               
}
else
{
Write-Host "The given folder path $directoyPath already exists";
}

# Download the Datadog Agent
$source = 'https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-7-latest.amd64.msi'
# Destination to save the file
$destination = 'c:\temp\datadog-agent-7-latest.amd64.msi'
Invoke-WebRequest -Uri $source -OutFile $destination

# Install the DataDog Agent for Windows
Start-Process -Wait msiexec -ArgumentList "/qn /i $destination APIKEY='_API_KEY_HERE' SITE='datadoghq.com'"