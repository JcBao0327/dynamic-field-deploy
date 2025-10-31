FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
WORKDIR /app

# 常用构建工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 仅拷 requirements 以利用缓存
COPY backend/requirements.txt /app/requirements.txt

# 👉 打印 requirements，且用详细日志安装，便于在 Actions 里看到具体错误
RUN python -V && pip -V && echo "----- requirements.txt -----" && cat /app/requirements.txt && \
    python -m pip install --upgrade pip && \
    pip install -vvv -r /app/requirements.txt

# 再拷贝代码
COPY backend /app/

EXPOSE 5000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "5000"]
