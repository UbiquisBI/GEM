#!/bin/bash

# infiniDB bulk load sample.
# replace pentaho@infinidb.localdomain by appropriate credentials;
# replace file paths if required.

# Upload data file
echo "Uploading data file to InfiniDB server..."
cd $1
scp LOAD_$2.data pentaho@infinidb.localdomain:LOAD_$2.data
if [ "$?" != "0" ]
then
  echo "File upload failed; exiting"
  exit 1
fi


# Copy file to bulk import folder in infiniDB
echo "Moving data file to InfiniDB import folder..."
ssh -t pentaho@infinidb.localdomain sudo mv ~/LOAD_$2.data /usr/local/Calpont/data/bulk/data/import/
if [ "$?" != "0" ]
then
  echo "Could not move file to InfiniDB import folder; exiting"
  exit 1
fi

# prepare import job 
echo "Preparing InfiniDB import job..."
ssh -t pentaho@infinidb.localdomain sudo /usr/local/Calpont/bin/colxml dwh -t $2 -d '\\t' -e 0 -j 1234 -l LOAD_$2.data
if [ "$?" != "0" ]
then
  echo "InfiniDB import job set up failed; exiting"
  exit 1
fi

# run import job
echo "Running InfiniDB import job..."
ssh -t pentaho@infinidb.localdomain sudo /usr/local/Calpont/bin/cpimport -j 1234
if [ "$?" != "0" ]
then
  echo "InfiniDB import job failed; exiting"
  exit 1
fi

# cleanup
echo "Cleaning up files..."
ssh -t pentaho@infinidb.localdomain sudo rm /usr/local/Calpont/data/bulk/data/import/LOAD_$2.data
if [ "$?" != "0" ]
then
  echo "Could not delete data import file; exiting"
  exit 1
fi

echo "InfiniDB import job successful"
exit 0
