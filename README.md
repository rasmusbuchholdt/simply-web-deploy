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
          source-path: "daddy"
```

---

### Requirements
- Administrator access to the simply.com account, in order to access the required credentials.

---

### Setup
Work in progress..