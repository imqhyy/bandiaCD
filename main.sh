#!/bin/bash

# Mảng lưu trữ CD
declare -A danh_sach_CD

# Số lượng CD đang có
so_luong_CD=0

#Doc du lieu tu file
file_input="CD.txt"
while IFS="|" read -r ten_CD_temp tac_gia_temp nam_san_xuat_temp the_loai_temp gia_ban_temp mo_ta_temp
do
    # Loại bỏ ký tự \r thừa bằng cơ chế xoá chuỗi của Bash
    # Trong Window khi xuống dòng sẽ kèm cả \r\n nhưng trong linux chỉ có \n
    # Điều này làm cho Bash khi đọc tới kí tự \r nó nhảy về đầu dòng và làm mất nội dung
    mo_ta_temp="${mo_ta_temp%$'\r'}"
    # Gán trực tiếp vào mảng danh_sach_CD dựa trên chỉ số so_luong_CD hiện tại
    danh_sach_CD[$so_luong_CD,ten_CD]="$ten_CD_temp"
    danh_sach_CD[$so_luong_CD,tac_gia]="$tac_gia_temp"
    danh_sach_CD[$so_luong_CD,nam_san_xuat]="$nam_san_xuat_temp"
    danh_sach_CD[$so_luong_CD,the_loai]="$the_loai_temp"
    danh_sach_CD[$so_luong_CD,gia_ban]="$gia_ban_temp"
    danh_sach_CD[$so_luong_CD,mo_ta]="$mo_ta_temp"
    

    # Tăng số lượng CD lên 1
    so_luong_CD=$((so_luong_CD + 1))

done < "$file_input"



# Hàm thêm CD
themCD() {
    local ten_CD_temp=$1
    local tac_gia_temp=$2
    local nam_san_xuat_temp=$3
    local the_loai_temp=$4
    local gia_ban_temp=$5
    local mo_ta_temp=$6
    

    danh_sach_CD[$so_luong_CD,ten_CD]=$ten_CD_temp
    danh_sach_CD[$so_luong_CD,tac_gia]=$tac_gia_temp
    danh_sach_CD[$so_luong_CD,nam_san_xuat]=$nam_san_xuat_temp
    danh_sach_CD[$so_luong_CD,the_loai]=$the_loai_temp
    danh_sach_CD[$so_luong_CD,gia_ban]=$gia_ban_temp
    danh_sach_CD[$so_luong_CD,mo_ta]=$mo_ta_temp
    

    so_luong_CD=$((so_luong_CD+1))
}


inDanhSachCD() {
    printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-12s\n" \
           "ID" "Ten CD" "Tac gia" "Nam" "The loai" "Gia ban"
    echo "---------------------------------------------------------------------------------------------"

    for ((i=0; i<so_luong_CD; i++))
    do
        # Khởi tạo lại biến cục bộ sau mỗi vòng lặp CD
        local ID_temp=$i
        local ten_CD_temp=${danh_sach_CD[$i,ten_CD]}
        local tac_gia_temp=${danh_sach_CD[$i,tac_gia]}
        local nam_san_xuat_temp=${danh_sach_CD[$i,nam_san_xuat]}
        local the_loai_temp=${danh_sach_CD[$i,the_loai]}
        local gia_ban_temp="${danh_sach_CD[$i,gia_ban]} VND"
        local mo_ta_temp=${danh_sach_CD[$i,mo_ta]}
        

        
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
            printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-12s\n" \
            "$ID_out" \
            "$ten_CD_out" \
            "$tac_gia_out" \
            "$nam_san_xuat_out" \
            "$the_loai_out" \
            "$gia_ban_out"
        done
    done
}

