pipeline {
  agent any

  environment {
    AWS_REGION   = 'ap-south-1'
    ECR_REGISTRY = '302174038464.dkr.ecr.ap-south-1.amazonaws.com'
    ECR_REPO     = 'streamapp'
    IMAGE_TAG    = "${BUILD_NUMBER}"
    GITOPS_REPO  = 'https://github.com/mayurwarungase11/streamapp-gitops.git'
  }

  stages {

    stage('📥 Checkout Code') {
      steps {
        checkout scm
        echo "✅ Code checked out - Build #${BUILD_NUMBER}"
      }
    }

    stage('📦 Install Dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('🧪 Run Tests') {
      steps {
        sh 'npm test'
      }
      post {
        always {
          junit 'coverage/junit.xml'
        }
      }
    }

    stage('🐳 Build Docker Image') {
      steps {
        sh """
          docker build \
            --build-arg BUILD_NUMBER=${BUILD_NUMBER} \
            -t ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} \
            -t ${ECR_REGISTRY}/${ECR_REPO}:latest \
            .
        """
        echo "✅ Docker image built: ${ECR_REPO}:${IMAGE_TAG}"
      }
    }

    stage('🚀 Push to AWS ECR') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-credentials'
        ]]) {
          sh """
            aws ecr get-login-password --region ${AWS_REGION} | \
            docker login --username AWS --password-stdin ${ECR_REGISTRY}
            docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
            docker push ${ECR_REGISTRY}/${ECR_REPO}:latest
          """
        }
        echo "✅ Image pushed to ECR: ${IMAGE_TAG}"
      }
    }

    stage('📝 Update GitOps Repo') {
      steps {
        withCredentials([string(credentialsId: 'github-token', variable: 'GIT_TOKEN')]) {
          sh """
            rm -rf streamapp-gitops
            git clone https://${GIT_TOKEN}@github.com/mayurwarungase11/streamapp-gitops.git
            cd streamapp-gitops
            sed -i 's/tag:.*/tag: "${IMAGE_TAG}"/' helm/streamapp/values.yaml
            git config user.email "jenkins@streamapp.com"
            git config user.name "Jenkins CI"
            git add helm/streamapp/values.yaml
            git commit -m "Deploy: Update image to build #${IMAGE_TAG}"
            git push
          """
        }
        echo "✅ GitOps repo updated - ArgoCD will auto-deploy"
      }
    }
  }

  post {
    success {
      echo """
      ✅ Pipeline SUCCESS
      App: StreamApp
      Build: #${BUILD_NUMBER}
      Image: ${ECR_REPO}:${IMAGE_TAG}
      Status: ArgoCD deploying to EKS...
      """
    }
    failure {
      echo "❌ Pipeline FAILED at Build #${BUILD_NUMBER} - Check logs above"
    }
    always {
      sh "docker rmi ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} || true"
    }
  }
}
