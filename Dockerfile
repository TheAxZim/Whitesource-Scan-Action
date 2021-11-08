FROM whitesourcesoftware/ua-base:v2

LABEL version="1.0.1"
LABEL repository="https://github.com/TheAxZim/Whitesource-Scan-Action"
LABEL maintainer="Azeem Shezad Ilyas <azeemilyas@hotmail.com>"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
