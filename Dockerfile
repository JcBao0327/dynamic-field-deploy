# ============================
# Stage 1 — Build Frontend
# ============================
FROM node:18 AS frontend-build
WORKDIR /app
COPY frontend /app/frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# ============================
# Stage 2 — Backend + Serve
# ============================
FROM python:3.10-slim

WORKDIR /app
COPY backend /app/backend
COPY start_project.py /app/start_project.py
COPY --from=frontend-build /app/frontend/dist /app/frontend/dist

# Install Python dependencies
RUN pip install --no-cache-dir -r /app/backend/requirements.txt

# Expose FastAPI & Vite ports
EXPOSE 5000
EXPOSE 5173

# 启动脚本：同时启动后端与前端静态文件服务
CMD ["python", "start_project.py"]