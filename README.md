# Whitesource Scan Using Unified Agent

A Github action which uses the Whitesource Unified Agent to scan a given repository. This Action will auto-resolve dependencies, so no configuration file is required (unless specified).

- This action offers a quick scan of a repository with minimal configuration.
    - **For more advanced use, please include a config file. (See usage below)**
    - If you need to perform some commands beforehand, please also include the path to the script file.

    - Please raise an issue for a specific request e.g. alternative configuration. I will update this over time.
    
For Details Unified Agent configuration, please see the page [Unified Agent Configuration File and Parameters](https://whitesource.atlassian.net/wiki/spaces/WD/pages/804814917/Unified+Agent+Configuration+File+and+Parameters)

## Usage

### Example Usage (Quick Setup without Config File)

Uses the Auto Resolve Dependencies flag.
You must have the Whitesource API key set in your Github secrets. 

```yaml
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
      uses: TheAxZim/Whitesource-Scan-Action@v1.0.0
      with:
        wssUrl: https://app-eu.whitesourcesoftware.com/agent
        apiKey: ${{ secrets.WSS_API_KEY }}
        productName: 'Web/API/Mobile'
        projectName: 'My Repository'

```

### Example Usage (With Config File and optionally install file)

```yaml
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
      uses: TheAxZim/Whitesource-Scan-Action@v1.0.0
      with:
        wssUrl: https://app-eu.whitesourcesoftware.com/agent
        apiKey: ${{ secrets.WSS_API_KEY }}
        configFile: 'whitesource-fs-agent.config'
        extraCommandsFile: 'install_commands.sh'

```
