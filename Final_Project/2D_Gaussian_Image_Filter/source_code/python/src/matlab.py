import numpy as np

def process_gaussian_hardware_match(input_hex, output_hex, img_w=256, img_h=256, filter_mode=1):
    try:
        with open(input_hex, 'r') as f:
            lines = f.read().splitlines()
    except FileNotFoundError:
        print(f"Lỗi: Không tìm thấy file {input_hex}")
        return

    img_1d = [int(x, 16) for x in lines if x.strip()]
    if len(img_1d) != img_w * img_h:
        print(f"Cảnh báo: Dữ liệu không khớp độ phân giải {img_w}x{img_h}.")
        
    img = np.array(img_1d[:img_w*img_h], dtype=np.int32).reshape((img_h, img_w))
    
    padded_img = np.pad(img, pad_width=2, mode='reflect')
    out_img = np.zeros_like(img, dtype=np.uint8)
    
    for y in range(img_h):
        for x in range(img_w):
            window = padded_img[y:y+5, x:x+5]
            
            if filter_mode == 0:
                grp_corner = window[1,1] + window[1,3] + window[3,1] + window[3,3]
                grp_edge   = window[1,2] + window[2,1] + window[2,3] + window[3,2]
                center     = window[2,2]
                
                sum_val = grp_corner + (grp_edge << 1) + (center << 2)
                
                pixel_out = (sum_val + 8) >> 4
                
            else:
                grp_1  = window[0,0] + window[0,4] + window[4,0] + window[4,4]
                grp_4  = window[0,1] + window[0,3] + window[1,0] + window[1,4] + \
                         window[3,0] + window[3,4] + window[4,1] + window[4,3]
                grp_6  = window[0,2] + window[4,2] + window[2,0] + window[2,4]
                grp_16 = window[1,1] + window[1,3] + window[3,1] + window[3,3]
                grp_24 = window[1,2] + window[2,1] + window[2,3] + window[3,2]
                center = window[2,2]
                
                sum_val = grp_1 + (grp_4 << 2) + (grp_6 * 6) + (grp_16 << 4) + \
                          (grp_24 * 24) + (center * 36)
                          
                pixel_out = (sum_val + 128) >> 8
            
            if pixel_out > 255:
                pixel_out = 255
            elif pixel_out < 0:
                pixel_out = 0
            
            out_img[y, x] = pixel_out
            
    with open(output_hex, 'w') as f:
        for val in out_img.flatten():
            f.write(f"{val:02x}\n")
            
    print(f"--- Hoàn tất mô phỏng Hardware: Chế độ {3 if filter_mode==0 else 5}x{3 if filter_mode==0 else 5} ---")
    print(f"--- Kết quả lưu tại: {output_hex} ---")

if __name__ == "__main__":
    process_gaussian_hardware_match(
        input_hex='input_image.hex', 
        output_hex='image_matlab.hex',
        img_w=256, 
        img_h=256, 
        filter_mode=0
    )