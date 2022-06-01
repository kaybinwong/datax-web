FROM openjdk:8-jdk-alpine

LABEL maintainer="kaybinwong@126.com"

ADD ./build .
ADD ./requirements.txt .

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
apk update && \
apk add --no-cache vim wget curl python3 bash gcc && \
ln -s /usr/bin/python3.6 /usr/bin/python && \
python -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn && \
wget -q --show-progress http://datax-opensource.oss-cn-hangzhou.aliyuncs.com/datax.tar.gz && \
tar -zxvf datax.tar.gz -C /opt && \
tar -zxvf datax-web.tar.gz -C /opt && \
cd /opt/datax-web && \
sed -i 's/--skip-old-files/-k/g' bin/install.sh && \
bash bin/install.sh -f && \
sed -i 's/grep -P/grep -E/g' modules/datax-admin/bin/datax-admin.sh && \
sed -i 's/grep -P/grep -E/g' modules/datax-executor/bin/datax-executor.sh && \
rm -rf  packages *.tar.gz requirements.txt

WORKDIR /opt/datax-web

EXPOSE 9527 9004
ENTRYPOINT []
CMD ["./bin/start-all.sh"]