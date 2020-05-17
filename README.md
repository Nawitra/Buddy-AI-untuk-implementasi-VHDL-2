# Implementasi-Simple-Soldier-Decision

Proyek Perancangan Sistem Digital Modul 10

Kelompok A7 

Abdul Fattah Ismail / 1806200255

Farid Muhammad Rahman / 1806148662

Natalia Kristian / 1806200103

Vernando Wijaya Putra / 1806200280


Pada proyek kali ini merupakan sebuah program game strategy maze yang menceritakan seseorang yang sedang bertarung dengan 2 orang musuh
dan player akan bermain sebagai "Player" dan kedua musuh akan bernama "Enemy A" dan "Enemy B". Pada awal permainan semua orang
termasuk player, enemy A dan enemy B memiliki stats yang berbeda-beda yaitu HP (Hit Point), Accuracy, dan Ammo. masing-masing
stats ini akan mempengaruhi hasil akhir dari permainan dan progress dari setiap states. Pada program ini tidak ada status menang
dan kalah, tetapi status Finish yang bisa didapatkan oleh player jika sang player berhasil melalui maze dengan kondisi tertentu yang
menandakan player bisa memasukkin state Finish dan menyelesaikan permainan. User bisa memilih secara bebas apa yang akan dilakukan oleh
sang Player, Enemy A, dan Enemy B untuk melakukan sesuatu yang mempengaruhi state berikutnya. Program ini menggunakan Finite State
Machine yang digabungkan dengan Simple Operation pada saat menghitungkan stats gain dan decrease, dan beberapa fungsi modular
untuk menghitung jumlah akhir yang dihitung berdasarkan random stats.


Gambaran cara kerja program ini adalah sebagai berikut :

1. User diarahkan untuk mengisi angka untuk Player, Enemy A, dan Enemy B.
2. Program akan mengarahkan user ke state baru dimana user diperbolehkan untuk melakukan ubah value dari tindakan
   Player, Enemy A atau Enemy B.
3. Variable En (Enable) ditentukan oleh seberapa total ammo Player dnegan total ammo Enemy A dan Enemy B.
4. Penentuan state berikutnya dipengaruhi oleh 4 parameter : Player, Enemy A, Enemy B, dan Enable.
5. User akan melalui berbagai macam states, program ini memiliki 14 states yang bisa dinikmati dan memiliki berbagai kombinasi
  kemungkinan pilihan state berdasarkan ke-empat parameter.
6. User jika berhasil melalui strategy maze ini akan bisa berhasil menuju state Finish dan player berhasil menyelesaikan permainan.

# Happy Playing!
