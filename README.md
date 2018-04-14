# AWS Template to set up a standalone Guacamole Server

## Prelaunch Notes

I wanted to start a project to set up an array of Guacamole servers that can be authenticated via SAML and authorized through LDAP groups and/or database settings. The targeted architecture:
![targeted architecture](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/final.JPG "targeted architecture") -- working on this.



I have set up a standalone Guacamole Server which use local mysql as authentication and authorization source and a cluster with Autoscaled Guacamole Servers and RDS on the backend. While this works for a lot people but not us since we need to support SAML/PIV authentication.
![Guacamole Cluster](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/cluster.JPG "Guacamole Cluster")

# Launch Standalone Guacamole Server

```
git clone https://github.com/changli3/guacamole-aws-cloudformation.git

cd guacamole-aws-cloudformation

aws cloudformation deploy --stack-name GuacamoleSvr01 --parameter-overrides \
	Ami=ami-43a15f3e  \
    InstanceTypeParameter=t2.small \
    InstanceSubnet=subnet-2b976000 \
    SecurityGroupId=sg-58e1fc3d \
    InstanceKeyPairParameter=TreaEBSLab \
    mysqlRootPassword=mysqlRootPassword \
    mysqlGuacaPassword=mysqlGuacaPassword \
    GuacadminUser=guacaadmin \
    GuacadminPassword=guacaadmin \
    --template-file guac.tpl.yml
```

### Access
Please wait for about 15 minutes for the installation to finish. Then go to http://private-Ip/guacamole and login with the provided GuacadminUser and GuacadminPassword.

### Login Screen
Login with the provided GuacadminUser and GuacadminPassword:
![Login Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/login.JPG "Login Screen")

### Dashboard Screen
Once login, click on one of the predefined connection resources:
![Dashboard Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/dashbd.JPG "Dashboard Screen")

### Settings
From dropdown of the user name, select Settings, and then Connections tab:
![Settings Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/settings.JPG "Settings Screen")

### Add a RDP Connection
Click "New Connection", and then enter name, select RDP protocal and enter newwork IP address (or name):
![New Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/rdpconfig.JPG "New Screen")

### RDP Screen
Save the connection, from dropdown of the user name, select "Home" and then click the newly created RDP connection:
![RDP Screen](https://raw.githubusercontent.com/changli3/guacamole-aws-cloudformation/master/rdp.JPG "RDP Screen")

# Launch Guacamole Server Cluster with RDS Backend

Launch the cluster with the template guac-cluster.yml. Please note that there will be autoscaling group and RDS instances.

```
aws cloudformation deploy --stack-name GuacamoleCluster01 --parameter-overrides Ami=ami-43a15f3e  InstanceType=t2.small  SubnetID1=subnet-09f8ca52 SubnetID2=subnet-e0eb9685   SecurityGroupId=sg-58e1fc3d  KeyName=TreaEBSLab  mysqlRootUser=mysqlRootUser  mysqlRootUserPassword=mysqlRootUserPassword GuacadminUser=guacaadmin  GuacadminPassword=guacaadmin VpcId=vpc-b3870dd6 Sg=sg-58e1fc3d --capabilities CAPABILITY_IAM --template-file guac-cluster.yml
```

# Launch Guacamole Server Cluster with RDS/LDAP Backend and SAML SSO
working on the cloudformation template and scripts....