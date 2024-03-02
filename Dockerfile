# 베이스 이미지 설정
FROM ubuntu:20.04

# 작업 디렉토리 설정
WORKDIR /app

# 시간대 설정
RUN apt-get update && apt-get install -y curl tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get remove -y tzdata

COPY ./node_modules ./node_modules

COPY ./src ./src

# Apache 설치 및 proxy 모듈 활성화
RUN apt install -y apache2 && \
    a2enmod proxy && \
    a2enmod proxy_http

# 프록시 설정 파일 복사
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# 웹팩 파일을 Apache 웹 서버 경로로 복사
COPY ./dist/ /var/www/html/

RUN chown -R www-data:www-data /var/www/html

# apache 실행
CMD ["apachectl", "-D", "FOREGROUND"]