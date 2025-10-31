# backend/entrypoint.py
import os
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

# 1) 导入你原来的后端应用（假设在 backend/app.py 里有变量 app）
#    如果你的文件不是 app.py 或变量名不是 app，请改成对应的路径与变量
from app import app as api_app  # backend/app.py -> app

app = FastAPI()

# 2) /api -> 你的后端
app.mount("/api", api_app)

# 3) / -> 前端打包后的静态页面（dist）
STATIC_DIR = os.path.join(os.path.dirname(__file__), "..", "frontend", "dist")
if not os.path.isdir(STATIC_DIR):
    # 首次部署时若还未 build，会显示提示页
    os.makedirs(STATIC_DIR, exist_ok=True)
    index_html = os.path.join(STATIC_DIR, "index.html")
    if not os.path.exists(index_html):
        with open(index_html, "w") as f:
            f.write("<h1>Frontend not built yet.</h1>")

app.mount("/", StaticFiles(directory=STATIC_DIR, html=True), name="static")
