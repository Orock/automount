#!/bin/sh
BASEDIR="/mnt" # path to mount devices
USER="pi" # folder owner user
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

sleep 5

echo  "${BLUE}Mounting devices...${NC}"
for PARTITION in `fdisk -l | grep -v swap | egrep -o /dev/sd.[0-9]+` ; do
  mount | grep -q "^$PARTITION"
  if [ $? -eq 1 ] ; then
    blkid $PARTITION > /dev/null

    if [ $? -eq 0 ] ; then
      #echo $PARTITION | egrep -o sd.[0-9]+
      LABEL=`blkid "$PARTITION"`
      LABEL=`echo "$LABEL" | egrep -o 'LABEL="[a-zA-Z0-9]+"'`

      if [ $LABEL!='' ]; then
        LABEL=`echo "$LABEL" | egrep -o '"[a-zA-Z0-9]+"'`
        LABEL=`echo "$LABEL" | cut -d '"' -f 2`
        MOUNTPOINT=$BASEDIR/`echo $LABEL`
        echo  "${YELLOW}${LABEL} correctly mounted${NC}"
      else
        MOUNTPOINT=$BASEDIR/`echo $PARTITION | egrep -o sd.[0-9]+`
        echo  "${YELLOW}${PARTITION} correctly mounted${NC}"
      fi

      mkdir -p $MOUNTPOINT
      mount $PARTITION $MOUNTPOINT
      chown $USER $MOUNTPOINT
    fi
  fi
done

echo "${GREEN}✓ Ready${NC}"

exit 0