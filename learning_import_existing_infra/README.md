## Generate terraform for existing infra

In main.tf we will use the below block 

    #  import {
    #  id = "i-10675489090hj6358"  # resource ID for which we need to generate terraform 
    #  to = aws_instance.example  # reource type with name of resource which is required when terraform generated.
    # } 

    # the we will run the below command to generate the terraform 
        #terraform plan -generate-config-out=generated_resources.tf
    # once the terraform generate then we will copy that resource and create in main.tf file. Still if we run the terraform plan     command it will not work as excepted since there is no tfstate file for our terraform.
    # Now we will run the below command which will generate the state file for our resource.
        #terraform import aws_instance.example instanceID

