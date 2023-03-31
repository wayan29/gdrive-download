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

    # Mengambil ID file dari link

    fileid=$(echo "$line" | sed -e 's/.*id=\([^&]*\).*/\1/')

    echo "File ID: $fileid"

    # Mendapatkan nama file dari link Google Drive

    FILENAME=$(curl -s -L "https://drive.google.com/uc?export=download&id=${fileid}" | grep -o '="uc-name.*</span>' | sed 's/.*">//;s/<.a> .*//')

    FILENAME="${FILENAME%\"}"

    FILENAME="${FILENAME#\"}"

    echo "File Name: $FILENAME"

    # Mengunduh file dari Google Drive menggunakan gdown

    gdown "$line" 
    #-O "$FILENAME-$fileid"

  done < "$filename"

else

  echo "File tidak ditemukan"

fi
