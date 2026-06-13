#!/bin/bash

# Mảng lưu trữ CD
declare -A danh_sach_CD

# Số lượng CD đang có
so_luong_CD=0

declare -A danh_sach_HD
so_luong_HD=0

#Kiểm tra xem có thay đổi gì trong dữ liệu
data_change=0

#Doc du lieu tu file
file_input="CD.txt"
<<<<<<< HEAD
while IFS="|" read -r ten_CD_temp tac_gia_temp nam_san_xuat_temp the_loai_temp gia_ban_temp mo_ta_temp || [[ -n "$ten_CD_temp" ]]
=======
while IFS="|" read -r ten_CD_temp tac_gia_temp nam_san_xuat_temp the_loai_temp gia_ban_temp mo_ta_temp bai_hat_temp
>>>>>>> 79afb8fc07143b286cb9384c20f7a4fc6c004f4e
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
    #Do yêu cầu tìm bài hát theo tên bài hát mà mỗi CD chỉ có 1 bài nên hơi kì, nên 1 CD sẽ có nhiều bài hát
    danh_sach_CD[$so_luong_CD,bai_hat]="$bai_hat_temp"
    

    # Tăng số lượng CD lên 1
    so_luong_CD=$((so_luong_CD + 1))
    

done < "$file_input"



file_input="hoadon.txt"


while IFS="|" read -r ngay_ban khach_hang nguoi_ban so_san_pham thanh_tien ds_sanpham_raw || [[ -n "$ngay_ban" ]]
do
    ds_sanpham_raw="${ds_sanpham_raw%$'\r'}"
    ds_sanpham_raw="${ds_sanpham_raw%,}"

    danh_sach_HD[$so_luong_HD,ngay_ban]="$ngay_ban"
    danh_sach_HD[$so_luong_HD,khach_hang]="$khach_hang"
    danh_sach_HD[$so_luong_HD,nguoi_ban]="$nguoi_ban"
    danh_sach_HD[$so_luong_HD,so_san_pham]="$so_san_pham"
    danh_sach_HD[$so_luong_HD,thanh_tien]="$thanh_tien"

    
    i=0
    
    # Tách các cụm sản phẩm bằng dấu phẩy
    IFS=',' read -ra mang_san_pham_tam <<< "$ds_sanpham_raw"
    
    for cum_sp in "${mang_san_pham_tam[@]}"
    do
        if [[ -n "$cum_sp" ]]; then
            # Tách thuộc tính của từng sản phẩm bằng dấu nháy đơn
            IFS="'" read -r id_tam sl_tam dg_tam <<< "$cum_sp"
            
            danh_sach_HD[$so_luong_HD,san_pham_${i}_ID_CD]="$id_tam"
            danh_sach_HD[$so_luong_HD,san_pham_${i}_so_luong]="$sl_tam"
            danh_sach_HD[$so_luong_HD,san_pham_${i}_don_gia]="$dg_tam"
            
            i=$((i + 1))
        fi
    done

    so_luong_HD=$((so_luong_HD + 1))

done < "$file_input"


