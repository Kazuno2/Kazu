import os
from PIL import Image

src_path = r"C:/Users/Kazuno/.gemini/antigravity/brain/6627a491-7f7c-475e-87ad-fa5d47f118c2/.user_uploaded/media_1792965068491_a50a4576.png"

# Ensure directories exist
os.makedirs("assets/icon", exist_ok=True)
os.makedirs("assets/images", exist_ok=True)

img = Image.open(src_path).convert("RGBA")

# Save master icon and in-app asset
img.save("assets/icon/app_icon.png")
img.save("assets/images/buddy.png")

sizes = {
    "android/app/src/main/res/mipmap-mdpi/ic_launcher.png": (48, 48),
    "android/app/src/main/res/mipmap-hdpi/ic_launcher.png": (72, 72),
    "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png": (96, 96),
    "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png": (144, 144),
    "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png": (192, 192),
}

for path, size in sizes.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    resized = img.resize(size, Image.Resampling.LANCZOS)
    resized.save(path)
    print(f"Generated {path} ({size[0]}x{size[1]})")

print("All icons successfully generated!")

