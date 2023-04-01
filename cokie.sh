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

    

    # Download file dari Google Drive menggunakan wget

    if wget --quiet --show-progress --continue --load-cookies cookies.txt "https://docs.google.com/uc?export=download&id=$fileid" -O "$FILENAME"; then

      echo "File $FILENAME berhasil diunduh."

    else

      # Jika gagal, tambahkan header HTTP untuk mengatasi limitasi

      echo "Mencoba mengatasi limitasi..."

      curl -c cookies.txt -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null

      confirm=$(awk '/download/ {print $NF}' cookies.txt)

      if wget --quiet --show-progress --continue --header "Cookie: download=$confirm" "https://docs.google.com/uc?export=download&id=$fileid" -O "$FILENAME"; then

        echo "File $FILENAME berhasil diunduh setelah mengatasi limitasi."

      else

        echo "Gagal mengunduh file $FILENAME."

      fi

      # Hapus file cookies.txt untuk menghindari masalah di masa depan

      rm cookies.txt

    fi

  done < "$filename"

else

  echo "File tidak ditemukan"

fi