# Hàm thêm CD
themCD() {
    local ten_CD_temp=$1
    local tac_gia_temp=$2
    local nam_san_xuat_temp=$3
    local the_loai_temp=$4
    local gia_ban_temp=$5
    local mo_ta_temp=$6
    local bai_hat_temp=$7
    

    danh_sach_CD[$so_luong_CD,ten_CD]=$ten_CD_temp
    danh_sach_CD[$so_luong_CD,tac_gia]=$tac_gia_temp
    danh_sach_CD[$so_luong_CD,nam_san_xuat]=$nam_san_xuat_temp
    danh_sach_CD[$so_luong_CD,the_loai]=$the_loai_temp
    danh_sach_CD[$so_luong_CD,gia_ban]=$gia_ban_temp
    danh_sach_CD[$so_luong_CD,mo_ta]=$mo_ta_temp
    danh_sach_CD[$so_luong_CD,bai_hat]=$bai_hat_temp

    so_luong_CD=$((so_luong_CD+1))
    data_change=1
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
            # Xử lý mo_ta (để giữ điều kiện while đồng bộ, nhưng không in)
            if ((${#mo_ta_temp}>0)); then
                mo_ta_temp=""
            fi

            # 7. Xử lý Giá bán (tối đa 12 ký tự)  
            if ((${#gia_ban_temp}>12)); then
                local check=0
                for ((j=12; j>1; j--)); do
                    if [[ "${gia_ban_temp:$j-1:1}" == " " ]]; then
                        local gia_ban_out="${gia_ban_temp:0:$j}"
                        gia_ban_temp="${gia_ban_temp:$j}"
                        check=1; break
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
            local gia_ban_hien="$gia_ban_out"
            [[ -n "$gia_ban_out" ]] && gia_ban_hien="$gia_ban_out VND"
            printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-12s\n" \
            "$ID_out" \
            "$ten_CD_out" \
            "$tac_gia_out" \
            "$nam_san_xuat_out" \
            "$the_loai_out" \
            "$gia_ban_hien"
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
    #them in danh sách bài hát
    local bai_hat_temp="${danh_sach_CD[$ID_CD_temp,bai_hat]}"
    #In ra man hinh
    echo "=================================================="
    echo "Thong tin chi tiet CD (ID: $ID_CD_temp)"
    echo "=================================================="

    local line=1
    printf "%-16s" "- Ten CD:"
    if [[ $ten_CD_temp == "" ]]; then
        echo ""
    fi
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
    if [[ $tac_gia_temp == "" ]]; then
        echo ""
    fi
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
    if [[ $nam_san_xuat_temp == "" ]]; then
        echo ""
    fi
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
    if [[ $the_loai_temp == "" ]]; then
        echo ""
    fi
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
    if [[ $gia_ban_temp == "" ]]; then
        echo ""
    fi
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
    if [[ $mo_ta_temp == "" ]]; then
        echo ""
    fi
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

    printf "%-16s" "- Bai hat:"
    if [[ -z "$bai_hat_temp" ]]; then
        printf "(Chua co)\n"
    else
        local stt=1
        IFS=',' read -ra ds_bai <<< "$bai_hat_temp"
        for bai in "${ds_bai[@]}"; do
            # Trim khoảng trắng đầu
            bai="${bai#"${bai%%[![:space:]]*}"}"
            if [ $stt -eq 1 ]; then
                printf "%d. %s\n" "$stt" "$bai"
            else
                printf "%-16s%d. %s\n" "" "$stt" "$bai"
            fi
            (( stt++ ))
        done
    fi
}

inDanhSachHoaDon() {
    echo "========================================================================================="
    echo "                                   DANH SÁCH HÓA ĐƠN                                     "
    echo "========================================================================================="
    # Định dạng tiêu đề cột
    printf "%-5s | %-12s | %-20s | %-20s | %-5s | %-20s\n" \
           "ID HD" "Ngay Ban" "Khach Hang" "Nguoi Ban" "So SP" "Thanh Tien"
    echo "-----------------------------------------------------------------------------------------"

    for ((i=0; i<so_luong_HD; i++))
    do
        # Khởi tạo lại biến cục bộ sau mỗi vòng lặp CD
        local HD_ID_temp=$i
        local ngay_ban_temp=${danh_sach_HD[$i,ngay_ban]}
        local khach_hang_temp=${danh_sach_HD[$i,khach_hang]}
        local nguoi_ban_temp=${danh_sach_HD[$i,nguoi_ban]}
        local so_san_pham_temp=${danh_sach_HD[$i,so_san_pham]}
        local thanh_tien_temp="${danh_sach_HD[$i,thanh_tien]} VND"
        

        
        while ((${#HD_ID_temp}!=0 || ${#ngay_ban_temp}!=0 || ${#khach_hang_temp}!=0 || ${#nguoi_ban_temp}!=0 || ${#so_san_pham_temp}!=0 || ${#thanh_tien_temp}!=0))
        do
            # 1. Xử lý ID (tối đa 5 ký tự và tự động tìm vị trí để xuống dòng)
            if ((${#HD_ID_temp}>5)); then
                local check=0
                for ((j=5; j>1; j--))
                do
                    if [[ "${HD_ID_temp:$j-1:1}" == " " ]]; then
                        local HD_ID_out="${HD_ID_temp:0:$j}"
                        HD_ID_temp="${HD_ID_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local HD_ID_out="${HD_ID_temp:0:5}"
                    HD_ID_temp="${HD_ID_temp:5}"
                fi
            else
                local HD_ID_out="${HD_ID_temp:0}"
                HD_ID_temp=""   
            fi

            # 2. Xử lý ngày bán (tối đa 12 ký tự)
            if ((${#ngay_ban_temp}>12)); then
                local check=0
                for ((j=12; j>1; j--))
                do
                    if [[ "${ngay_ban_temp:$j-1:1}" == " " ]]; then
                        local ngay_ban_out="${ngay_ban_temp:0:$j}"
                        ngay_ban_temp="${ngay_ban_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local ngay_ban_out="${ngay_ban_temp:0:12}"
                    ngay_ban_temp="${ngay_ban_temp:12}"
                fi
            else
                local ngay_ban_out="${ngay_ban_temp:0}"
                ngay_ban_temp=""   
            fi

            # 3. Xử lý khách hàng (tối đa 20 ký tự)
            if ((${#khach_hang_temp}>20)); then
                local check=0
                for ((j=20; j>1; j--))
                do
                    if [[ "${khach_hang_temp:$j-1:1}" == " " ]]; then
                        local khach_hang_out="${khach_hang_temp:0:$j}"
                        khach_hang_temp="${khach_hang_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local khach_hang_out="${khach_hang_temp:0:20}"
                    khach_hang_temp="${khach_hang_temp:20}"
                fi
            else
                local khach_hang_out="${khach_hang_temp:0}"
                khach_hang_temp=""   
            fi


            # 4. Xử lý người bán (tối đa 20 ký tự)
            if ((${#nguoi_ban_temp}>20)); then
                local check=0
                for ((j=20; j>1; j--))
                do
                    
                    if [[ "${nguoi_ban_temp:$j-1:1}" == " " ]]; then
                        local nguoi_ban_out="${nguoi_ban_temp:0:$j}"
                        nguoi_ban_temp="${nguoi_ban_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local nguoi_ban_out="${nguoi_ban_temp:0:20}"
                    nguoi_ban_temp="${nguoi_ban_temp:20}"
                fi
            else
                local nguoi_ban_out="${nguoi_ban_temp:0}"
                nguoi_ban_temp=""   
            fi

            # 5. Xử lý số sản phẩm (tối đa 5 ký tự)
            if ((${#so_san_pham_temp}>5)); then
                local check=0
                for ((j=5; j>1; j--))
                do
                    
                    if [[ "${so_san_pham_temp:$j-1:1}" == " " ]]; then
                        local so_san_pham_out="${so_san_pham_temp:0:$j}"
                        so_san_pham_temp="${so_san_pham_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local so_san_pham_out="${so_san_pham_temp:0:5}"
                    so_san_pham_temp="${so_san_pham_temp:5}"
                fi
            else
                local so_san_pham_out="${so_san_pham_temp:0}"
                so_san_pham_temp=""   
            fi

            # 6. Xử lý thành tiền (tối đa 20 ký tự)
            if ((${#thanh_tien_temp}>20)); then
                local check=0
                for ((j=20; j>1; j--))
                do
                    if [[ "${thanh_tien_temp:$j-1:1}" == " " ]]; then
                        local thanh_tien_out="${thanh_tien_temp:0:$j}"
                        thanh_tien_temp="${thanh_tien_temp:$j}"
                        check=1
                        break
                    fi
                done
                if (($check==0)); then
                    local thanh_tien_out="${thanh_tien_temp:0:20}"
                    thanh_tien_temp="${thanh_tien_temp:20}"
                fi
            else
                local thanh_tien_out="${thanh_tien_temp:0}"
                thanh_tien_temp=""   
            fi

            
            # In dòng dữ liệu hiện tại
            printf "%-5s | %-12s | %-20s | %-20s | %-5s | %-20s\n" \
            "$HD_ID_out" \
            "$ngay_ban_out" \
            "$khach_hang_out" \
            "$nguoi_ban_out" \
            "$so_san_pham_out" \
            "$thanh_tien_out"
        done
    done


    echo "========================================================================================="
}

inChiTietHoaDon() {
    local ID=$1
    local ID_HD_temp=$1
    local ngay_ban_temp=${danh_sach_HD[$ID_HD_temp,ngay_ban]}
    local khach_hang_temp=${danh_sach_HD[$ID_HD_temp,khach_hang]}
    local nguoi_ban_temp=${danh_sach_HD[$ID_HD_temp,nguoi_ban]}
    local so_san_pham_temp=${danh_sach_HD[$ID_HD_temp,so_san_pham]}
    local thanh_tien_temp=${danh_sach_HD[$ID_HD_temp,thanh_tien]}
    

    #In ra man hinh
    echo "=================================================="
    echo "Thong tin chi tiet HD (ID: $ID_HD_temp)"
    echo "=================================================="

    local line=1
    printf "%-16s" "- Ngay ban:"
    if [[ $ngay_ban_temp == "" ]]; then
        echo ""
    fi
    while [[ $ngay_ban_temp != "" ]]
    do
        # 1. Xử lý ngày bán (tối đa 37 ký tự)
        if ((${#ngay_ban_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                if [[ "${ngay_ban_temp:$j-1:1}" == " " ]]; then
                    local ngay_ban_out="${ngay_ban_temp:0:$j}"
                    ngay_ban_temp="${ngay_ban_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local ngay_ban_out="${ngay_ban_temp:0:37}"
                ngay_ban_temp="${ngay_ban_temp:37}"
            fi
        else
            local ngay_ban_out="${ngay_ban_temp:0}"
            ngay_ban_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$ngay_ban_out"
        else
            printf "%-37s\n" "$ngay_ban_out"
        fi
        let line++
    done

    line=1
    printf "%-16s" "- Khach hang:"
    if [[ $khach_hang_temp == "" ]]; then
        echo ""
    fi
    while [[ $khach_hang_temp != "" ]]
    do
        # 2. Xử lý khách hàng (tối đa 37 ký tự)
        if ((${#khach_hang_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                if [[ "${khach_hang_temp:$j-1:1}" == " " ]]; then
                    local khach_hang_out="${khach_hang_temp:0:$j}"
                    khach_hang_temp="${khach_hang_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local khach_hang_out="${khach_hang_temp:0:37}"
                khach_hang_temp="${khach_hang_temp:37}"
            fi
        else
            local khach_hang_out="${khach_hang_temp:0}"
            khach_hang_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$khach_hang_out"
        else
            printf "%-37s\n" "$khach_hang_out"
        fi
        let line++
    done
    
    line=1
    printf "%-16s" "- Nguoi ban:"
    if [[ $nguoi_ban_temp == "" ]]; then
        echo ""
    fi
    while [[ $nguoi_ban_temp != "" ]]
    do
        # 3. Xử lý người bán (tối đa 37 ký tự)
        if ((${#nguoi_ban_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                
                if [[ "${nguoi_ban_temp:$j-1:1}" == " " ]]; then
                    local nguoi_ban_out="${nguoi_ban_temp:0:$j}"
                    nguoi_ban_temp="${nguoi_ban_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local nguoi_ban_out="${nguoi_ban_temp:0:37}"
                nguoi_ban_temp="${nguoi_ban_temp:37}"
            fi
        else
            local nguoi_ban_out="${nguoi_ban_temp:0}"
            nguoi_ban_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$nguoi_ban_out"
        else
            printf "%-37s\n" "$nguoi_ban_out"
        fi
        let line++
    done

    line=1
    printf "%-16s" "- So san pham:"
    if [[ $so_san_pham_temp == "" ]]; then
        echo ""
    fi
    while [[ $so_san_pham_temp != "" ]]
    do
        # 4. Xử lý Thể loại (tối đa 37 ký tự)
        if ((${#so_san_pham_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                
                if [[ "${so_san_pham_temp:$j-1:1}" == " " ]]; then
                    local so_san_pham_out="${so_san_pham_temp:0:$j}"
                    so_san_pham_temp="${so_san_pham_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local so_san_pham_out="${so_san_pham_temp:0:37}"
                so_san_pham_temp="${so_san_pham_temp:37}"
            fi
        else
            local so_san_pham_out="${so_san_pham_temp:0}"
            so_san_pham_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$so_san_pham_out"
        else
            printf "%-37s\n" "$so_san_pham_out"
        fi
        let line++

        
    done

    line=1
    printf "%-16s" "- Thanh tien:"
    if [[ $thanh_tien_temp == "" ]]; then
        echo ""
    fi
    while [[ $thanh_tien_temp != "" ]]
    do
        # 5. Xử lý Giá bán (tối đa 37 ký tự)  
        if ((${#thanh_tien_temp}>37)); then
            local check=0
            for ((j=37; j>1; j--))
            do
                if [[ "${thanh_tien_temp:$j-1:1}" == " " ]]; then
                    local thanh_tien_out="${thanh_tien_temp:0:$j}"
                    thanh_tien_temp="${thanh_tien_temp:$j}"
                    check=1
                    break
                fi
            done
            if (($check==0)); then
                local thanh_tien_out="${thanh_tien_temp:0:37}"
                thanh_tien_temp="${thanh_tien_temp:37}"
            fi
        else
            local thanh_tien_out="${thanh_tien_temp:0}"
            thanh_tien_temp=""   
        fi

        if [ $line -ne 1 ]; then
            printf "%-16s%-37s\n" "" "$thanh_tien_out"
        else
            printf "%-37s\n" "$thanh_tien_out"
        fi
        let line++

        printf "%-20s Danh sach san pham\n" " "
        printf "%-5s | %-20s | %-8s | %-20s\n" "ID SP" "Ten san pham" "So luong" "Don gia"
        for ((i=0; i<${danh_sach_HD[$ID,so_san_pham]}; i++))
        do
            local ID_SP_temp=${danh_sach_HD[$ID,san_pham_${i}_ID_CD]}
            local ten_SP_temp=${danh_sach_CD[$ID_SP_temp,ten_CD]}
            local so_luong_temp=${danh_sach_HD[$ID,san_pham_${i}_so_luong]}
            local don_gia_temp="${danh_sach_HD[$ID,san_pham_${i}_don_gia]} VND"

            while ((${#ID_SP_temp}!=0 || ${#ten_SP_temp}!=0 || ${#so_luong_temp}!=0 || ${#don_gia_temp}!=0))
            do
                # 1. Xử lý ID (tối đa 5 ký tự và tự động tìm vị trí để xuống dòng)
                if ((${#ID_SP_temp}>5)); then
                    local check=0
                    for ((j=5; j>1; j--))
                    do
                        if [[ "${ID_SP_temp:$j-1:1}" == " " ]]; then
                            local ID_SP_out="${ID_SP_temp:0:$j}"
                            ID_SP_temp="${ID_SP_temp:$j}"
                            check=1
                            break
                        fi
                    done
                    if (($check==0)); then
                        local ID_SP_out="${ID_SP_temp:0:5}"
                        ID_SP_temp="${ID_SP_temp:5}"
                    fi
                else
                    local ID_SP_out="${ID_SP_temp:0}"
                    ID_SP_temp=""
                fi

                # 2. Xử lý tên sản phẩm (tối đa 20 ký tự và tự động tìm vị trí để xuống dòng)
                if ((${#ten_SP_temp}>20)); then
                    local check=0
                    for ((j=20; j>1; j--))
                    do
                        if [[ "${ten_SP_temp:$j-1:1}" == " " ]]; then
                            local ten_SP_out="${ten_SP_temp:0:$j}"
                            ten_SP_temp="${ten_SP_temp:$j}"
                            check=1
                            break
                        fi
                    done
                    if (($check==0)); then
                        local ten_SP_out="${ten_SP_temp:0:20}"
                        ten_SP_temp="${ten_SP_temp:20}"
                    fi
                else
                    local ten_SP_out="${ten_SP_temp:0}"
                    ten_SP_temp=""
                fi

                # 3. Xử lý số lượng (tối đa 8 ký tự và tự động tìm vị trí để xuống dòng)
                if ((${#so_luong_temp}>8)); then
                    local check=0
                    for ((j=8; j>1; j--))
                    do
                        if [[ "${so_luong_temp:$j-1:1}" == " " ]]; then
                            local so_luong_out="${so_luong_temp:0:$j}"
                            so_luong_temp="${so_luong_temp:$j}"
                            check=1
                            break
                        fi
                    done
                    if (($check==0)); then
                        local so_luong_out="${so_luong_temp:0:8}"
                        so_luong_temp="${so_luong_temp:8}"
                    fi
                else
                    local so_luong_out="${so_luong_temp:0}"
                    so_luong_temp=""
                fi

                # 4. Xử lý đơn giá (tối đa 5 ký tự và tự động tìm vị trí để xuống dòng)
                if ((${#don_gia_temp}>20)); then
                    local check=0
                    for ((j=20; j>1; j--))
                    do
                        if [[ "${don_gia_temp:$j-1:1}" == " " ]]; then
                            local don_gia_out="${don_gia_temp:0:$j}"
                            don_gia_temp="${don_gia_temp:$j}"
                            check=1
                            break
                        fi
                    done
                    if (($check==0)); then
                        local don_gia_out="${don_gia_temp:0:20}"
                        don_gia_temp="${don_gia_temp:20}"
                    fi
                else
                    local don_gia_out="${don_gia_temp:0}"
                    don_gia_temp=""
                fi
                
                printf "%-5s | %-20s | %-8s | %-20s\n" "$ID_SP_out" \
                "$ten_SP_out" \
                "$so_luong_out" \
                "$don_gia_out"
            done
            echo "------------------------------------------------------"
            
        done


        
    done


}

suaCD() {
    local ID_CD_temp=$1
    local edit_content=$2
    local edit=$3

    if [ $edit -eq 1 ]; then
        danh_sach_CD[$ID_CD_temp,ten_CD]=$edit_content
    fi

    if [ $edit -eq 2 ]; then
        danh_sach_CD[$ID_CD_temp,tac_gia]=$edit_content
    fi

    if [ $edit -eq 3 ]; then
        danh_sach_CD[$ID_CD_temp,nam_san_xuat]=$edit_content
    fi
    
    if [ $edit -eq 4 ]; then
        danh_sach_CD[$ID_CD_temp,the_loai]=$edit_content
    fi

    if [ $edit -eq 5 ]; then
        danh_sach_CD[$ID_CD_temp,gia_ban]=$edit_content
    fi

    if [ $edit -eq 6 ]; then
        danh_sach_CD[$ID_CD_temp,mo_ta]=$edit_content
    fi
<<<<<<< HEAD

    data_change=1
    

=======
>>>>>>> 79afb8fc07143b286cb9384c20f7a4fc6c004f4e
}


inKetQuaTim() {
    local id=$1
    local ID_temp=$id
    local ten_CD_temp="${danh_sach_CD[$id,ten_CD]}"
    local tac_gia_temp="${danh_sach_CD[$id,tac_gia]}"
    local nam_san_xuat_temp="${danh_sach_CD[$id,nam_san_xuat]}"
    local the_loai_temp="${danh_sach_CD[$id,the_loai]}"
    local ton_kho_temp="${danh_sach_CD[$id,ton_kho]}"
    local gia_ban_temp="${danh_sach_CD[$id,gia_ban]}"
 
    while ((${#ID_temp}!=0 || ${#ten_CD_temp}!=0 || ${#tac_gia_temp}!=0 || ${#nam_san_xuat_temp}!=0 || ${#the_loai_temp}!=0 || ${#ton_kho_temp}!=0 || ${#gia_ban_temp}!=0))
    do
        # ID (5)
        if ((${#ID_temp}>5)); then
            local check=0
            for ((j=5; j>1; j--)); do
                if [[ "${ID_temp:$((j-1)):1}" == " " ]]; then
                    local ID_out="${ID_temp:0:$j}"; ID_temp="${ID_temp:$j}"; check=1; break
                fi
            done
            if ((check==0)); then local ID_out="${ID_temp:0:5}"; ID_temp="${ID_temp:5}"; fi
        else
            local ID_out="$ID_temp"; ID_temp=""
        fi
 
        # Ten CD (25)
        if ((${#ten_CD_temp}>25)); then
            local check=0
            for ((j=25; j>1; j--)); do
                if [[ "${ten_CD_temp:$((j-1)):1}" == " " ]]; then
                    local ten_CD_out="${ten_CD_temp:0:$j}"; ten_CD_temp="${ten_CD_temp:$j}"; check=1; break
                fi
            done
            if ((check==0)); then local ten_CD_out="${ten_CD_temp:0:25}"; ten_CD_temp="${ten_CD_temp:25}"; fi
        else
            local ten_CD_out="$ten_CD_temp"; ten_CD_temp=""
        fi
 
        # Tac gia (16)
        if ((${#tac_gia_temp}>16)); then
            local check=0
            for ((j=16; j>1; j--)); do
                if [[ "${tac_gia_temp:$((j-1)):1}" == " " ]]; then
                    local tac_gia_out="${tac_gia_temp:0:$j}"; tac_gia_temp="${tac_gia_temp:$j}"; check=1; break
                fi
            done
            if ((check==0)); then local tac_gia_out="${tac_gia_temp:0:16}"; tac_gia_temp="${tac_gia_temp:16}"; fi
        else
            local tac_gia_out="$tac_gia_temp"; tac_gia_temp=""
        fi
 
        # Nam san xuat (6)
        if ((${#nam_san_xuat_temp}>6)); then
            local check=0
            for ((j=6; j>1; j--)); do
                if [[ "${nam_san_xuat_temp:$((j-1)):1}" == " " ]]; then
                    local nam_san_xuat_out="${nam_san_xuat_temp:0:$j}"; nam_san_xuat_temp="${nam_san_xuat_temp:$j}"; check=1; break
                fi
            done
            if ((check==0)); then local nam_san_xuat_out="${nam_san_xuat_temp:0:6}"; nam_san_xuat_temp="${nam_san_xuat_temp:6}"; fi
        else
            local nam_san_xuat_out="$nam_san_xuat_temp"; nam_san_xuat_temp=""
        fi
 
        # The loai (10)
        if ((${#the_loai_temp}>10)); then
            local check=0
            for ((j=10; j>1; j--)); do
                if [[ "${the_loai_temp:$((j-1)):1}" == " " ]]; then
                    local the_loai_out="${the_loai_temp:0:$j}"; the_loai_temp="${the_loai_temp:$j}"; check=1; break
                fi
            done
            if ((check==0)); then local the_loai_out="${the_loai_temp:0:10}"; the_loai_temp="${the_loai_temp:10}"; fi
        else
            local the_loai_out="$the_loai_temp"; the_loai_temp=""
        fi
 
        # Ton kho (10)
        if ((${#ton_kho_temp}>10)); then
            local check=0
            for ((j=10; j>1; j--)); do
                if [[ "${ton_kho_temp:$((j-1)):1}" == " " ]]; then
                    local ton_kho_out="${ton_kho_temp:0:$j}"; ton_kho_temp="${ton_kho_temp:$j}"; check=1; break
                fi
            done
            if ((check==0)); then local ton_kho_out="${ton_kho_temp:0:10}"; ton_kho_temp="${ton_kho_temp:10}"; fi
        else
            local ton_kho_out="$ton_kho_temp"; ton_kho_temp=""
        fi
 
        # Gia ban (12)
        if ((${#gia_ban_temp}>12)); then
            local check=0
            for ((j=12; j>1; j--)); do
                if [[ "${gia_ban_temp:$((j-1)):1}" == " " ]]; then
                    local gia_ban_out="${gia_ban_temp:0:$j}"; gia_ban_temp="${gia_ban_temp:$j}"; check=1; break
                fi
            done
            if ((check==0)); then local gia_ban_out="${gia_ban_temp:0:12}"; gia_ban_temp="${gia_ban_temp:12}"; fi
        else
            local gia_ban_out="$gia_ban_temp"; gia_ban_temp=""
        fi
 
        local gia_ban_hien="$gia_ban_out"
        [[ -n "$gia_ban_out" ]] && gia_ban_hien="$gia_ban_out VND"
 
        printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-10s | %-12s\n" \
            "$ID_out" "$ten_CD_out" "$tac_gia_out" "$nam_san_xuat_out" \
            "$the_loai_out" "$ton_kho_out" "$gia_ban_hien"
    done
}
 
inHeaderTim() {
    printf "%-5s | %-25s | %-16s | %-6s | %-10s | %-10s | %-12s\n" \
        "ID" "Ten CD" "Tac gia" "Nam" "The loai" "Ton kho" "Gia ban"
    echo "----------------------------------------------------------------------------------------------------"
}



timCDTheoTheLoai() {
    # In ra gợi ý thể loại hiện có trong danh sách để người dùng dễ tìm
    declare -A _da_co
    local ds_the_loai=()
    for (( i=0; i<so_luong_CD; i++ )); do
        local tl="${danh_sach_CD[$i,the_loai]}"
        if [[ -n "$tl" && -z "${_da_co[$tl]}" ]]; then
            _da_co[$tl]=1
            ds_the_loai+=("$tl")
        fi
    done
    
    if (( ${#ds_the_loai[@]} > 0 )); then
        local chuoi_the_loai="${ds_the_loai[0]}"
        for (( k=1; k<${#ds_the_loai[@]}; k++ )); do
            chuoi_the_loai+=", ${ds_the_loai[$k]}"
        done
        echo "The loai hien co: $chuoi_the_loai"
    fi
 
    read -rp "Nhap the loai can tim: " the_loai_can_tim
    local tim_thay=0
    inHeaderTim
    for (( i=0; i<so_luong_CD; i++ )); do
        if [[ "${danh_sach_CD[$i,the_loai],,}" == *"${the_loai_can_tim,,}"* ]]; then
            inKetQuaTim "$i"
            tim_thay=1
        fi
    done
<<<<<<< HEAD
    [[ $tim_thay -eq 0 ]] && \
        echo "Khong tim thay CD co ten bai hat $ten_bai_hat"
    }

banCD () {
    echo ok
=======
    (( tim_thay == 0 )) && echo "Khong tim thay CD thuoc the loai: $the_loai_can_tim"
}
 
# tìm theo tên tác giả
timCDTheoTacGia() {
    local tac_gia_can_tim=$1
    local tim_thay=0
 
    inHeaderTim
    for (( i=0; i<so_luong_CD; i++ )); do
        if [[ "${danh_sach_CD[$i,tac_gia],,}" == *"${tac_gia_can_tim,,}"* ]]; then
            inKetQuaTim "$i"
            tim_thay=1
        fi
    done
    (( tim_thay == 0 )) && echo "Khong tim thay CD cua tac gia: $tac_gia_can_tim"
}
 
# tìm theo tên bài hát
timCDTheoTenBaiHat() {
    local ten_bai_hat=$1
    local tim_thay=0
 
    inHeaderTim
    for (( i=0; i<so_luong_CD; i++ )); do
        if [[ "${danh_sach_CD[$i,bai_hat],,}" == *"${ten_bai_hat,,}"* ]]; then
            inKetQuaTim "$i"
            tim_thay=1
        fi
    done
    (( tim_thay == 0 )) && echo "Khong tim thay CD co bai hat: $ten_bai_hat"
>>>>>>> 79afb8fc07143b286cb9384c20f7a4fc6c004f4e
}


ghiDuLieuVaoFile() {
    file_input="CD.txt"
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
        local bai_hat=${danh_sach_CD[$i,bai_hat]}

        # Bước 3: Nối các biến lại bằng dấu | và dùng >> để ghi nối tiếp vào file
        echo "$ten|$tac_gia|$nam|$the_loai|$gia|$mo_ta|$bai_hat" >> "$file_input"
    done
    
    file_input="hoadon.txt"
    > "$file_input"

    for ((i=0; i<so_luong_HD; i++))
    do
        local ngayban=${danh_sach_HD[$i,ngay_ban]}
        local khachhang=${danh_sach_HD[$i,khach_hang]}
        local nguoi_ban=${danh_sach_HD[$i,nguoi_ban]}
        local sosanpham=${danh_sach_HD[$i,so_san_pham]}
        local thanhtien=${danh_sach_HD[$i,thanh_tien]}
        local ds_sanpham_raw=""
        for ((j=0; j<sosanpham; j++))
        do
            if ((j != 0)); then
                ds_sanpham_raw+=","
            fi
            ds_sanpham_raw+="${danh_sach_HD[$i,san_pham_${j}_ID_CD]}'${danh_sach_HD[$i,san_pham_${j}_so_luong]}'${danh_sach_HD[$i,san_pham_${j}_don_gia]}"


        done
        echo "$ngayban|$khachhang|$nguoiban|$sosanpham|$thanhtien|$ds_sanpham_raw" >> "$file_input"
    done
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
    echo "8. Hoa don"
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
                read -rp "Nhap danh sach bai hat: " bai_hat
                themCD "$ten_CD" "$tac_gia" "$nam_san_xuat" "$the_loai" "$gia_ban" "$mo_ta" "$bai_hat"
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

                    
                    case $chuc_nang_2 in
                        1) {
                            read -rp "Nhap ten moi: " ten_CD
                            suaCD "$ID_CD" "$ten_CD" 1
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;
                            
                        2) {
                            read -rp "Nhap ten tac gia moi: " tac_gia
                            suaCD "$ID_CD" "$tac_gia" 2
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        3) {
                            read -rp "Nhap nam san xuat: " nam_san_xuat
                            suaCD "$ID_CD" "$nam_san_xuat" 3
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        4) {
<<<<<<< HEAD
                            read -rp "Nhap the loai: " the_loai
                            suaCD "$ID_CD" "$the_loai" 4
                            echo "Sua thanh cong!"
=======
                            read -rp 
                            timCDTheoTheLoai "$KET_QUA_GOI_Y"
>>>>>>> 79afb8fc07143b286cb9384c20f7a4fc6c004f4e
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        5) {
                            read -rp "Nhap gia ban: " gia_ban
                            suaCD "$ID_CD" "$gia_ban" 5
                            echo "Sua thanh cong!"
                            read -rp "Nhan enter de tiep tuc..." temp
                            break
                        };;

                        6) {
                            read -rp "Nhap mo ta: " mo_ta
                            suaCD "$ID_CD" "$mo_ta" 6
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
                timCDTheoTheLoai
                read -rp "Nhan enter de tiep tuc..." temp
                break
            };;

            5) {
                    read -rp "Nhap tac gia can tim: " tac_gia
                    timCDTheoTacGia "$tac_gia"
                    read -rp "Nhan enter de tiep tuc..." temp
                break
            };;
            
            6) {
                read -rp "Nhap ten bai hat can tim: " ten_bai_hat
                timCDTheoTenBaiHat "$ten_bai_hat"
                read -rp "Nhan enter de tiep tuc..." temp
                break
            };;
            
            7) {
                inDanhSachCD
                ngay_hien_tai=$(date +%F)
                danh_sach_HD[$so_luong_HD,ngay_ban]=$ngay_hien_tai
                echo "---------------------------------------------------------------------------------------------"
                echo "Ngay: ${danh_sach_HD[$so_luong_HD,ngay_ban]}"
                read -p "Ten khach hang: " khach_hang
                read -p "Ten nguoi ban: " nguoi_ban
                danh_sach_HD[$so_luong_HD,khach_hang]=$khach_hang
                danh_sach_HD[$so_luong_HD,nguoi_ban]=$nguoi_ban
                while true
                do
                    read -p "Nhap so san pham: " so_san_pham
                    if [[ "$so_san_pham" =~ ^[0-9]+$ ]]; then
                        break
                    fi
                    echo "Khong hop le vui long nhap lai!"
                done
                danh_sach_HD[$so_luong_HD,so_san_pham]=$so_san_pham
                danh_sach_HD[$so_luong_HD,thanh_tien]=0
                for ((i=0; i < so_san_pham; i++))
                do
                    while true
                    do
                        read -p "Nhap ID san pham: " ID_CD
                        if ((ID_CD<0 || ID_CD>=so_luong_CD)); then
                            echo "ID khong hop le! Vui long nhap lai"
                        else
                            # Nhap so luong san pham cua san pham
                            while true
                            do
                                read -p "Nhap so luong: " so_luong
                                if [[ "$so_san_pham" =~ ^[0-9]+$ ]]; then
                                    break
                                fi
                                echo "Khong hop le vui long nhap lai!"
                            done
                            danh_sach_HD[$so_luong_HD,san_pham_${i}_ID_CD]=$ID_CD
                            danh_sach_HD[$so_luong_HD,san_pham_${i}_so_luong]=$so_luong
                            danh_sach_HD[$so_luong_HD,san_pham_${i}_don_gia]="${danh_sach_CD[$ID_CD,gia_ban]}"
                            danh_sach_HD[$so_luong_HD,thanh_tien]=$((danh_sach_HD[$so_luong_HD,thanh_tien] + (danh_sach_HD[$so_luong_HD,san_pham_${i}_so_luong] * danh_sach_HD[$so_luong_HD,san_pham_${i}_don_gia])))
                            break

                            
                            

                        fi
                    done
                done
                let so_luong_HD++

                
                             
                


                data_change=1
                break
            };;

            8) {
                while true
                do
                    inDanhSachHoaDon
                    echo ""
                    echo "---------------------------------------------------------------------------------------------"
                    read -rp "Nhap ID hoa don muon xem chi tiet (nhan Enter de thoat): " ID_HD
                    if [[ -z "$ID_HD" ]]; then
                        break
                    fi

                    if (( $ID_HD>=0 && $ID_HD<$so_luong_HD )); then
                        inChiTietHoaDon "$ID_HD"
                        read -rp "Nhan enter de thoat..." temp
                    else
                        echo "ID khong hop le!"
                        read -rp "Nhan enter de tiep tuc..." temp
                    fi
                done
                break
            };;

            0) {
                check=0
                if [ $data_change -eq 1 ]; then
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
                fi
                
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