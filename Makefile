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

sqlc:
	sqlc generate

.PHONY: postgres createdb dropdb migrateup migratedown sqlc