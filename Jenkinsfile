pipeline {
  agent {
    kubernetes {
      cloud 'kappa'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: latex
    image: bbassett/build-resume
    imagePullPolicy: Always
    tty: true
    volumeMounts:
    - name: resume-secrets
      mountPath: /tmp/secrets
      readOnly: true
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
  volumes:
  - name: resume-secrets
    secret:
      secretName: build-github-resume
"""
    }
  }
  stages {
    stage('Build Resume') {
      steps {
      	container('latex') {
	  sh """
	    git describe --always > version.inc
	    export TEXINPUTS=.:/tmp/secrets:
	    mkdir out
	    pdflatex -output-directory=out resume.tex
	  """
	}
      }
      post {
	success {
	  archiveArtifacts 'out/resume.pdf'
	}
      }
    }
  }
}

// vi: sw=2 ai
