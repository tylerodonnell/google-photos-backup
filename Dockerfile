FROM python:3-alpine AS gphotos-sync-builder

RUN apk add --update --no-cache gcc musl-dev linux-headers \
  && rm -rf /var/cache/apk/*

ENV PYTHONDONTWRITEBYTECODE=1

RUN python -m venv --system-site-packages /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir --upgrade gphotos-sync

FROM  python:3-alpine

COPY --from=gphotos-sync-builder /opt/venv /opt/venv

RUN URL=http://downloads.rclone.org/current/rclone-current-linux-amd64.zip ; \
  URL=${URL/\/current/} ; \
  cd /tmp \
  && wget -q $URL \
  && unzip /tmp/rclone-current-linux-amd64.zip \
  && mv /tmp/rclone-*-linux-amd64/rclone /usr/bin \
  && rm -r /tmp/rclone* \
  && apk add --update bash \
  && rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

ENV PATH="/opt/venv/bin:$PATH"

RUN mkdir -p /root/.config /config \
    && ln -s /config /root/.config/gphotos-sync \
    && mkdir /storage

VOLUME /config
VOLUME /storage

RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]



