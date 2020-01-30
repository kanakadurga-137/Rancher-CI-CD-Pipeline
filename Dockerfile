FROM centos/httpd
USER root

RUN service stop httpd
RUN rm -rf /var/www/html/index.html
RUN cp /var/lib/jenkins/workspace/test/homepage.html /var/www/html/index.html

RUN service start httpd
