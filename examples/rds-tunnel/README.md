# rds-tunnel

Creates an RDS instance and an EC2 Instance Connect enabled bastion for SSH tunneling

## Testing

You can make sure your tunnel is working with the following commands, assuming you're using all the default variables:

    $ ../../bin/ec2-tunnel
    $ psql -p 5432 -h localhost -U rds_demo -c "\dt"
