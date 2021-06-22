#!/bin/bash


#Constants
AUTO_APPROVE="-auto-approve"
TERRAFORM_PATH="terraform/aws"


logger(){
    type_of_msg=$(echo $*|cut -d" " -f1)
    msg=$(echo "$*"|cut -d" " -f2-)
    [[ $type_of_msg == DEBUG ]] && [[ $do_print_debug_msgs -ne 1 ]] && return
    [[ $type_of_msg == INFO ]] && type_of_msg="INFO " # one space for aligning
    [[ $type_of_msg == WARN ]] && type_of_msg="WARN " # as well

    # print to the terminal if we have one
    test -t 1 && echo " [$type_of_msg] `date "+%Y.%m.%d-%H:%M:%S %Z"` ""$msg"
}

push_docker_image_to_ecr(){
  echo test

}

terraform_validate(){
   echo  "function is starting"
   terraform init
   terraform validate
   logger "INFO done"

}
terraform_plan(){
  logger "INFO terraform plan is starting"
  #terraform init
  #terraform plan -var-file=app.tfvars
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
    echo "Project path: $PROJECT_PATH"
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
 echo "test"
 main "$@"
