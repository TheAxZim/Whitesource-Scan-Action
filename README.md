# Whitesource Scan Using Unified Agent

A Github action which uses the Whitesource Unified Agent to scan a given repository. This Action will auto-resolve dependencies, so no configuration file is required (unless specified).

- This action offers a quick scan of a repository with minimal configuration.
    - **For more advanced use, please include a config file. (See usage below)**
    - If you need to perform some commands beforehand, please also include the path to the script file.

    - Please raise an issue for a specific request e.g. alternative configuration. I will update this over time.
    
## Usage

### Example Usage (Quick Setup without Config File)

Uses Auto Resolve Dependencies flag.
You must have the Whitesource API key set in your Github secrets. 

```
name: Whitesource Security Scan Example

on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Run Whitesource Action
      uses: TheAxZim/Whitesource-Scan-Action
      with:
        wssUrl: https://app-eu.whitesourcesoftware.com/agent
        apiKey: ${{ secrets.WSS_API_KEY }}
        productName: 'Web/API/Mobile'
        projectName: 'My Repository'
```

### Example Usage (With Config File)

```
#To be updated
```
