# Heroku-PrivateLink-Terraform-Automation
Magic of terraform and shell script to automate the process of provisioning Heroku PrivateLink which use to connect to a Private Heroku Postgres Database from an Amazon VPC.

Prerequisites

- Terraform (https://learn.hashicorp.com/terraform/getting-started/install.html)
- Heroku CLI (https://devcenter.heroku.com/articles/heroku-cli)
- Heroku Private Space
- AWS account

Limitation - Currently it only works with `Virginia, United States` region of Heroku Private Space.

First clone the repository:

```
git clone https://github.com/dhavalthakkar93/Heroku-Docker-Communication-POC
```

Create Heroku Application (optional, if you already have application):

```
heroku create -a <APPLICATION_NAME> --space <PRIVATE_SPACE_NAME>

Creating ⬢ <APPLICATION_NAME> in <PRIVATE_SPACE_NAME>... done
http://<APPLICATION_NAME>.herokuapp.com/ | https://git.heroku.com/<APPLICATION_NAME>.git
```

Provision Private Tier Heroku Postgres database to the application (optional, if you already provisioned database to the application):

```
heroku addons:create heroku-postgresql:private-0 -a <APPLICATION_NAME>

Creating heroku-postgresql:private-0 on ⬢ <APPLICATION_NAME>... $300/month
This database will be created in a private space.
The database should be available in 3-5 minutes.
```

Export AWS credentials:

```
export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
```

Run following command and supply following values to script when it prompts:

- AWS_ACCOUNT_ID
- POSTGRES_ADDON_NAME
- Heroku Application Name

```
sh heroku-privatelink-setup.sh
```
```
Creating privatelink endpoint... done

Service Name: Provisioning
Status:       Provisioning

The privatelink endpoint is now being provisioned for postgresql-symmetrical-37148.
Run heroku pg:privatelink:wait --app APP to check the creation process.
Waiting for the privatelink endpoint to be provisioned... done
=== privatelink endpoint status for postgresql-symmetrical-37148
Service Name: <SERVICE_NAME>
Status:       Operational

=== Whitelisted Accounts
ARN                            Status
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx Provisioning

Your privatelink endpoint is now operational.
```
This command will take 10-15 minutes to complete.

Make note of the <SERVICE_NAME>.

Run following command (for the first time):

```
terraform init
```
Run following command and supply following values when it prompts:

- EC2 key pair name (.pem file name, Which you can find in your AWS EC2 dashboard under keypairs menu)
- Service Name (which generated previously)

```
terraform apply
```
This command can take 5-15 minutes to complete.

Once everything completed you will find config_var in your Heroku applications dashboard with connection string which you can use to connect from the Instance which created by this script or you can use this connection string to connect to private database from any resources from VPC created by this script.

You can run following command to get the connection string, It can take 5-15 minutes to provision:

```
heroku config --app <APPLICATION_NAME> | grep DATABASE_ENDPOINT
```

To destroy the created AWS Infrastructure you can run following command:

```
terraform destroy
```


#### SSH Tunnel

We can setup SSH tunnel through EC2 instance (Must be in the same VPC) for local environment to access private database which configured with PrivateLink

You can run following command in your local machine to setup SSH tunnel:

```
ssh -f -i <AWS_EC2_INSTANCE_KEY> <EC2_USERNAME>@<EC2_PUBLIC_IP/<PUBLIC_DNS> -L <LOCAL_PORT>:<DATABASE_HOST>:5432 -N -v
```

You can get the **DATABASE_HOST** from Heroku config var use following command:

```
heroku config --app your_app_name | grep ENDPOINT_ID_HERE
```

Use following command to connect to your private database from local machine:

```
psql postgres://<DB_USER>:<DB_PASSWORD>@localhost:<LOCAL_PORT>/<DATABASE_NAME>
```
