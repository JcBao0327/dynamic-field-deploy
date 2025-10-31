# ✅ 使用官方 Python 镜像
FROM python:3.10-slim

# ✅ 设置工作路径
WORKDIR /app

# ✅ 只 copy 依赖，先安装，利用缓存加速
COPY backend/requirements.txt /app/backend/requirements.txt

# ✅ 安装依赖（避免 pip6 与某些包不兼容）
RUN python -m pip install --upgrade pip==23.3.1 && \
    pip install --no-cache-dir -r /app/backend/requirements.txt

# ✅ 再拷贝整体代码
COPY backend /app/backend

# ✅ 对外暴露端口
EXPOSE 8000

# ✅ 启动 FastAPI（按你项目命名修改）
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
