# #!/bin/sh
# set -x
# # output log of userdata to /var/log/user-data.log
# exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
# yum install -y httpd
# service httpd start
# chkonfig httpd on
# echo "<html><h1>Hello from Appychip</h2></html>" > /var/www/html/index.html

#!/bin/bash

yum update -y
yum install -y httpd
echo '<h1>Hello World</h1>' > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd