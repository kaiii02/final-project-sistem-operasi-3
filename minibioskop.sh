#!/bin/bash
#Program Mini Bioskop (POV : Cashier)

PILIH=1
MOVIE=1

harga_tiket=40000
harga_bayar=0

jumlah=0
price(){
	jumlah=$(dialog --inputbox "Masukkan jumlah tiket : " 15 50 3>&1 1>&2 2>&3)
	if [ $jumlah -eq 0 ]; then
		dialog --msgbox "Jumlah tidak valid" 15 50
	else
		let "harga_bayar= $jumlah * $harga_tiket"
	fi
}

judul=""
movie_list(){
	exec 3>&1
	MOVIE=$(dialog --title  "DAFTAR FILM DI MINIBIOSKOP" --menu " " 15 50 5 \
	1 "KKN di Desa Penari" \
	2 "Warkop DKI Reborn 1" \
	3 "Pengabdi Setan 2" \
	4 "Dilan 1990" \
	5 "Miracle in Cell No 7" 2>&1 1>&3)
	exec 3>&-
	if [ $MOVIE -gt 0 ] || [ $MOVIE -lt 6 ]; then
		case $MOVIE in
			1)
				judul="KKN di Desa Penari	"
				price
				clear
				;;
			2)
				judul="Warkop DKI Reborn 1	"
				price
				clear
				;;
			3)
				judul="Pengabdi Setan 2		"
				price
				clear
				;;
			4)
				judul="Dilan 1990		"
				price
				clear
				;;
			5)
 				judul="Miracle in Cell No 7	"
				price
				clear
				;;
			*)
				echo "Pilihan tidak valid"
				movie_list
				clear
				;;

		esac
	fi
}

nama=""
pnumber=""
number=""
identity(){
	nama=$(dialog --inputbox "Masukkan nama : " 15 50 3>&1 1>&2 2>&3)
	pnumber=$(dialog --inputbox "Masukkan no handphone : " 15 50 3>&1 1>&2 2>&3)
}

star=$(echo -e "\u2764\uFE0F")
rate=""
one="$star"
two="$star $star"
three="$star $star $star"
four="$star $star $star $star"
five="$star $star $star $star $star"
starrating(){
	notiket=$(dialog --inputbox "Masukkan no tiket : " 15 50 3>&1 1>&2 2>&3)
	hasil=$(grep "$notiket" database.txt)
	if [ -n "$hasil" ]; then
		exec 3>&1
		rating=$(dialog --title "RATING FILM" --menu "Seberapa love sih kamu : " 15 50 5 \
		1 "$star" 2 "$star $star" 3 "$star $star $star" \
		4 "$star $star $star $star" 5 "$star $star $star $star $star" 2>&1 1>&3)
		exec 3>&-
		case $rating in
			1)
				rate="$one"
				tanggal1=$(date +"%d-%m-%Y %H:%M:%S")
				mrate=$(grep "$notiket" database.txt | cut -f4,6)
				echo "$tanggal1	$mrate	$rate" >> movierate.txt
				clear
				dialog --msgbox "Terimakasih sudah memberi rating" 15 50
				echo " "
				;;
			2)
				rate="$two"
				tanggal1=$(date +"%d-%m-%Y %H:%M:%S")
 				mrate=$(grep "$notiket" database.txt | cut -f4,6)
				echo "$tanggal1	$mrate	$rate" >> movierate.txt
				clear
				dialog --msgbox "Terimakasih sudah memberi rating" 15 50
				echo " "
				;;
			3)
				rate="$three"
				tanggal1=$(date +"%d-%m-%Y %H:%M:%S")
 				mrate=$(grep "$notiket" database.txt | cut -f4,6)
				echo "$tanggal1	$mrate	$rate" >> movierate.txt
				clear
				dialog --msgbox "Terimakasih sudah memberi rating" 15 50
				echo " "
				;;
			4)
				rate="$four"
				tanggal1=$(date +"%d-%m-%Y %H:%M:%S")
 				mrate=$(grep "$notiket" database.txt | cut -f4,6)
				echo "$tanggal1	$mrate	$rate" >> movierate.txt
				clear
				dialog --msgbox "Terimakasih sudah memberi rating" 15 50
				echo " "
				;;
			5)
				rate="$five"
				tanggal1=$(date +"%d-%m-%Y %H:%M:%S")
 				mrate=$(grep "$notiket" database.txt | cut -f4,6)
				echo "$tanggal1	$mrate	$rate" >> movierate.txt
				clear
				dialog --msgbox "Terimakasih sudah memberi rating" 15 50
				echo " "
				;;
			*)
				clear
				dialog --msgbox "Kamu belum memberikan rating" 15 50
				main
				;;
		esac
	else
		dialog --msgbox "silahkan lakukan pemesanan tiket terlebih dahulu" 15 50
	fi

}

