import os
from PIL import Image
import sys


# PNG Sequence directory
if len(sys.argv) < 2:
  print("Usage: python to_sheet.py <png_sequence_directory>")
  exit(1)

dir_path = sys.argv[1]
output_name = os.path.basename(os.path.normpath(dir_path)).lower() + "_spritesheet.png"

if not os.path.exists(dir_path):
  print(f"Directory {dir_path} does not exist.")
  exit(1)

# collect PNG files matching [00000].png, [00001].png, ...
files = []
for file in os.listdir(dir_path):
  if file.endswith(".png") and len(file) == 9 and file[:5].isdigit():
    files.append({"name": file, "num": int(file[:5])})

# sort files by number
files.sort(key=lambda x: x["num"])

if not files:
  print("No PNG sequence found.")
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
sheet = Image.new("RGBA", (total_width, height))
x = 0
for img in images:
  sheet.paste(img, (x, 0))
  x += img.width
  img.close()

# save spritesheet
sheet.save(
  f"{output_name}",
)
sheet.close()

print(f"Spritesheet saved as {output_name} in the current directory.")
