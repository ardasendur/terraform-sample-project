#!/bin/bash


#Constants
AUTO_APPROVE="-auto-approve"
TERRAFORM_PATH="terraform/aws"

push_docker_image_to_ecr(){
  echo test
}

terraform_validate(){
   terraform init
   terraform validate
}
terraform_plan(){
  terraform init
  terraform plan -var-file=app.tfvars
}
terraform_graph(){

   terraform init
   terraform graph

}
terraform_apply(){
  terraform init
  terraform apply -var-file=app.tfvars $AUTO_APPROVE

}
terraform_destroy(){
    terraform destroy -var-file=app.tfvars $AUTO_APPROVE

}

main(){

    if [[ "$1"  == "serverless-app" ]] ; then export PROJECT_PATH="serverless-app";elif [[ "$1"  == "containerized-app" ]] ; then export PROJECT_PATH="containerized-app" ;else echo false ; fi
    echo "Navigated Project Path: $PROJECT_PATH"
    cd $PROJECT_PATH/$TERRAFORM_PATH/

    if [ "$2" == "validate" ]; then
        echo "validate starting"
        terraform_validate

    elif [ "$2" == "plan" ]; then
        terraform_plan

    elif [ "$2" == "apply" ]; then
        terraform_apply

    elif [ "$2" == "destroy" ]; then
        terraform_destroy

    elif [ "$2" == "graph" ]; then
        terraform_graph
    fi
}
 main "$@"