inChiTietCD() {
    local ID_CD_temp=$1
    local ten_CD_temp=${danh_sach_CD[$ID_CD_temp,ten_CD]}
    local tac_gia_temp=${danh_sach_CD[$ID_CD_temp,tac_gia]}
    local nam_san_xuat_temp=${danh_sach_CD[$ID_CD_temp,nam_san_xuat]}
    local the_loai_temp=${danh_sach_CD[$ID_CD_temp,the_loai]}
    local mo_ta_temp=${danh_sach_CD[$ID_CD_temp,mo_ta]}
    local gia_ban_temp="${danh_sach_CD[$ID_CD_temp,gia_ban]} VND"

    #In ra man hinh
    echo "=================================================="
    echo "Thong tin chi tiet CD (ID: $ID_CD_temp)"
    echo "=================================================="

    local line=1
    printf "%-16s" "- Ten CD:"
    while [[ $ten_CD_temp != "" ]]
    do
        # 1. Xử lý Tên CD (tối đa 37 ký tự)
        if ((${#ten_CD_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                if [[ "${ten_CD_temp:$j-1:1}" == " " ]]; then
                    local ten_CD_out="${ten_CD_temp:0:$j}"
                    ten_CD_temp="${ten_CD_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local ten_CD_out="${ten_CD_temp:0:37}"
                ten_CD_temp="${ten_CD_temp:37}"
            fi
        else
            local ten_CD_out="${ten_CD_temp:0}"
            ten_CD_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$ten_CD_out"
        else
            printf "%-37s\n" "$ten_CD_out"
        fi
        let line++
    done

    line=1
    printf "%-16s" "- Tac gia:"
    while [[ $tac_gia_temp != "" ]]
    do
        # 2. Xử lý Tác giả (tối đa 37 ký tự)
        if ((${#tac_gia_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                if [[ "${tac_gia_temp:$j-1:1}" == " " ]]; then
                    local tac_gia_out="${tac_gia_temp:0:$j}"
                    tac_gia_temp="${tac_gia_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local tac_gia_out="${tac_gia_temp:0:37}"
                tac_gia_temp="${tac_gia_temp:37}"
            fi
        else
            local tac_gia_out="${tac_gia_temp:0}"
            tac_gia_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$tac_gia_out"
        else
            printf "%-37s\n" "$tac_gia_out"
        fi
        let line++
    done
    
    line=1
    printf "%-16s" "- Nam san xuat:"
    while [[ $nam_san_xuat_temp != "" ]]
    do
        # 3. Xử lý Năm sản xuất (tối đa 37 ký tự)
        if ((${#nam_san_xuat_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                
                if [[ "${nam_san_xuat_temp:$j-1:1}" == " " ]]; then
                    local nam_san_xuat_out="${nam_san_xuat_temp:0:$j}"
                    nam_san_xuat_temp="${nam_san_xuat_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local nam_san_xuat_out="${nam_san_xuat_temp:0:37}"
                nam_san_xuat_temp="${nam_san_xuat_temp:37}"
            fi
        else
            local nam_san_xuat_out="${nam_san_xuat_temp:0}"
            nam_san_xuat_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$nam_san_xuat_out"
        else
            printf "%-37s\n" "$nam_san_xuat_out"
        fi
        let line++
    done

    line=1
    printf "%-16s" "- The loai:"
    while [[ $the_loai_temp != "" ]]
    do
        # 4. Xử lý Thể loại (tối đa 37 ký tự)
        if ((${#the_loai_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                
                if [[ "${the_loai_temp:$j-1:1}" == " " ]]; then
                    local the_loai_out="${the_loai_temp:0:$j}"
                    the_loai_temp="${the_loai_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local the_loai_out="${the_loai_temp:0:37}"
                the_loai_temp="${the_loai_temp:37}"
            fi
        else
            local the_loai_out="${the_loai_temp:0}"
            the_loai_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$the_loai_out"
        else
            printf "%-37s\n" "$the_loai_out"
        fi
        let line++
    done

    line=1
    printf "%-16s" "- Gia ban:"
    while [[ $gia_ban_temp != "" ]]
    do
        # 5. Xử lý Giá bán (tối đa 37 ký tự)  
        if ((${#gia_ban_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                if [[ "${gia_ban_temp:$j-1:1}" == " " ]]; then
                    local gia_ban_out="${gia_ban_temp:0:$j}"
                    gia_ban_temp="${gia_ban_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local gia_ban_out="${gia_ban_temp:0:37}"
                gia_ban_temp="${gia_ban_temp:37}"
            fi
        else
            local gia_ban_out="${gia_ban_temp:0}"
            gia_ban_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$gia_ban_out"
        else
            printf "%-37s\n" "$gia_ban_out"
        fi
        let line++
    done

    line=1
    printf "%-16s" "- Mo ta:"
    while [[ $mo_ta_temp != "" ]]
    do
   
        # 6. Xử lý Mô tả (tối đa 37 ký tự)
        if ((${#mo_ta_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                if [[ "${mo_ta_temp:$j-1:1}" == " " ]]; then
                    local mo_ta_out="${mo_ta_temp:0:$j}"
                    mo_ta_temp="${mo_ta_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local mo_ta_out="${mo_ta_temp:0:37}"
                mo_ta_temp="${mo_ta_temp:37}"
            fi
        else
            local mo_ta_out="${mo_ta_temp:0}"
            mo_ta_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$mo_ta_out"
        else
            printf "%-37s\n" "$mo_ta_out"
        fi
        let line++
    done

}


suaCD() {
    local ID_CD_temp=$1
    local ten_CD_temp=$2
    local tac_gia_temp=$3
    local nam_san_xuat_temp=$4
    local the_loai_temp=$5
    local mo_ta_temp=$6
    local gia_ban_temp=$7

    if [[ -n "$ten_CD_temp" ]]; then
        danh_sach_CD[$ID_CD_temp,ten_CD]=$ten_CD_temp
    fi

    if [[ -n "$tac_gia_temp" ]]; then
        danh_sach_CD[$ID_CD_temp,tac_gia]=$tac_gia_temp
    fi

    if [[ -n "$nam_san_xuat_temp" ]]; then
        danh_sach_CD[$ID_CD_temp,nam_san_xuat]=$nam_san_xuat_temp
    fi
    
    if [[ -n "$the_loai_temp" ]]; then
        danh_sach_CD[$ID_CD_temp,the_loai]=$the_loai_temp
    fi

    if [[ -n "$gia_ban_temp" ]]; then
        danh_sach_CD[$ID_CD_temp,gia_ban]=$gia_ban_temp
    fi

    if [[ -n "$mo_ta_temp" ]]; then
        danh_sach_CD[$ID_CD_temp,mo_ta]=$mo_ta_temp
    fi

    

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
            echo "---------------------------------------------------------------------------------------------"
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




ghiDuLieuVaoFile() {
    # Bước 1: Dùng dấu > đơn để xóa sạch nội dung cũ của file và chuẩn bị ghi mới
    # Nếu mảng trống (so_luong_CD = 0), file sẽ trở thành file rỗng sạch sẽ
    > "$file_input"

    # Bước 2: Duyệt qua từng CD trong mảng để ghi vào file
    for ((i=0; i<so_luong_CD; i++))
    do
        # Lấy dữ liệu từ mảng ra các biến tạm
        local ten=${danh_sach_CD[$i,ten_CD]}
        local tac_gia=${danh_sach_CD[$i,tac_gia]}
        local nam=${danh_sach_CD[$i,nam_san_xuat]}
        local the_loai=${danh_sach_CD[$i,the_loai]}
        local gia=${danh_sach_CD[$i,gia_ban]}
        local mo_ta=${danh_sach_CD[$i,mo_ta]}

        # Bước 3: Nối các biến lại bằng dấu | và dùng >> để ghi nối tiếp vào file
        echo "$ten|$tac_gia|$nam|$the_loai|$gia|$mo_ta" >> "$file_input"
    done
    
    echo "Da luu toan bo du lieu vao file $file_input!"
}

# Vòng lặp Menu, stop if chucnang = 0
while true
do
    #Menu tinh nang
    echo "1. Them CD"
    echo "2. Sua thong tin CD"
    echo "3. Danh sach CD"
    echo "4. Tim CD theo the loai"
    echo "5. Tim CD theo tac gia"
    echo "6. Tim CD theo ten bai hat"
    echo "7. Ban CD"
    echo "8. In hoa don"
    echo "0. Thoat"

    read -rp "Nhap chuc nang: " chuc_nang

    while true
    do
        case $chuc_nang in
            1) {
                read -rp "Nhap ten CD: " ten_CD
                read -rp "Nhap ten tac gia: " tac_gia
                read -rp "Nhap nam san xuat: " nam_san_xuat
                read -rp "Nhap the loai: " the_loai
                read -rp "Nhap gia ban: " gia_ban
                read -rp "Nhap mo ta: " mo_ta
                themCD "$ten_CD" "$tac_gia" "$nam_san_xuat" "$the_loai" "$gia_ban" "$mo_ta"
                break
            };;
            2) {

                while true
                do 
                    inDanhSachCD
                    read -rp "Nhap ID CD can sua (Nhan enter de thoat): " ID_CD

                    if [[ -z "$ID_CD" ]]; then
                        break
                    fi

                    if (( ID_CD < 0 || ID_CD >= so_luong_CD )); then
                        echo "ID khong hop le!"
                        read -rp "Nhan enter de tiep tuc..." temp
                        continue
                    fi

                    #Menu chinh sua
                    echo "Chinh sua"
                    echo "1. Ten CD"
                    echo "2. Ten tac gia"
                    echo "3. Nam san xuat"
                    echo "4. The loai"
                    echo "5. Gia ban"
                    echo "6. Mo ta"
                    echo "0. Thoat"
                    read -rp "Nhap chuc nang: " chuc_nang_2

                    ten_CD=""
                    tac_gia=""
                    nam_san_xuat=""
                    the_loai=""
                    gia_ban=""
                    mo_ta=""
                    
                    case $chuc_nang_2 in
                        1) {
                            read -rp "Nhap ten moi: " ten_CD
                            suaCD "$ID_CD" "$ten_CD" "$tac_gia" "$nam_san_xuat" "$the_loai" "$mo_ta" "$gia_ban"
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;
                            
                        2) {
                            read -rp "Nhap ten tac gia moi: " tac_gia
                            suaCD "$ID_CD" "$ten_CD" "$tac_gia" "$nam_san_xuat" "$the_loai" "$mo_ta" "$gia_ban"
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        3) {
                            read -rp "Nhap nam san xuat: " nam_san_xuat
                            suaCD "$ID_CD" "$ten_CD" "$tac_gia" "$nam_san_xuat" "$the_loai" "$mo_ta" "$gia_ban"
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        4) {
                            read -rp "Nhap the loai: " the_loai
                            suaCD "$ID_CD" "$ten_CD" "$tac_gia" "$nam_san_xuat" "$the_loai" "$mo_ta" "$gia_ban"
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        5) {
                            read -rp "Nhap gia ban: " gia_ban
                            suaCD "$ID_CD" "$ten_CD" "$tac_gia" "$nam_san_xuat" "$the_loai" "$mo_ta" "$gia_ban"
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        6) {
                            read -rp "Nhap mo ta: " mo_ta
                            suaCD "$ID_CD" "$ten_CD" "$tac_gia" "$nam_san_xuat" "$the_loai" "$mo_ta" "$gia_ban"
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        

                        0) {
                            break
                        };;

                        *) {
                            echo "Chuc nang khong hop le!"
                            read -rp "Nhan enter de tiep tuc..." temp
                        }
                    esac
                    if [ $chuc_nang_2 -eq 0 ]; then
                        break
                    fi
                done
                

                break;
            };;

            3) {
                while true
                do
                    inDanhSachCD
                    echo ""
                    echo "---------------------------------------------------------------------------------------------"
                    read -rp "Nhap ID CD muon xem chi tiet (nhan Enter de thoat): " ID_CD
                    if [[ -z "$ID_CD" ]]; then
                        break
                    fi

                    if (( $ID_CD>=0 && $ID_CD<$so_luong_CD )); then
                        inChiTietCD "$ID_CD"
                        read -rp "Nhan enter de thoat..." temp
                    else
                        echo "ID khong hop le!"
                        read -rp "Nhan enter de tiep tuc..." temp
                    fi
                done
                
                break
            };;

            4) {
                break
            };;

            5) {
                break
            };;
            
            6) {
                read -rp "Nhap ten bai hat can tim: " ten_bai_hat
                timCDTheoTenBaiHat "$ten_bai_hat"
                read -rp "Nhan enter de tiep tuc..." temp
                break
            };;
            
            7) {
                break
            };;

            8) {
                break
            };;

            0) {
                check=0
                while true
                do
                    read -rp "Ban co muon luu du lieu(y/n)?: " xac_nhan
                    case $xac_nhan in
                        "y") {
                            ghiDuLieuVaoFile
                            check=1
                            echo "Da luu thanh cong!"
                            read -rp "Nhan enter de thoat..." temp
                            break
                        };;

                        "n") {
                            check=1
                            break
                        };;

                        *) {
                            check=0
                            echo "Chuc nang khong hop le!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;
                    esac
                    if [ $check -eq 1 ]; then
                        break
                    fi
                done
                break 
            };;

            *) {
                echo "Chuc nang khong hop le!"
                read -rp "Nhap chuc nang: " chuc_nang
            };;
        esac
    done
    
    if [ $chuc_nang -eq 0 ]; then
        break;
    fi
done