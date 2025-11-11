
FROM alpine:3.20
RUN apk update && apk add --no-cache ffmpeg bash 
WORKDIR /app
COPY --chown=root:root --chmod=100 ./convert.sh .
ENTRYPOINT ["./convert.sh"]
CMD ["input.mp4", "avi"]


# uso de imagem alpine para manter a imagem leve
# instala ffmpeg e bash
