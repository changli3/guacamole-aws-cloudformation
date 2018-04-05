# AWS Template to set up a standalone Guacamole Server

## Prelaunch Notes

I wanted to start a project to set up an array of Guacamole servers that can be authenticated via SAML and authorized through LDAP groups. Just started and still working on it.

Right now, it just stands up a Guacamole Server with no configuration yet.

## Usage

```
git clone https://github.com/changli3/guacamole-aws-cloudformation.git

cd guacamole-aws-cloudformation

aws cloudformation deploy --stack-name GuacamoleSvr01 --parameter-overrides \
	ContentAdminPassword=admin123 \
	ContentAdminUser=admin \
	KeyPairName=TreaEBSLab \
	RegEmail=chang.li3@treasury.gov \
	RegFirstName=Chang \
	RegLastName=Li \
	AmiImageId=ami-e443379e \
	InstanceSubnet=subnet-2b976000 \
	InstanceSecurityGroup=sg-58e1fc3d \
    TableauServerLicenseKey= \
	TableauServerExe="https://downloads.tableau.com/esdalt/10.5.0/TableauServer-64bit-10-5-0.exe" \
    TableauServerCrt="https://s3.amazonaws.com/trlab-templates/tableau.crt" \
    TableauServerKey="https://s3.amazonaws.com/trlab-templates/tableau.key"  \
    --template-file guac.tpl.yml
```

