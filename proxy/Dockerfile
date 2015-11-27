FROM nginx

COPY config/ /etc/nginx/
COPY run.sh /usr/share/run.sh
#
ENTRYPOINT ["/usr/share/run.sh"]
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 443