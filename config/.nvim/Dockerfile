FROM alpine:3.9

WORKDIR /root

RUN apk add --no-cache bash vim neovim curl git wget tmux tar unzip

RUN curl -fsSL https://spacevim.org/install.sh | bash
    
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
