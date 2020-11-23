pipeline {
  agent none
  stages {

    // Determine the nodeport of the Docker registry service running in this cluster for use later in this pipeline
    stage('Kubernetes Information') {
      agent {
      	kubernetes {
	  cloud 'kappa'
	  yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kubectl
    image: bitnami/kubectl:1.18
    command:
    - cat
    tty: true
"""
	}
      }
      steps {
      	container('kubectl') {
	  script {
	    regport = sh(script: 'kubectl get service/registry -n registry -o jsonpath={.spec.ports[0].nodePort}', returnStdout: true).trim()
	    echo "Registry node port = $regport"
	  }
	}
      }
    }

  }
}

// vi: sw=2 ai
