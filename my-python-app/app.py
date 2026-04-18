from flask import Flask, render_template_string, request, send_from_directory
import os
import socket
import requests
import time

app = Flask(__name__)
START_TIME = time.time()

# 多语言配置
I18N = {
    'zh': {
        'title': 'Argo CD 企业级演示',
        'badge': 'ARGO CD 已同步',
        'welcome': '🌍 欢迎使用 Geo Demo',
        'ver': '应用版本',
        'p_ip': 'Pod 内网 IP',
        'pub_ip': '公网出口 IP',
        'loc': '地理位置',
        'env': '运行环境',
        'switch_btn': 'Switch to English'
    },
    'en': {
        'title': 'Argo CD Enterprise Demo',
        'badge': 'SYNCED BY ARGO CD',
        'welcome': '🌍 Geo Location Demo',
        'ver': 'App Version',
        'p_ip': 'Pod Internal IP',
        'pub_ip': 'Public Exit IP',
        'loc': 'Location',
        'env': 'Environment',
        'switch_btn': '切换至中文'
    }
}

def get_internal_ip():
    try: return socket.gethostbyname(socket.gethostname())
    except: return "127.0.0.1"

def get_geo_info():
    try:
        response = requests.get('http://ip-api.com/json/', timeout=3)
        data = response.json()
        return data.get('query', 'Unknown'), data.get('country', 'Earth')
    except: return "Internal Network", "Private Cloud"

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>{{ t.title }}</title>
    <link rel="icon" href="/favicon.ico" type="image/png">
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; text-align: center; background-color: #eef2f7; padding: 50px; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); display: inline-block; min-width: 480px; transition: 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .status-badge { background: #2ecc71; color: white; padding: 6px 18px; border-radius: 25px; font-size: 0.85em; margin-bottom: 25px; display: inline-block; letter-spacing: 1px; }
        .info-item { margin: 18px 0; font-size: 1.15em; color: #2c3e50; border-bottom: 1px solid #f0f0f0; padding-bottom: 12px; display: flex; justify-content: space-between; align-items: center; }
        .label { font-weight: 600; color: #95a5a6; text-transform: uppercase; font-size: 0.8em; }
        .value { font-family: 'Monaco', monospace; background: #f8f9fa; padding: 2px 8px; border-radius: 4px; }
        .highlight { color: #e67e22; font-weight: bold; }
        .btn-switch { margin-top: 30px; display: inline-block; padding: 12px 25px; background-color: #3498db; color: white; text-decoration: none; border-radius: 8px; font-weight: bold; }
        footer { margin-top: 30px; color: #bdc3c7; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="card">
        <div class="status-badge">{{ t.badge }}</div>
        <h1>{{ t.welcome }}</h1>
        <div class="info-item"><span class="label">{{ t.ver }}</span> <span class="value highlight">{{ version }}</span></div>
        <div class="info-item"><span class="label">{{ t.p_ip }}</span> <span class="value">{{ pod_ip }}</span></div>
        <div class="info-item"><span class="label">{{ t.pub_ip }}</span> <span class="value">{{ public_ip }}</span></div>
        <div class="info-item"><span class="label">{{ t.loc }}</span> <span class="value highlight">{{ country }}</span></div>
        <div class="info-item"><span class="label">{{ t.env }}</span> <span class="value">{{ env_name }}</span></div>
        <a href="/?lang={{ next_lang }}" class="btn-switch">{{ t.switch_btn }}</a>
    </div>
    <footer>Powered by Argo CD & K3s</footer>
</body>
</html>
"""

@app.route('/')
def index():
    lang_code = request.args.get('lang') or os.getenv('APP_LANG', 'zh')
    t = I18N.get(lang_code, I18N['zh'])
    next_lang = 'en' if lang_code == 'zh' else 'zh'
    version = os.getenv('APP_VERSION', 'v3.0')
    env_name = os.getenv('ENV_NAME', 'K3s-Cluster')
    return render_template_string(HTML_TEMPLATE, t=t, next_lang=next_lang, version=version, env_name=env_name, pod_ip=get_internal_ip(), public_ip=get_geo_info()[0], country=get_geo_info()[1])

@app.route('/health')
def health():
    return {"status": "healthy", "uptime": f"{time.time() - START_TIME:.2f}s"}, 200

@app.route('/favicon.ico')
def favicon():
    # 从 static 文件夹读取图标
    return send_from_directory(os.path.join(app.root_path, 'static'), 'favicon.ico')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)