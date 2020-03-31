# Whitesource Scan Using Unified Agent

A Github action which uses the Whitesource Unified Agent to scan a given repository. This Action will auto-resolve dependencies, so no configuration file is required.

- This is a quick scan of a repository with minimal configuration.
    - For more advanced use, please fork and integrate for your own need.
    - Please raise an issue for a specific request e.g. additional configuration. I will update this over time.
    
# Example Usage

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