tanggal=$(date +"%d-%m-%Y	%H:%M:%S")
tiket(){
	echo " "
	echo "--------- TIKET MINIBIOSKOP ---------"
	echo "TANGGAL : $tanggal"
	id=$(date +\%m\%S\%d\%M)
	echo "NO TIKET	: $id"
	echo "JUDUL	: $judul"
	echo "JUMLAH	: $jumlah"
	echo "HARGA 	: $harga_bayar"
	echo "$tanggal	$pnumber	$id	$nama	$judul	$jumlah	$harga_bayar" >> database.txt
	echo " "
	echo "Terimakasih Kak $nama"
	echo "!!!TUKARKAN TIKET MAX H+7 DARI TANGGAL PEMBELIAN!!!"
}

order(){
	identity
	movie_list
	printtiket=$(tiket)
	dialog --msgbox "$printtiket" 15 50
	clear
}

checkIn(){
	idtiket=$(dialog --inputbox "Masukkan no tiket : " 15 50 3>&1 1>&2 2>&3)
	hasil=$(grep "$idtiket" database.txt)
	if [ -n "$hasil" ]; then
		dialog --msgbox "SELAMAT MENIKMATI FILM DI MINIBIOSKOP" 15 50
	else
		dialog --msgbox "!!!DATA TIDAK DITEMUKAN!!!" 15 50
		clear
		pr -h "DATABASE TICKET" database.txt | more
	fi
}

databaseTiket(){
	clear
	pr -h "DATABASE TICKET" database.txt | more
}

infoRating(){
	clear
	pr -h "INFO RATING" movierate.txt | more
}

pelanggan(){
	exec 3>&1
	pilih1=$(dialog --title "SELAMAT DATANG DI HALAMAN MINI BIOSKOP" --menu " " 15 50 3 \
	1 "Pesan Tiket Nonton" 2 "Beri Rating Film" 3 "Info Rating" 2>&1 1>&3)
	exec 3>&-
	case $pilih1 in
		1)	order ;;
		2)	starrating ;;
		3)	infoRating ;;
		*)	echo "Pilihan tidak valid" ;;
	esac
	clear
}

pegawai(){
	pass=$(dialog --inputbox "Masukkan password : " 15 50 3>&1 1>&2 2>&3)
	if [ "$pass" == "87654321" ]; then
		exec 3>&1
		pilih2=$(dialog --title "SELAMAT DATANG DI HALAMAN MINI BIOSKOP" --menu " " 15 50 4 \
		1 "Pesan Tiket Nonton" 2 "Check In" 3 "Lihat Database Tiket" 4 "Info Rating" 2>&1 1>&3)
		exec 3>&-
		case $pilih2 in
			1)	order ;;
			2)	checkIn ;;
			3)	databaseTiket ;;
			4)	infoRating ;;
			*)	echo "Pilihan tidak valid" ;;
		esac
		clear
	else
		dialog --msgbox "Password salah" 15 50
		main
	fi
	clear
}

main(){
	touch database.txt
	touch movierate.txt
	exec 3>&1
	role=$(dialog --title "SELAMAT DATANG DI HALAMAN MINI BIOSKOP" --menu " " 15 50 5 \
	1 "PELANGGAN" 2 "PEGAWAI" 2>&1 1>&3)
	exec 3>&-
	case $role in
	1)	pelanggan ;;
	2)	pegawai ;;
	*)	echo "Pilihan tidak valid" ;;
	esac
}
main
