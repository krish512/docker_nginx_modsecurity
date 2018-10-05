FROM owasp/modsecurity:v3-ubuntu-nginx as base

## Version for ModSecurity Core Rule Set
ARG VERSION=3.0.2

## Install Curl
RUN apt-get update && apt-get install curl -y && apt-get clean

## Get ModSecurity CRS
RUN curl https://codeload.github.com/SpiderLabs/owasp-modsecurity-crs/tar.gz/v${VERSION} --output ~/modsec.tar.gz
RUN tar -xzf ~/modsec.tar.gz -C /etc/nginx
RUN rm ~/modsec.tar.gz

## Install ModSecurity CRS
RUN cat /etc/nginx/owasp-modsecurity-crs-${VERSION}/crs-setup.conf.example /etc/nginx/owasp-modsecurity-crs-${VERSION}/rules/*.conf >> /etc/nginx/modsecurity.d/crs.conf
RUN cp /etc/nginx/owasp-modsecurity-crs-${VERSION}/rules/*.data /etc/nginx/modsecurity.d/
RUN rm -rf /etc/nginx/owasp-modsecurity-crs-*
RUN echo "include /etc/nginx/modsecurity.d/crs.conf">>/etc/nginx/modsecurity.d/include.conf
RUN sed -i -e 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /etc/nginx/modsecurity.d/modsecurity.conf

## Update nginx config
COPY nginx /etc/nginx/