FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 必要な基本パッケージ
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    ca-certificates \
    curl \
    software-properties-common

# Google Chrome の署名鍵を登録してリポジトリ追加
RUN mkdir -p /usr/share/keyrings && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Chromeとその他パッケージのインストール
RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    supervisor \
    nginx \
    apache2-utils && \
    apt-get clean

# VNC 初期設定（パスワードは必要に応じて変更）
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# nginx.conf や .htpasswd がある場合コピー（任意）
# COPY nginx.conf /etc/nginx/nginx.conf
# COPY .htpasswd /etc/nginx/.htpasswd

# 作業ディレクトリ
WORKDIR /root

# Render の標準ポート
EXPOSE 10000

# 起動コマンド（必要なら supervisor 起動に変更可）
CMD ["nginx", "-g", "daemon off;"]
