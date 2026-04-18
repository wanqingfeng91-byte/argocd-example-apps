FROM python:3.9-alpine

# 安装构建图标所需的库
RUN apk add --no-cache tzdata build-base freetype-dev libpng-dev

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 创建静态文件目录
RUN mkdir static

# --- 关键：自动生成 favicon.ico 的 Python 脚本 ---
RUN python3 -c "from PIL import Image, ImageDraw; \
    img = Image.new('RGBA', (32, 32), (255, 255, 255, 0)); \
    draw = ImageDraw.Draw(img); \
    draw.ellipse([2, 2, 30, 30], fill='#3498db'); \
    draw.arc([2, 2, 30, 30], start=0, end=360, fill='#2ecc71', width=3); \
    img.save('static/favicon.ico')"

COPY app.py .

# 安全：非 root 用户
RUN adduser -D argouser && chown -R argouser /app
USER argouser

EXPOSE 5000
CMD ["python", "app.py"]