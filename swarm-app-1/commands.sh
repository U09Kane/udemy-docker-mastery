# Networks
docker network create --driver overlay frontend
docker network create --driver overlay backend

# vote
docker service create \
    -p 80:80 \
    --network frontend \
    --replicas 2 \
    --name vote \
    bretfisher/examplevotingapp_vote

# redis
docker service create \
    --network frontend \
    --name redis \
    redis:3.2

# worker
docker service create \
    --network backend \
    --network frontend \
    --name worker \
    bretfisher/examplevotingapp_worker:java

# db
docker service create \
    -e POSTGRES_PASSWORD=mypass \
    --network backend \
    --name db \
    --mount type=volume,source=db-data,target=/var/lib/postgresql/data \
    postgres:9.4

# result
docker service create \
    --name result \
    -p 5001:80 \
    --network backend \
    bretfisher/examplevotingapp_result
