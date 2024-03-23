FROM --platform=linux/amd64 amazonlinux:2023

COPY ./src/backend/requirements.txt ./
COPY ./.aws ./root/.aws
COPY ./.gitconfig ./root/

# 必要なパッケージをインストール
RUN dnf install -y git tar gcc \
    zlib-devel bzip2-devel readline-devel \
    sqlite sqlite-devel openssl-devel \
    tk-devel libffi-devel xz-devel

# pyenv により、使用する Python バージョンをインストールする
RUN curl https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    source ~/.bashrc && \
    pyenv install 3.11.0 && \
    pyenv global 3.11.0

RUN /root/.pyenv/shims/pip install --no-cache-dir -r ./requirements.txt && \
    rm -frv ./requirements.txt



RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -frv awscliv2.zip ./aws

RUN curl -LO https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip && \
    unzip aws-sam-cli-linux-x86_64.zip -d sam-installation && \
    ./sam-installation/install && \
    rm -frv aws-sam-cli-linux-x86_64.zip ./sam-installation

RUN aws --version && \
    sam --version && \
    aws configure list-profiles