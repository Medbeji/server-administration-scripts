#!/bin/bash


CONTAINER_ID=`sudo docker ps -a | grep mongo | cut -d " " -f1`
MONGO_DATABASE="your_database_name"
APP_NAME="your_app_name"
MONGO_CONTAINER_DATABASE_PATH="path_where_you_exported_the_mongo_database_inside_container"
MONGO_HOST="127.0.0.1"
MONGO_PORT="27017"
TIMESTAMP=`date +%F-%H%M`
BACKUPS_DIR="/mnt/backups/$APP_NAME"
BACKUP_NAME="$APP_NAME-$TIMESTAMP"
 
if [ ! -d "$BACKUPS_DIR" ]; then
  #  if $BACKUPS_DIR doesn't exist.
  sudo mkdir -p $BACKUPS_DIR
fi 
# here we do the export of the database
# mongodump -d $MONGO_DATABASE -o $BACKUPS_DIR
# cd $BACKUPS_DIR
# mv $MONGO_DATABASE $BACKUP_NAME

# export the database from the container 
sudo docker exec -it $CONTAINER_ID mongodump -d $MONGO_DATABASE -o $MONGO_CONTAINER_DATABASE_PATH

# copy the exported database from outside the container 
sudo docker cp $CONTAINER_ID:$MONGO_CONTAINER_DATABASE_PATH/$MONGO_DATABASE /mnt/backups/$APP_NAME

# rename it to the actual date 
cd /mnt/backups/$APP_NAME
mv $MONGO_DATABASE $BACKUP_NAME

BUCKET="your_s3_bucket"
# upload to s3 
aws s3 sync $BACKUP_NAME s3://$BUCKET/$BACKUP_NAME --region us-east-1


