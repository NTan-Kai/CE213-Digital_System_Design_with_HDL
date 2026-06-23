import cv2
import numpy as np
import os

def create_noisy_hex(image_path, hex_out_path, noisy_img_out_path, mean=0, std=25):
    print(f"[*] Đang xử lý ảnh: {image_path}")   
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    if img is None:
        print(f"[!] Lỗi: Không thể tìm thấy hoặc đọc ảnh '{image_path}'")
        return
        
    img = cv2.resize(img, (256, 256))
    
    noise = np.random.normal(mean, std, img.shape)
    
    noisy_img = img.astype(np.float32) + noise
    noisy_img = np.clip(noisy_img, 0, 255).astype(np.uint8)
    
    cv2.imwrite(noisy_img_out_path, noisy_img)
    print(f"=> Đã lưu ảnh bị nhiễu tại: {noisy_img_out_path}")
    
    with open(hex_out_path, 'w') as f:
        for row in noisy_img:
            for pixel in row:
                f.write(f"{pixel:02X}\n")                
    print(f"=> Đã tạo thành công file HEX: {hex_out_path} ({img.shape[0]*img.shape[1]} pixels)")

if __name__ == "__main__":
    create_noisy_hex(
        image_path="Lena_image.jpg",            
        hex_out_path="input_image.hex",       
        noisy_img_out_path="noisy_image.jpg", 
        std=30                            
    )