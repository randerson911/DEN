#! /bin/bash

echo "Stashing the current changes"
git stash;
echo ""
echo "Pulling the latest Changes"
git pull;
echo ""
echo "Making the Shell Scripts Executable"
chmod +x *.sh
echo ""
echo "Done"