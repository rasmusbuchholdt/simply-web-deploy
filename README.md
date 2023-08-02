## Simply Web Deploy
Automatically deploy your projects to Simply.com or any other place that supports IIS with Web Deploy using this GitHub action. 

This action utilizes Microsoft’s own `Web Deploy 3.0+` executable, which you can read everything about [here](https://docs.microsoft.com/en-us/aspnet/web-forms/overview/deployment/web-deployment-in-the-enterprise/deploying-web-packages). Further documentation of the rules and parameters can also be seen [here](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-r2-and-2008/dd568992(v=ws.10)).

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
        uses: rasmusbuchholdt/simply-web-deploy@2.1.0
        with:
          website-name: ${{ secrets.WEBSITE_NAME }}
          server-computer-name: ${{ secrets.SERVER_COMPUTER_NAME }}
          server-username: ${{ secrets.SERVER_USERNAME }}
          server-password: ${{ secrets.SERVER_PASSWORD }}
          source-path: '\build\'
          target-path: '/my-sub-directory/'
```

---

### Requirements
- Administrator access to the simply.com account, to access the required credentials.

---

### Setup
1. Locate the repository you want to automate Simply web deployment in.
2. Select the `Actions` tab.
3. Select `Set up a workflow yourself`.
4. Copy paste one of the examples into your .yml workflow file and commit the file.
5. All the examples takes advantage of `Secrets`, so make sure you have added the required secrets to your repository. Instructions on this can be found in the [settings](#settings) section.
6. Once you have added your secrets, your new workflow should be running on every push to the branch.

---

### Settings
These settings can be either be added directly to your .yml config file or referenced from your GitHub repository `Secrets`. I strongly recommend storing any private values like `server-username` and `server-password` in `Secrets`, regardless of if the repository is private or not.

To add a secret to your repository go to the `Settings` tab, followed by `Secrets`. Here you can add your secrets and reference to them in your .yml file.

| Setting | Required | Example | Default Value | Description |
|-|-|-|-|-|
| `website-name`          | Yes | `sub.example.com` | | Deployment destination server |
| `server-computer-name`  | Yes | `https://nt8.unoeuro.com:8172` | | Computer name, including the port - Find yours [here](https://www.simply.com/dk/support/faq/asp/236/)|
| `server-username`       | Yes | `username`        | | Your Simply FTP username |
| `server-password`       | Yes | `password`        | | Your Simply FTP password |
| `source-path`           | No | `\my-build\dist\`  | `\publish\` | The path to the source directory that will be deployed |
| `target-path`           | No | `/sub-directory/`  | `''` (Root of your website)  | The path where the source directory will be deployed (relative to website root) |
| `target-delete`         | No | `true`             | `false` | Delete files on the target computer that do not exist on the source computer |
| `skip-directory-path`   | No | `\\App_Data`       | `''` | Skip any operations on a specific directory |
---

# Common examples
#### Build and publish .NET Core API

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
        uses: rasmusbuchholdt/simply-web-deploy@2.1.0
        with:
          website-name: ${{ secrets.WEBSITE_NAME }}
          server-computer-name: ${{ secrets.SERVER_COMPUTER_NAME }}
          server-username: ${{ secrets.SERVER_USERNAME }}
          server-password: ${{ secrets.SERVER_PASSWORD }}
```

#### Build and publish Angular application

```yml
name: Build, publish and deploy project to Simply

on: [push]

jobs:
  build_and_deploy:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v1

      - name: Build application
      - run: npm ci && ng build --configuration production --output-path=dist

      - name: Deploy to Simply
        uses: rasmusbuchholdt/simply-web-deploy@2.1.0
        with:
          website-name: ${{ secrets.WEBSITE_NAME }}
          server-computer-name: ${{ secrets.SERVER_COMPUTER_NAME }}
          server-username: ${{ secrets.SERVER_USERNAME }}
          server-password: ${{ secrets.SERVER_PASSWORD }}
          source-path: '\dist\'
          target-delete: true
```
