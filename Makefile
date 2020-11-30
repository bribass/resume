# Simple GNU makefile to help in authoring the resume.

all: out/resume.pdf

out/resume.pdf: resume.tex
	mkdir -p out || true
	TEXINPUTS=.:$(CURDIR)/.kubernetes/secrets: pdflatex -output-directory=out resume.tex

clean:
	rm -rf out

