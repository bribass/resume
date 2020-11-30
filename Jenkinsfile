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
	  yaml """
apiVersion: v1
kind: Pod
metadata:
  annotations:
    container.apparmor.security.beta.kubernetes.io/img: unconfined
    container.seccomp.security.alpha.kubernetes.io/img: unconfined
spec:
  containers:
  - name: img
    image: r.j3ss.co/img
    command:
    - cat
    tty: true
    volumeMounts:
    - name: img-cache
      mountPath: /cache
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
    procMount: Unmasked
  volumes:
  - name: img-cache
    persistentVolumeClaim:
      claimName: build-img-cache
"""
	}
      }
      steps {
	container('img') {
	  script {
	    buildtag = "$BRANCH_NAME-$BUILD_NUMBER".replaceAll('[^a-zA-Z0-9]', "-")
	  }
	  sh """
	    img build --cache-from=type=local,src=/cache --cache-to=type=local,dest=/cache -t localhost:$regport/build/github-resume-build:$buildtag .
	    img push --insecure-registry localhost:$regport/build/github-resume-build:$buildtag
	  """
	}
      }
    }

  }
}

// vi: sw=2 ai
