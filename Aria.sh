#!/bin/bash

# Meminta user untuk memasukkan nama file

echo "Masukkan nama file:"

read filename

# Mengecek apakah file tersedia atau tidak

if [ -f "$filename" ]; then

  # Membaca isi file

  while read line; do

    # Menampilkan setiap baris

    echo "$line"

    # Extract file ID from link

    fileid=$(echo $line | sed -e 's/.*id=\([^&]*\).*/\1/')

    echo "File ID: $fileid"

    FILENAME=$(curl -s -L "https://drive.google.com/uc?export=download&id=${fileid}" | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')

    FILENAME="${FILENAME%\"}"

    FILENAME="${FILENAME#\"}"

    echo "File Name: $FILENAME"

    # Unduh file dari Google Drive menggunakan aria2c

    aria2c --split=8 --max-connection-per-server=4 --min-split-size=10M "https://docs.google.com/uc?export=download&id=$fileid" -o "$FILENAME"

  done < "$filename"

else

  echo "File tidak ditemukan"

fi
