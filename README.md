# backend-class


<details>
  <summary>golang migrate 이용해 DB scheme 관리</summary>
  

- [깃허브링크](https://github.com/golang-migrate/migrate)


- 설치
  ```
  $ brew install golang-migrate
  ```
- init schema
  ```
  $ migrate create -ext sql -dir db/migration -seq init_schema
  ```
  - 000001_init_schema.down.sql, 000001_init_schema.up.sql 자동생성

- 각각 파일 채우고, Makefile 작성
  ```Makefile
  postgres:
	docker run --name postgres-container -e POSTGRES_PASSWORD=tjdls@1234 -p 5433:5432 -e POSTGRES_USER=postgres -e POSTGRES_DB=simple_bank -d postgres

  createdb:
    docker exec -it postgres-container createdb --username=postgres --owner=postgres simple_bank

  dropdb:
    docker exec -it postgres-container dropdb  --username=postgres simple_bank

  migrateup:
    migrate -path db/migration -database "postgresql://postgres:tjdls@1234@localhost:5433/simple_bank?sslmode=disable" -verbose up

  migratedown:
    migrate -path db/migration -database "postgresql://postgres:tjdls@1234@localhost:5433/simple_bank?sslmode=disable" -verbose down

  .PHONY: postgres createdb dropdb migrateup migratedown
  ```
  
  - 실행
  
    ```bash
    $ make postgres
    ```
    ```bash
    $ make createdb
    ```
    ```bash
    $ make dropdb
    ```
    ```bash
    $ make migrateup
    ```
    ```bash
    $ make migratedown
    ```
  
</details>
