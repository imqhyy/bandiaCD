#!/bin/bash

# Mảng lưu trữ CD
declare -A danh_sach_CD

# Số lượng CD đang có
so_luong_CD=0

# Hàm thêm CD
themCD() {
    local ten_CD=$1
    local tac_gia=$2
    local nam_san_xuat=$3
    local the_loai=$4
    local mo_ta=$5
    local gia_ban=$6

    danh_sach_CD[$so_luong_CD,ten_CD]=$ten_CD
    danh_sach_CD[$so_luong_CD,tac_gia]=$tac_gia
    danh_sach_CD[$so_luong_CD,nam_san_xuat]=$nam_san_xuat
    danh_sach_CD[$so_luong_CD,the_loai]=$the_loai
    danh_sach_CD[$so_luong_CD,mo_ta]=$mo_ta
    danh_sach_CD[$so_luong_CD,gia_ban]=$gia_ban

    so_luong_CD=$((so_luong_CD+1))
}

inDanhSachCD() {
    printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-20s | %-12s\n" \
           "ID" "Ten CD" "Tac gia" "Nam" "The loai" "Mo ta" "Gia ban"
    echo "------------------------------------------------------------------------------------------------------------"

    for ((i=0; i<so_luong_CD; i++))
    do
        # SỬA: Khớp đúng các từ khóa đã lưu trong hàm themCD (bỏ ten_tac_gia thành tac_gia)
        printf "%-5s | %-25s | %-20s | %-6s | %-15s | %-20s | %-12s\n" \
            "$i" \
            "${danh_sach_CD[$i,ten_CD]}" \
            "${danh_sach_CD[$i,tac_gia]}" \
            "${danh_sach_CD[$i,nam_san_xuat]}" \
            "${danh_sach_CD[$i,the_loai]}" \
            "${danh_sach_CD[$i,mo_ta]}" \
            "${danh_sach_CD[$i,gia_ban]} VND"
    done
}



# Vòng lặp Menu, stop if chucnang = 0
while true
do
    #Menu tinh nang
    echo "1. Them CD"
    echo "2. Sua thong tin CD"
    echo "3. Thong tin CD day du"
    echo "4. Thong tin CD tom tat"
    echo "5. Tim CD theo the loai"
    echo "6. Tim CD theo tac gia"
    echo "7. Tim CD theo ten bai hat"
    echo "8. Ban CD"
    echo "9. In hoa don"
    echo "0. Thoat"

    read -p "Nhap chuc nang: " chuc_nang

    while true
    do
        case $chuc_nang in
            1) {
                read -p "Nhap ten CD: " ten_CD
                read -p "Nhap ten tac gia: " ten_tac_gia
                read -p "Nhap nam san xuat: " nam_san_xuat
                read -p "Nhap the loai: " the_loai
                read -p "Nhap mo ta: " mo_ta
                read -p "Nhap gia ban: " gia_ban
                themCD $ten_CD $ten_tac_gia $nam_san_xuat $the_loai $mo_ta $gia_ban
                break
            };;
            2) break;;
            3) {
                inDanhSachCD
                read -p "Nhan enter de tiep tuc..." temp
                break
            };;
            4) break;;
            5) break;;
            6) break;;
            7) break;;
            8) break;;
            9) break;;
            0) break;;
            *) {
                echo "Chuc nang khong hop le!"
                read -p "Nhap chuc nang: " chuc_nang
            };;
        esac
    done
    
    if [ $chuc_nang -eq 0 ]; then
        break;
    fi
done