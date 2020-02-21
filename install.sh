#!/bin/sh

# Check if inside a virtualenv
if [[ "$VIRTUAL_ENV" == "" ]]
then
  echo "Not inside virtualenv"
  exit 1
fi

# Directories
CURRENT_DIR=`pwd`
BUILD_DIR=`pwd`/build

# Create temporary build directory
mkdir $BUILD_DIR && cd $BUILD_DIR

# Paip part
git clone https://github.com/dhconnelly/paip-python
mv paip-python/paip/ $BUILD_DIR/paip

## Setup Script
cp $CURRENT_DIR/setup-paip.py $BUILD_DIR/setup.py

pip install .

# Aima Part
git clone https://github.com/aimacode/aima-python aima

## Create this for package standard
touch $BUILD_DIR/aima/__init__.py

## Make local namespace relative (Internal aima files expect exposed namespace)
for entry in "$search_dir"$BUILD_DIR/aima/*.py
do
  previous_import=$(basename "$entry" | cut -d. -f1)
  echo $previous_import
  find $BUILD_DIR/aima/*.py -type f -exec sed -i -e "s/from\ $previous_import/from\ \.$previous_import/g" {} \;
  find $BUILD_DIR/aima/*.py -type f -exec sed -i -e "s/import\ $previous_import/import\ \.$previous_import/g" {} \;
  echo "Complete replacing"
done

## Setup Script
cp $CURRENT_DIR/setup-aima.py $BUILD_DIR/setup.py

pip install .

# Remove temporary build directory
cd $CURRENT_DIR && rm -rf $BUILD_DIR
