## Simply Web Deploy
Automatically deploy your projects to Simply with Web Deploy using this GitHub action.

---

### Example
Place the following in `/.github/workflows/main.yml`
```yml
name: Build project and deploy to Simply
on: [push]

jobs:
  build_and_deploy:
    name: Build package and deploy to Simply
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v1
      - name: Deploy to Simply
        uses: RasmusBuchholdt/simply-web-deploy@1.0.0
        with:
          website-name: ${{ secrets.WEBSITE_NAME }}
          server-computer-name: ${{ secrets.SERVER_COMPUTER_NAME }}
          server-username: ${{ secrets.SERVER_USERNAME }}
          server-password: ${{ secrets.SERVER_PASSWORD }}
          source-path: '\build\'
          target-path: '\my-sub-directory\'
```

---

### Requirements
- Administrator access to the simply.com account, in order to access the required credentials.

---

### Setup
Work in progress..

---

### Settings
These settings can be either be added directly to your .yml config file or referenced from your GitHub repository `Secrets`. I strongly recommend storing any private values like `server-username` and `server-password` in `Secrets`, regardless if the repository is private or not.

In order to add a secret to your repository go to the `Settings` tab, followed by `Secrets`. Here you can add your secrets and reference to them in your .yml file.

| Setting | Required | Example | Default Value | Description |
|-|-|-|-|-|
| `website-name`          | Yes | `sub.example.com` | | Deployment destination server |
| `server-computer-name`  | Yes | `https://nt8.unoeuro.com:8172` | | Computer name, including the port - Find yours [here](https://www.simply.com/dk/support/faq/asp/236/)|
| `server-username`       | Yes | `username`        | | Your Simply FTP username |
| `server-password`       | Yes | `password`        | | Your Simply FTP password |
| `source-path`           | No | `\my-build\dist\` | `\publish\` | The path to the source directory that will be deployed |
| `target-path`           | No | `/sub-directory/`  | `''` (Root of your website)  | The path where the source directory will be deployed (relative to website root) |
---

# Common Examples
#### Build and Publish .NET Core API

```yml
name: Build, publish and deploy project to Simply

on: [push]

jobs:
  build_and_deploy:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v1
      - name: Setup .NET Core
        uses: actions/setup-dotnet@v1
        with:
          dotnet-version: 3.1

      - name: Install dependencies
        run: dotnet restore

      - name: Build
        run: dotnet build --configuration Release --no-restore

      - name: Publish
        run: dotnet publish [YOUR_PROJECT_NAME]/[YOUR_PROJECT_NAME].csproj --configuration Release --framework netcoreapp3.1 --output ./publish --runtime win-x86 --self-contained true -p:PublishTrimmed=false -p:PublishSingleFile=false

      - name: Test with .NET
        run: dotnet test

      - name: Deploy to Simply
        uses: RasmusBuchholdt/simply-web-deploy@1.0.0
        with:
          website-name: ${{ secrets.WEBSITE_NAME }}
          server-computer-name: ${{ secrets.SERVER_COMPUTER_NAME }}
          server-username: ${{ secrets.SERVER_USERNAME }}
          server-password: ${{ secrets.SERVER_PASSWORD }}
```