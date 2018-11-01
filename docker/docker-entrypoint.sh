#!/bin/bash
if [ "$AWS" = 1 ] ; then
    # Getting region
    EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
    EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
    echo "Running in availability-zone '$EC2_AVAIL_ZONE' and region '$EC2_REGION'"
    # Getting Params
    DATABASE_USER=$(aws ssm get-parameters --names "$SERVICE_NAME-db_user" --region $EC2_REGION --query Parameters[0].Value --output text)
    DATABASE_PWD=$(aws ssm get-parameters --names "$SERVICE_NAME-db_password" --with-decryption --region $EC2_REGION --query Parameters[0].Value --output text)
    DATABASE_HOST=$(aws ssm get-parameters --names "$SERVICE_NAME-db_endpoint" --region $EC2_REGION --query Parameters[0].Value --output text)
    DATABASE_PORT=$(aws ssm get-parameters --names "$SERVICE_NAME-db_port" --region $EC2_REGION --query Parameters[0].Value --output text)
    DATABASE_NAME=$(aws ssm get-parameters --names "$SERVICE_NAME-db_name" --region $EC2_REGION --query Parameters[0].Value --output text)
    # Availaible for that shell

#     TODO à remplacer par les configs de prod qui se trouve dans config_prod ? seulment pour okta.
#     Onesignal, on peut utiliser le même id pas de soucis.
    # Setting symfony parameter.yml

     path_folder_import='/var/www/html/back/data/'

     export DATABASE_HOST DATABASE_NAME DATABASE_PORT DATABASE_USER DATABASE_PWD
     export path_folder_import


else
  php bin/console c:c
fi

echo "Running in '$APP_ENV' env"


rm -rf var/cache/*

php bin/console d:d:d --force --env=$APP_ENV
php bin/console d:d:c --env=$APP_ENV
php bin/console d:s:c --env=$APP_ENV
#php bin/console doctrine:schema:update --env=$APP_ENV --force

php bin/console d:m:m --env=$APP_ENV --no-interaction
chmod -R 777 var/cache/ var/log/
exec "$@"
