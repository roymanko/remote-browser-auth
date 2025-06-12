FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 必要なツールとChrome用の署名鍵の追加
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    ca-certificates \
    curl \
    software-properties-common

# Google Chromeの鍵とリポジトリを追加
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# 必要なアプリケーションをインストール（Chromeやデスクトップ環境）
RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    supervisor \
    nginx \
    apache2-utils

# 作業ディレクトリ
WORKDIR /root

# VNC 初期起動（必要に応じて）
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# supervisor 設定ファイル（必要なら supervisor.conf を作って COPY）
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# nginx 設定ファイル（必要なら nginx.conf を作って COPY）
# COPY nginx.conf /etc/nginx/nginx.conf

# .htpasswd（必要なら作成して配置）
# COPY .htpasswd /etc/nginx/.htpasswd

# Renderが使用するポート（デフォルト10000）
EXPOSE 10000

# 最終コマンド（nginxをフォアグラウンドで起動）
CMD ["nginx", "-g", "daemon off;"]
