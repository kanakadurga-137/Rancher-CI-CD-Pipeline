FROM centos/httpd
USER root

RUN sudo systemctl stop httpd.service
RUN rm -rf /var/www/html/index.html
RUN cp /var/lib/jenkins/workspace/test/homepage.html /var/www/html/index.html

RUN sudo systemctl start httpd.service
