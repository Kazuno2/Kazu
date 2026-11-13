import math
import struct
import zlib
import os

def create_png(width, height, get_pixel_func):
    """Generates an uncompressed RGBA PNG in pure Python using zlib and struct."""
    raw_data = bytearray()
    for y in range(height):
        raw_data.append(0)  # filter type 0: None
        for x in range(width):
            r, g, b, a = get_pixel_func(x, y, width, height)
            raw_data.extend([int(r), int(g), int(b), int(a)])

    compressed = zlib.compress(bytes(raw_data), 9)

    def chunk(chunk_type, data):
        c = chunk_type + data
        crc = zlib.crc32(c) & 0xffffffff
        return struct.pack('>I', len(data)) + c + struct.pack('>I', crc)

    png = bytearray(b'\x89PNG\r\n\x1a\n')
    # IHDR chunk
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0)
    png.extend(chunk(b'IHDR', ihdr_data))
    # IDAT chunk
    png.extend(chunk(b'IDAT', compressed))
    # IEND chunk
    png.extend(chunk(b'IEND', b''))
    return bytes(png)

def blend(c1, c2, alpha):
    """Blends c2 over c1 using c2's alpha (0.0 - 1.0)."""
    r1, g1, b1, a1 = c1
    r2, g2, b2, a2 = c2
    a_out = a2 + a1 * (1.0 - a2)
    if a_out <= 0:
        return (0, 0, 0, 0)
    r_out = (r2 * a2 + r1 * a1 * (1.0 - a2)) / a_out
    g_out = (g2 * a2 + g1 * a1 * (1.0 - a2)) / a_out
    b_out = (b2 * a2 + b1 * a1 * (1.0 - a2)) / a_out
    return (r_out, g_out, b_out, a_out)

