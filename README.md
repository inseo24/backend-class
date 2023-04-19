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
  - `000001_init_schema.down.sql`, `000001_init_schema.up.sql` 자동생성

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

<details>
  <summary>Generate CRUD Golang code from SQL with sqlc</summary>
  
  - sqlc 설치
  	```bash
	$ brew install sqlc
	```
  - sqlc 실행
	```bash
	$ sqlc init
	```

  - sqlc.yaml
  
	```yaml
	version: "2"
	sql:
	- schema: "./db/migration/"
	  queries: "./db/query/"
	  engine: "postgresql"
	  gen:
	    go: 
	      package: "db"
	      out: "./db/sqlc"
	      emit_json_tags: true
	      emit_prepared_queries: false
	      emit_interface: true
	      emit_exact_table_names: false
	      emit_empty_slices: true
	```
  
  - 위에 지정한 패키지 생성
  - query 안에 account.sql 작성
  
  	```sql
	-- name: CreateAccount :one
	INSERT INTO accounts (
	  owner,
	  balance,
	  currency
	) VALUES (
	  $1, $2, $3
	) RETURNING *;

	-- name: GetAccount :one
	SELECT * FROM accounts 
	WHERE id = $1 LIMIT 1;

	-- name: ListAccounts :many
	SELECT * FROM accounts
	ORDER BY id
	LIMIT $1 
	OFFSET $2;

	-- name: UpdateAccount :exec
	UPDATE accounts 
	SET balance = $2
	WHERE id = $1
	RETURNING *;

	-- name: DeleteAccount :exec
	DELETE FROM accounts 
	WHERE id = $1;
	```
	
  - query 실행(-> Makefile에 추가)
  	```bash
	$ sqlc generate
	```
  
  - go 패키지 설치
  	```bash
	$ go mod init
	$ go mod tidy
	```
</details>
