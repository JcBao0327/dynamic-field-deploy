# ============================
# Stage 1 — Build Frontend
# ============================
FROM node:20-alpine AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build   # 生成 dist/

# ============================
# Stage 2 — Backend + Serve
# ============================
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# 拷贝后端并安装依赖
COPY backend/ /app/backend/
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r /app/backend/requirements.txt && \
    pip install --no-cache-dir uvicorn fastapi

# 拷贝前端打包产物到 backend/frontend/dist
COPY --from=frontend-build /app/frontend/dist /app/frontend/dist

# 入口：运行我们刚创建的 entrypoint.py（统一服务前后端）
EXPOSE 80
WORKDIR /app/backend
CMD ["python", "-m", "uvicorn", "entrypoint:app", "--host", "0.0.0.0", "--port", "80"]
