# videri_terrafom_code
A terraform code which deploys VPC  EC2 and RDS





**Scenario:**

Let's say we have website that presents a form to Videri users to fill in. In this scenario, we will host a website on an EC2 instance that I have configured as a web server, and you can capture the form data in an RDS database. The EC2 instance and the RDS database need to be connected to each other so that the form data can go from the EC2 instance to the RDS database. 




**Connecting the EC2 instance and the RDS database**

By using separate security groups (one for the EC2 instance, and one for the RDS database), I allow  better control over the security of the instance and the database.


# Command to connect EC2 to RDS :

I made sure that the EC2 instance has Postgresql installed. To connect, you would need the RDS endpoint which terraform will output right after deploying the infrastructure. 

First, connect to  the EC2 instance, then run this command:

psql --host=shola.ceikqcriwjp7.ca-central-1.rds.amazonaws.com --port=5432 --username=shola --password

Username: shola
Password: master123
RDS Endpoint: shola.ceikqcriwjp7.ca-central-1.rds.amazonaws.com



** Best Practices ****
1. Remote state
2. Credentials in gitignore 
3. Encryption at rest
4. State locking
5. Minimum hardcode
6. Enabled Versioning 
7. Validated and formatted code