def buddy_icon_pixel(x, y, w, h):
    # Normalized coordinates (-1 to 1)
    nx = (x / (w - 1)) * 2.0 - 1.0
    ny = (y / (h - 1)) * 2.0 - 1.0

    # Background: Rounded square container or circle
    # Distance from center
    dist_sq = nx * nx + ny * ny

    # Dark luxurious Midnight Bloom background (#1B132B -> #2C1B4D)
    bg_t = (ny + 1.0) / 2.0
    bg_r = 27 + (44 - 27) * bg_t
    bg_g = 19 + (27 - 19) * bg_t
    bg_b = 43 + (77 - 43) * bg_t
    color = (bg_r, bg_g, bg_b, 1.0)

    # Subtle background ring/glow
    glow_dist = math.sqrt(dist_sq)
    if glow_dist < 0.85:
        glow_intensity = max(0.0, 1.0 - (glow_dist / 0.85)) * 0.25
        # Soft lavender glow (#8B68DE)
        color = blend(color, (139, 104, 222, 1.0), glow_intensity)

    # Buddy Body: Oval shape
    # Semi-major axis (vertical), semi-minor axis (horizontal)
    # Oval equation: (nx / a)^2 + (ny / b)^2 <= 1
    # Let buddy be centered slightly (y shifted down slightly to leave room for friendly posture)
    bx = nx / 0.52
    by = (ny - 0.04) / 0.62
    buddy_dist = math.sqrt(bx * bx + by * by)

    # Anti-aliasing threshold
    pixel_size = 2.0 / w
    aa_width = pixel_size / 0.55

    if buddy_dist <= 1.0 + aa_width:
        # Inside Buddy's oval body
        # Gradient: Warm Golden Honey (#FFDE6A) to Soft Warm Amber (#FFB03A)
        buddy_t = (by + 1.0) / 2.0
        b_r = 255
        b_g = 222 - (222 - 176) * buddy_t
        b_b = 106 - (106 - 58) * buddy_t

        # Add soft highlight at top-left
        hl_dist = math.sqrt((bx + 0.25)**2 + (by + 0.3)**2)
        if hl_dist < 0.6:
            hl = (1.0 - hl_dist / 0.6) * 0.3
            b_r = min(255, b_r + 255 * hl)
            b_g = min(255, b_g + 255 * hl)
            b_b = min(255, b_b + 255 * hl)

        # Border/edge shadow for Buddy
        if buddy_dist > 0.88:
            edge_factor = (buddy_dist - 0.88) / 0.12
            b_r = b_r * (1.0 - 0.2 * edge_factor)
            b_g = b_g * (1.0 - 0.2 * edge_factor)
            b_b = b_b * (1.0 - 0.2 * edge_factor)

        buddy_alpha = 1.0
        if buddy_dist > 1.0:
            buddy_alpha = max(0.0, 1.0 - (buddy_dist - 1.0) / aa_width)

        buddy_color = (b_r, b_g, b_b, buddy_alpha)
        color = blend(color, buddy_color, buddy_alpha)

        # Facial features:
        # Eyes: two friendly vertical ovals
        # Left eye centered around bx = -0.36, by = -0.12
        # Right eye centered around bx = 0.36, by = -0.12
        eye_y = by + 0.10
        left_eye_dist = math.sqrt(((bx + 0.34) / 0.10)**2 + (eye_y / 0.15)**2)
        right_eye_dist = math.sqrt(((bx - 0.34) / 0.10)**2 + (eye_y / 0.15)**2)

        eye_color = (45, 30, 20, 1.0) # Deep warm brown/charcoal
        eye_aa = aa_width / 0.10

        if left_eye_dist <= 1.0 + eye_aa:
            alpha = 1.0 if left_eye_dist <= 1.0 else max(0.0, 1.0 - (left_eye_dist - 1.0) / eye_aa)
            # Catchlight in left eye
            cl_dist = math.sqrt(((bx + 0.31) / 0.035)**2 + ((eye_y + 0.05) / 0.05)**2)
            if cl_dist <= 1.0:
                color = blend(color, (255, 255, 255, 1.0), 0.95 * alpha)
            else:
                color = blend(color, eye_color, alpha)

        if right_eye_dist <= 1.0 + eye_aa:
            alpha = 1.0 if right_eye_dist <= 1.0 else max(0.0, 1.0 - (right_eye_dist - 1.0) / eye_aa)
            # Catchlight in right eye
            cl_dist = math.sqrt(((bx - 0.37) / 0.035)**2 + ((eye_y + 0.05) / 0.05)**2)
            if cl_dist <= 1.0:
                color = blend(color, (255, 255, 255, 1.0), 0.95 * alpha)
            else:
                color = blend(color, eye_color, alpha)

        # Cheeks: Soft rosy circles below eyes
        cheek_left = math.sqrt(((bx + 0.52) / 0.16)**2 + ((by - 0.10) / 0.11)**2)
        cheek_right = math.sqrt(((bx - 0.52) / 0.16)**2 + ((by - 0.10) / 0.11)**2)
        if cheek_left <= 1.0:
            ch_alpha = (1.0 - cheek_left) * 0.45
            color = blend(color, (255, 120, 130, 1.0), ch_alpha)
        if cheek_right <= 1.0:
            ch_alpha = (1.0 - cheek_right) * 0.45
            color = blend(color, (255, 120, 130, 1.0), ch_alpha)

        # Smile: curved arc
        # Center of mouth: bx = 0, by = 0.22
        # Arc parameter: y = 0.14 + 0.6 * bx^2
        if abs(bx) <= 0.32:
            target_y = 0.14 + 0.55 * (bx * bx)
            dy = abs(by - target_y)
            smile_thick = 0.06
            if dy <= smile_thick + aa_width:
                s_alpha = 1.0 if dy <= smile_thick else max(0.0, 1.0 - (dy - smile_thick) / aa_width)
                color = blend(color, (45, 30, 20, 1.0), s_alpha * 0.95)

    # Circular mask for round launcher icon compatibility
    if glow_dist > 0.96:
        edge_aa = max(0.0, 1.0 - (glow_dist - 0.96) / 0.04)
        color = (color[0], color[1], color[2], color[3] * edge_aa)

    r, g, b, a = color
    return (int(round(r)), int(round(g)), int(round(b)), int(round(a * 255)))

def main():
    sizes = {
        'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
        'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
        'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
        'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
        'assets/icon/app_icon.png': 512,
    }

    os.makedirs('assets/icon', exist_ok=True)

    for path, size in sizes.items():
        print(f"Generating {path} ({size}x{size})...")
        os.makedirs(os.path.dirname(path), exist_ok=True)
        png_bytes = create_png(size, size, buddy_icon_pixel)
        with open(path, 'wb') as f:
            f.write(png_bytes)

    print("All app icons successfully generated!")

if __name__ == '__main__':
    main()

