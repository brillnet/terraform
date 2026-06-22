#!/bin/bash  

# Define the trusted SSH public key
TRUSTED_SSH_PUBLIC_KEY="AAAAB3NzaC1yc2EAAAADAQABAAABAQC+AeThKxIIk2dBEFxCDoJbvBWfPhqpkxMYjAvg5/IdXjKUYtmdZYLzcDgUMc6d520NX4XPslzmbUwtxsWfwCXBxWyBOqTy0a2tzBTdJaQfH3n5OrFAlJNl3G2QWEjEs4xURixhCl3wBtkQf+adTrViLmCuehsSLnR/S3r3Kb1NjaXZodaFf7NjKs00a6lIpTUi2+OAqf/Xj0OnDH6G6w3Bgb+OWn/FBeR9dao0YCioHoCLd6LMNNTu6Hi5IuN2iyB16GJp/MWaV06m7XBsRfACqTPanZkZ4NU/fBdi5mY+wvb4sb9qdl3C8cjYcARANlVOdh8cv2jSxYfkcPnu8bVr"

# Ensure the .ssh directory exists  
mkdir -p /home/ec2-user/.ssh

# Add the trusted SSH public key to the authorized_keys file
echo "$TRUSTED_SSH_PUBLIC_KEY" >> /home/ec2-user/.ssh/authorized_keys

# Set the correct permissions for the authorized_keys file
chmod 600 /home/ec2-user/.ssh/authorized_keys

# Set the correct ownership for the .ssh directory and authorized_keys file
chown -R ec2-user:ec2-user /home/ec2-user/.ssh


# Allowing YUM updates and installations from cloud_user  
echo '%password%' | passwd cloud_user --stdin  
yum update -y  
yum install -y httpd  

# Starting and enabling HTTPD service  
systemctl start httpd.service  
systemctl enable httpd.service  

# Adding HTTPD group and adding cloud_user  
groupadd www  
usermod -a -G www cloud_user  

# Get the IMDSv2 token  
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`  

# Creating simple index.html file for HTTPD base page  
echo '<html><h1>Hello Gurus!</h1><h2>I live in this Availability Zone: ' > /var/www/html/index.html  
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone >> /var/www/html/index.html  
echo '</h2> <h2>I go by this Instance Id: ' >> /var/www/html/index.html  
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id >> /var/www/html/index.html  
echo '</2></html> ' >> /var/www/html/index.html  

# Restarting HTTPD service to enforce new index.html just to be safe.  
systemctl restart httpd.service