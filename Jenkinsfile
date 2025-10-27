pipeline {
    agent any
    triggers {
        pollSCM('0 * * * *') // every 1 hour
    }
    environment {
        REPO_URL = "https://github.com/EsraaShaabanElsayed/ci-cd-pipeline-with-jenkins-docker-ansible-aws.git"
        
        IMG_NAME = "JenkinsLabImage:latest"
        PORT = "3000"
    }

    stages {
        stage('Checkout') {
            steps {
                    git url: "${REPO_URL}", branch: 'jenkins-lab' 
                    
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                script {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }
        stage('Run Container') {
            steps {
                echo "Running Docker container..."
                script {
                    // Stop and remove old container if it exists
                    sh """
                    if [ \$(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                        docker stop ${CONTAINER_NAME}
                        docker rm ${CONTAINER_NAME}
                    fi
                    docker run -d -p ${PORT}:${PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest
                    """
                }
            }
        }
    }
}
        

      
     
