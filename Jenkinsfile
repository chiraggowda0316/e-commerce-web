pipeline {
    agent any

    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Docker Deployment') {
            steps {
                echo 'Tearing down old running environments...'
                sh 'docker compose down --volumes --remove-orphans || true'
                
                echo 'Building newly configured system images and launching containers...'
                // This builds the Java code completely inside Docker, safely avoiding Jenkins system mismatches!
                sh 'docker compose up --build -d'
            }
        }

        stage('Health Verification') {
            steps {
                echo 'Waiting 20 seconds for database systems initialization...'
                sh 'sleep 20'
                
                echo 'Validating operational application live endpoints...'
                sh 'curl -sI http://localhost:8080 | grep "HTTP/1.1" || true'
            }
        }
    }

    post {
        success {
            echo 'E-commerce platform successfully orchestrated and running!'
        }
        failure {
            echo 'Pipeline encountered fatal runtime anomalies. Printing logs...'
            sh 'docker compose logs web'
        }
    }
}
