pipeline { 
    agent any 
    stages { 
        stage('Deploy To Kubernetes') { 
            steps { 
                withKubeCredentials(kubectlCredentials: [[
                    caCertificate: '', 
                    clusterName: 'EKS-2', 
                    contextName: '', 
                    credentialsId: 'k8-token', 
                    namespace: 'webapp', 
                    serverUrl: 'https://879475DB8F20768E465B0037A897A157.gr7.us-west-2.eks.amazonaws.com'
                ]]) { 
                    sh "kubectl apply -f deployment-service.yml" 
                } 
            } 
        } 
        stage('Verify Deployment') { 
            steps { 
                withKubeCredentials(kubectlCredentials: [[
                    caCertificate: '', 
                    clusterName: 'EKS-2', 
                    contextName: '', 
                    credentialsId: 'k8-token', 
                    namespace: 'webapp', 
                    serverUrl: 'https://879475DB8F20768E465B0037A897A157.gr7.us-west-2.eks.amazonaws.com'
                ]]) { 
                    sh "kubectl get svc -n webapp" 
                } 
            } 
        } 
    } 
}
