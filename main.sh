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

    danh_sach_CD[$so_luong_CD,ten_CD]="$ten_CD"
    danh_sach_CD[$so_luong_CD,tac_gia]="$tac_gia"
    danh_sach_CD[$so_luong_CD,nam_san_xuat]="$nam_san_xuat"
    danh_sach_CD[$so_luong_CD,the_loai]="$the_loai"
    danh_sach_CD[$so_luong_CD,mo_ta]="$mo_ta"
    danh_sach_CD[$so_luong_CD,gia_ban]="$gia_ban"

    so_luong_CD=$((so_luong_CD+1))
}

inDanhSachCD() {
    printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-20s | %-12s\n" \
           "ID" "Ten CD" "Tac gia" "Nam" "The loai" "Mo ta" "Gia ban"
    echo "----------------------------------------------------------------------------------------------------------"

    for ((i=0; i<so_luong_CD; i++))
    do
        # Khởi tạo lại biến cục bộ sau mỗi vòng lặp CD
        local ID_temp="$i"
        local ten_CD_temp="${danh_sach_CD[$i,ten_CD]}"
        local tac_gia_temp="${danh_sach_CD[$i,tac_gia]}"
        local nam_san_xuat_temp="${danh_sach_CD[$i,nam_san_xuat]}"
        local the_loai_temp="${danh_sach_CD[$i,the_loai]}"
        local mo_ta_temp="${danh_sach_CD[$i,mo_ta]}"
        local gia_ban_temp="${danh_sach_CD[$i,gia_ban]} VND"

        
        while ((${#ID_temp}!=0 || ${#ten_CD_temp}!=0 || ${#tac_gia_temp}!=0 || ${#nam_san_xuat_temp}!=0 || ${#the_loai_temp}!=0 || ${#mo_ta_temp}!=0 || ${#gia_ban_temp}!=0))
        do
            # 1. Xử lý ID (tối đa 5 ký tự và tự động tìm vị trí để xuống dòng)
            if ((${#ID_temp}>5)); then
                local check=0
                for ((j=5; j>1; j--))
                do
                    if [[ "${ID_temp:$j-1:1}" == " " ]]; then
                        local ID_out="${ID_temp:0:$j}"
                        ID_temp="${ID_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local ID_out="${ID_temp:0:5}"
                    ID_temp="${ID_temp:5}"
                fi
            else
                local ID_out="${ID_temp:0}"
                ID_temp=""   
            fi

            


            

            # 2. Xử lý Tên CD (tối đa 25 ký tự)
            if ((${#ten_CD_temp}>25)); then
                local check=0
                for ((j=25; j>1; j--))
                do
                    if [[ "${ten_CD_temp:$j-1:1}" == " " ]]; then
                        local ten_CD_out="${ten_CD_temp:0:$j}"
                        ten_CD_temp="${ten_CD_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local ten_CD_out="${ten_CD_temp:0:25}"
                    ten_CD_temp="${ten_CD_temp:25}"
                fi
            else
                local ten_CD_out="${ten_CD_temp:0}"
                ten_CD_temp=""   
            fi

            # 3. Xử lý Tác giả (tối đa 16 ký tự)
            if ((${#tac_gia_temp}>16)); then
                local check=0
                for ((j=16; j>1; j--))
                do
                    if [[ "${tac_gia_temp:$j-1:1}" == " " ]]; then
                        local tac_gia_out="${tac_gia_temp:0:$j}"
                        tac_gia_temp="${tac_gia_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local tac_gia_out="${tac_gia_temp:0:16}"
                    tac_gia_temp="${tac_gia_temp:16}"
                fi
            else
                local tac_gia_out="${tac_gia_temp:0}"
                tac_gia_temp=""   
            fi


            # 4. Xử lý Năm sản xuất (tối đa 6 ký tự)
            if ((${#nam_san_xuat_temp}>6)); then
                local check=0
                for ((j=6; j>1; j--))
                do
                    
                    if [[ "${nam_san_xuat_temp:$j-1:1}" == " " ]]; then
                        local nam_san_xuat_out="${nam_san_xuat_temp:0:$j}"
                        nam_san_xuat_temp="${nam_san_xuat_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local nam_san_xuat_out="${nam_san_xuat_temp:0:6}"
                    nam_san_xuat_temp="${nam_san_xuat_temp:6}"
                fi
            else
                local nam_san_xuat_out="${nam_san_xuat_temp:0}"
                nam_san_xuat_temp=""   
            fi

            # 5. Xử lý Thể loại (tối đa 10 ký tự)
            if ((${#the_loai_temp}>10)); then
                local check=0
                for ((j=10; j>1; j--))
                do
                    
                    if [[ "${the_loai_temp:$j-1:1}" == " " ]]; then
                        local the_loai_out="${the_loai_temp:0:$j}"
                        the_loai_temp="${the_loai_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local the_loai_out="${the_loai_temp:0:10}"
                    the_loai_temp="${the_loai_temp:10}"
                fi
            else
                local the_loai_out="${the_loai_temp:0}"
                the_loai_temp=""   
            fi

            # 6. Xử lý Mô tả (tối đa 20 ký tự)
            if ((${#mo_ta_temp}>20)); then
                local check=0
                for ((j=20; j>1; j--))
                do
                    if [[ "${mo_ta_temp:$j-1:1}" == " " ]]; then
                        local mo_ta_out="${mo_ta_temp:0:$j}"
                        mo_ta_temp="${mo_ta_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local mo_ta_out="${mo_ta_temp:0:20}"
                    mo_ta_temp="${mo_ta_temp:20}"
                fi
            else
                local mo_ta_out="${mo_ta_temp:0}"
                mo_ta_temp=""   
            fi

            # 7. Xử lý Giá bán (tối đa 12 ký tự)  
            if ((${#gia_ban_temp}>12)); then
                local check=0
                for ((j=12; j>1; j--))
                do
                    if [[ "${gia_ban_temp:$j-1:1}" == " " ]]; then
                        local gia_ban_out="${gia_ban_temp:0:$j}"
                        gia_ban_temp="${gia_ban_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local gia_ban_out="${gia_ban_temp:0:12}"
                    gia_ban_temp="${gia_ban_temp:12}"
                fi
            else
                local gia_ban_out="${gia_ban_temp:0}"
                gia_ban_temp=""   
            fi
            
            
            # In dòng dữ liệu hiện tại
            printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-20s | %-12s\n" \
            "$ID_out" \
            "$ten_CD_out" \
            "$tac_gia_out" \
            "$nam_san_xuat_out" \
            "$the_loai_out" \
            "$mo_ta_out" \
            "$gia_ban_out"
        done
    done
}


#Hàm tìm đĩa theo tên bài hát
timCDTheoTenBaiHat(){
    local ten_bai_hat=$1
    local tim_thay=0
    for ((i=0; i<so_luong_CD; i++))
    do
        if [[ "${danh_sach_CD[$i,ten_CD]}" == *"$ten_bai_hat"* ]]
        then
            printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-20s | %-12s\n" \
                "ID" "Ten CD" "Tac gia" "Nam" "The loai" "Mo ta" "Gia ban"
            echo "------------------------------------------------------------------------------------------------------------------------------"
            printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-20s | %-12s\n" \
                "$i" \
                "${danh_sach_CD[$i,ten_CD]}" \
                "${danh_sach_CD[$i,tac_gia]}" \
                "${danh_sach_CD[$i,nam_san_xuat]}" \
                "${danh_sach_CD[$i,the_loai]}" \
                "${danh_sach_CD[$i,mo_ta]}" \
                "${danh_sach_CD[$i,gia_ban]}"               
            tim_thay=1
        fi
    done
    [[ $tim_thay -eq 0 ]] && \
        echo "Khong tim thay CD co ten bai hat $ten_bai_hat"
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
                read -rp "Nhap ten CD: " ten_CD
                read -rp "Nhap ten tac gia: " ten_tac_gia
                read -rp "Nhap nam san xuat: " nam_san_xuat
                read -rp "Nhap the loai: " the_loai
                read -rp "Nhap mo ta: " mo_ta
                read -rp "Nhap gia ban: " gia_ban
                themCD "$ten_CD" "$ten_tac_gia" "$nam_san_xuat" "$the_loai" "$mo_ta" "$gia_ban"
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
            7) {
                read -p "Nhap ten bai hat can tim: " ten_bai_hat
                timCDTheoTenBaiHat "$ten_bai_hat"
                read -p "Nhan enter de tiep tuc..." temp
                break
            };;
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