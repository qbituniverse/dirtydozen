#############################################################################
# Docker Compose [Development]
#############################################################################
# start up
docker-compose -f .cicd/docker-compose.Development.yaml up

# browse
start http://localhost:4000

# take down
docker-compose -f .cicd/docker-compose.Development.yaml down