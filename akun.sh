
#!/bin/bash

# Meminta user untuk memasukkan email Google

echo "Masukkan email Google:"

read email

# Meminta user untuk memasukkan password Google

echo "Masukkan password Google:"

read -s password

# Login ke akun Google

google-authenticator --quiet --use-roaming --save-password <<< "$email\n$password"

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

    # Loop untuk mencoba mengunduh file hingga berhasil

    downloaded=false

    while [ $downloaded = false ]; do

      # Unduh file dari Google Drive menggunakan wget

      wget --quiet --show-progress --load-cookies cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$fileid" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$fileid" -O "$FILENAME" && rm -rf cookies.txt

      

      # Cek apakah unduhan berhasil

      if [ $? -eq 0 ]; then

        echo "File berhasil diunduh"

        downloaded=true

      else

        echo "Gagal mengunduh file, mencoba lagi..."

        sleep 5

      fi

    done

  done < "$filename"

else

  echo "File tidak ditemukan"

fi











    



