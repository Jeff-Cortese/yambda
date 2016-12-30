# yambda
AWS Lambda and API Gateway experimentation 

![yam](yam.jpg)


### Zero to Sixty
##### Install stuff
  - nodejs
  - serverless
   ````bash
$ npm install serverless -g
   ````
  - maven
  
##### Compile the lambda function
````bash
$ mvn clean install
````

##### Deployment
###### Set your aws access key and secret
````bash
$ serverless config credentials --provider aws --key your_access_key_here --secret your_aws_access_secret_here
````

###### Deploy it to aws
````bash
$ (cd services/myService && serverless deploy)
````

#### Result
If all succeeds, serverless will create a rest endpoint that is integrated with a lambda function in region us-east-1.
The deploy step above should output a link to the deployed endpoints, for example:
````
endpoints:
  GET - https://5sipr7ot82.execute-api.us-east-1.amazonaws.com/dev/hello
````

You can also view the provisioned aws resources in the aws console by going to the API Gateway or Lambda dashboards.