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