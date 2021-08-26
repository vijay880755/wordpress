pipeline {
    agent any
    environment{
     registry = "765771042989.dkr.ecr.ap-south-1.amazonaws.com"
    }
    stages {
        stage('Clone WordPress Repository') {
            steps {
            git 'https://github.com/vijay880755/wordpress.git'
            }
        }
        stage('Building Docker Stack'){
            steps{
                sh 'docker system prune -af'
                sh 'docker -v'
                script{
                docker.withRegistry("https://"+registry, "ecr:ap-south-1:Wordpress") {
                    def customImage = docker.build(registry+"/clever-tap:wordpress_${BUILD_NUMBER}")            
                     customImage.push()
                }
                }
            }
            
        }
        stage('Deploying to Fargate'){
            steps{
                sh 'whoami'
                sh 'cd terraform && /usr/local/bin/terraform init && /usr/local/bin/terraform validate && /usr/local/bin/terraform plan -input=false && /usr/local/bin/terraform apply -var="tag=wordpress_${BUILD_NUMBER}" -auto-approve'
            }
        }
    }
}
