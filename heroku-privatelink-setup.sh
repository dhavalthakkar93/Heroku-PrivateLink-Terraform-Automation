#!/bin/sh

heroku plugins:install pg-privatelink

read -p "

You can obtain your AWS account ID with the AWS CLI like so: $ aws sts get-caller-identity --output text --query 'Account' 

or 

You can also obtain your account ID from the My Account page of your AWS account. The Account ID is shown in the Account Settings section

Enter AWS Account ID:" aws_account_id

read -p "Enter your POSTGRES_ADDON_NAME:" postgres_addon_name

read -p "Enter your Heroku application name:" heroku_application_name

heroku pg:privatelink:create $postgres_addon_name --aws-account-id $aws_account_id --app $heroku_application_name

heroku pg:privatelink:wait --app $heroku_application_name

heroku pg:privatelink $postgres_addon_name --app $heroku_application_name