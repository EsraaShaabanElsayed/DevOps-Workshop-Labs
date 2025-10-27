pipeline {
    agent any

    triggers {
        pollSCM('0 * * * *') // Check for changes every 1 hour
    }

    environment {
        REPO_URL = "https://github.com/EsraaShaabanElsayed/DevOps-Workshop-Labs.git"
        IMAGE_NAME = "esraa/nodejs-lab"
        CONTAINER_NAME = "nodejs-lab-container"
        PORT = "9898"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code from ${REPO_URL}..."
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

    post {
        always {
            echo "Pipeline completed!"
            sh "docker ps | grep ${CONTAINER_NAME} || true"
        }
    }
}
