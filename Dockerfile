FROM node:20-alpine

# 安装 better-sqlite3 和 sharp 编译依赖
RUN apk add --no-cache python3 make g++ vips-dev

WORKDIR /app

# 复制依赖文件
COPY package.json ./

# 安装依赖
RUN npm install --production

# 复制应用代码
COPY server.js ./
COPY public ./public/

# 创建数据目录（包括缩略图目录）
RUN mkdir -p /app/data /app/data/thumbnails /app/media /app/backups

# 设置环境变量
ENV PORT=3000
ENV DB_PATH=/app/data/baby.db
ENV MEDIA_PATH=/app/media
ENV BACKUP_PATH=/app/backups
ENV THUMB_PATH=/app/data/thumbnails

# 暴露端口
EXPOSE 3000

# 数据卷
VOLUME ["/app/data", "/app/media", "/app/backups"]

# 以 root 用户运行（确保有写权限）
USER root

# 启动命令
CMD ["node", "server.js"]
