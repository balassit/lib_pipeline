VIRTUALENV		    := python3 -m venv . && source bin/activate
PIP				    := pip3 install -r
PYTHON_VERSION		:= python3.7
.PHONY: all build clean

all: clean build

build:
	$(VIRTUALENV) && \
	$(PIP) requirements.txt

clean:
	rm -rf bin && \
	rm -rf include && \
	rm -rf lib
