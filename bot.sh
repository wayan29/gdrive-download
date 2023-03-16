#!/bin/bash                                                
# Prompt user for Google Drive link                        
echo "Enter Google Drive link:"
read link                                                  
# Extract file ID from link
fileid=$(echo $link | sed -e 's/.*id=\([^&]*\).*/\1/')     
echo "File ID: $fileid"                                                                                              
FILENAME=$(curl -s -L "https://drive.google.com/uc?export=download&id=${fileid}" | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')
FILENAME="${FILENAME%\"}"
FILENAME="${FILENAME#\"}"
echo "File Name: $FILENAME"                                                                                           
# Unduh file dari Google Drive menggunakan wget            
wget --quiet --show-progress --load-cookies cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$fileid" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$fileid" -O "$FILENAME" && rm -rf cookies.txt
