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
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
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

    // Build the image used to build the resume document
    stage('Build Image') {
      agent {
      	kubernetes {
	  cloud 'kappa'
	  defaultContainer 'kaniko'
	  yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
    - name: cache
      mountPath: /cache
  volumes:
  - name: cache
    persistentVolumeClaim:
      claimName: build-kaniko-cache
"""
	}
      }
      steps {
	script {
	  buildtag = "$BRANCH_NAME-$BUILD_NUMBER".replaceAll('[^a-zA-Z0-9]', "-")
	}
	sh """
	  /kaniko/executor --context=`pwd` --destination=localhost:$regport/build/github-resume-build:$buildtag --insecure --skip-tls-verify --cache
	"""
      }
    }

  }
}

// vi: sw=2 ai
