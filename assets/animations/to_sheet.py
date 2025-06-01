import os
from PIL import Image
import sys

# PNG/JPG Sequence directory and output type
if len(sys.argv) < 3:
  print("Usage: python to_sheet.py <png_sequence_directory> <type: png|jpg>")
  exit(1)

dir_path = sys.argv[1]
img_type = sys.argv[2].lower()
if img_type not in ("png", "jpg"):
  print("Type must be 'png' or 'jpg'.")
  exit(1)

output_name = os.path.basename(os.path.normpath(dir_path)).lower() + f"_spritesheet.{img_type}"

if not os.path.exists(dir_path):
  print(f"Directory {dir_path} does not exist.")
  exit(1)

# collect image files matching [00000].png or [00000].jpg, etc.
files = []
for file in os.listdir(dir_path):
  if file.endswith(f".{img_type}") and len(file) == 9 and file[:5].isdigit():
    files.append({"name": file, "num": int(file[:5])})

# sort files by number
files.sort(key=lambda x: x["num"])

if not files:
  print(f"No {img_type.upper()} sequence found.")
  exit(1)

# get image dimensions and total width
images = []
total_width = 0
height = None

for f in files:
  img_path = os.path.join(dir_path, f["name"])
  img = Image.open(img_path)
  if height is None:
    height = img.height
  total_width += img.width
  images.append(img)

# create horizontal spritesheet animation sequence
mode = "RGBA" if img_type == "png" else "RGB"
sheet = Image.new(mode, (total_width, height))
x = 0
for img in images:
  # Convert image mode if necessary
  if img.mode != mode:
    img = img.convert(mode)
  sheet.paste(img, (x, 0))
  x += img.width
  img.close()

# save spritesheet
sheet.save(output_name)
sheet.close()

print(f"Spritesheet saved as {output_name} in the current directory.")
