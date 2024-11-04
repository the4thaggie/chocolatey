function Install-ChocoPackages
{
  # Load Chocolatey package list from a JSON file and install packages

  # Define the path to your JSON file
  $jsonFilePath = "./chocolatey-packages.json"

  # Load the JSON file
  if (Test-Path -Path $jsonFilePath) {
      try {
          $jsonData = Get-Content -Path $jsonFilePath -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
      } catch {
          Write-Error "Error: Failed to parse JSON file. Please check the file format."
          return
      }

      # Ensure that the JSON contains a 'packages' array
      if ($jsonData -and $jsonData.packages -is [System.Collections.IEnumerable]) {
          foreach ($package in $jsonData.packages) {
              if ($package -is [string] -and $package.Trim() -ne "") {
                  # Install the Chocolatey package using choco install
                  try {
                      Write-Output "Installing package: $package"
                      choco install $package -y -ErrorAction Stop
                  } catch {
                      Write-Warning "Warning: Failed to install package: $package. Please check for errors."
                  }
              } else {
                  Write-Warning "Invalid package name: $package. It should be a non-empty string."
              }
          }
      } else {
          Write-Error "Error: Invalid JSON structure. Expected an object with a 'packages' array."
          return
      }
  } else {
      Write-Error "Error: JSON file not found at the path: $jsonFilePath"
      return
  }
}

# Call the function
Install-ChocoPackages
