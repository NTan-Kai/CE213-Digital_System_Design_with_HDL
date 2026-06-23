import cv2
import numpy as np
import os

def read_hex_to_image(hex_file_path, width=256, height=256):
    with open(hex_file_path, 'r') as f:
        lines = f.readlines()
        
    clean_lines = [line.strip() for line in lines if line.strip()]
    expected_pixels = width * height
    
    if len(clean_lines) != expected_pixels:
        print(f"   [!] Lỗi: File {hex_file_path} có {len(clean_lines)} pixel, cần đúng {expected_pixels}.")
        return None

    is_rgb = len(clean_lines[0]) > 2
    if is_rgb:
        pixels = []
        for line in clean_lines:
            line = line.zfill(6) 
            r = int(line[0:2], 16)
            g = int(line[2:4], 16)
            b = int(line[4:6], 16)
            pixels.append([b, g, r]) 
        img_array = np.array(pixels, dtype=np.uint8)
        return img_array.reshape((height, width, 3))
    else:
        pixel_values = [int(line, 16) for line in clean_lines]
        img_array = np.array(pixel_values, dtype=np.uint8)
        return img_array.reshape((height, width))

def compare_multiple_psnr_and_export(original_path, test_files, width=256, height=256):
    print("==================================================")
    print("      ĐÁNH GIÁ MSE, PSNR & XUẤT ẢNH KẾT QUẢ")
    print("==================================================")
    
    img_orig = cv2.imread(original_path, cv2.IMREAD_GRAYSCALE)
    if img_orig is None:
        print(f"[!] Lỗi: Không thể đọc ảnh gốc '{original_path}'")
        return
        
    if img_orig.shape[:2] != (height, width):
        img_orig = cv2.resize(img_orig, (width, height))
        
    print(f"[*] Ảnh chuẩn (Reference): '{original_path}' (Kích thước: {width}x{height})")
    print("-" * 50)

    for path in test_files:
        if not os.path.exists(path):
            print(f"[!] Bỏ qua '{path}': Không tìm thấy file.")
            continue
            
        if path.lower().endswith('.hex'):
            img_test = read_hex_to_image(path, width, height)
            
            if img_test is not None:
                out_jpg_path = path.replace('.hex', '.jpg')
                cv2.imwrite(out_jpg_path, img_test)
                print(f" [+] Đã xuất ảnh từ FPGA ra file:\t {out_jpg_path}")
        else:
            img_test = cv2.imread(path, cv2.IMREAD_GRAYSCALE)
            
        if img_test is None:
            continue

        if img_orig.shape != img_test.shape:
            img_test = cv2.resize(img_test, (img_orig.shape[1], img_orig.shape[0]))

        mse_value = np.mean((img_orig.astype(np.float32) - img_test.astype(np.float32)) ** 2)
        psnr_value = cv2.PSNR(img_orig, img_test)
        
        print(f"  -> Điểm MSE  của '{path}':\t {mse_value:.2f}")
        print(f"  -> Điểm PSNR của '{path}':\t {psnr_value:.2f} dB\n")

    print("==================================================")

if __name__ == "__main__":
    original_img = "Lena_image.jpg"
    
    files_to_test = [
        "image_out_3x3.hex",
        "image_out_5x5.hex",
        "image_matlab.hex",
        "noisy_image.jpg"
    ]
    
    compare_multiple_psnr_and_export(original_img, files_to_test, width=256, height=256)