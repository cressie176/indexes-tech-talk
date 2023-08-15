### Indexes 101

```
docker run -d -e POSTGRES_HOST_AUTH_METHOD=trust -p 5432:5432 --name postgres postgres:13-alpine
npm i
npm run generate-test-data
npm t
```