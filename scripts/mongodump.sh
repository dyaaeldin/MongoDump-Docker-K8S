#!/usr/bin/env sh
for dir in tmp mnt; do
  if [ ! -d "/$dir/$BACKUP_DIR" ]; then
     mkdir /$dir/$BACKUP_DIR 
  fi
done  

mongodump --host="$DB_SERVICE_NAME" --port="$DB_PORT" --db="$MONGODB_DATABASE" --username="$MONGODB_USERNAME" --password="$MONGODB_PASSWORD" --out="/tmp/$BACKUP_DIR"
cd /tmp
tar cvf mongodb-$(date +%d-%m-%y-%H-%M).tar $BACKUP_DIR
cp mongodb-*.tar /mnt/$BACKUP_DIR
if [ "$REMOTE_BACKUP" = "true" ];then
scp -o StrictHostKeyChecking=no -P $REMOTE_SERVER_PORT -i $KEY_PATH /tmp/mongodb-*.tar $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR
fi
rm -rf mongodb-*.tar /tmp/$BACKUP_DIR
find /mnt -mindepth 1 -mtime +$BACKUP_TIME -delete
