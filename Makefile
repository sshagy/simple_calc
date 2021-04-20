PACK_PATH=pack
PACK_VENV_PIP=$(PACK_VENV_DIR)/bin/pip
PACKAGES=$(shell grep -E '(common|^aioworkers)' Pipfile | sed -r 's/([-a-z]+) = (.*)\"(.*)\".*/\1\3/')

export PIP_CONFIG_FILE=$(shell pwd)/setup.cfg


.PHONY: all clean test mypy flake isort dist dist/assets rebuild \
		install-deps yacalc.tgz yacalc/version.py

all: install-deps

clean:
	@rm -rf `find . -name __pycache__`
	@rm -f `find . -type f -name '*.py[co]'`
	@rm -f yacalc/version.py
	@python setup.py clean
	@rm -f .make-*
	@rm -rf *.egg-info
	@rm -f Pipfile.lock

lint: mypy flake

mypy:
	@mypy yacalc

flake:
	@flake8 yacalc tests

isort:
	@isort setup.py
	@isort -rc yacalc
	@isort -rc tests

install-deps:
	pip install pipenv
	pipenv install -d

test:
	@pytest tests

ci-test:
	pytest --junit-xml=$(JUNITXML) --cov=yacalc --cov-report=html

cococo_pack:
	@etc/scripts/cococo/git_wrapper.sh $(MAKE) yacalc.tgz 1>&2

yacalc.tgz: yacalc/version.py
	rm -rf build pack yacalc.tgz
	mkdir -p $(PACK_PATH)
	cp Makefile $(PACK_PATH)
	mkdir -p $(PACK_PATH)/etc
	cp -r etc/scripts $(PACK_PATH)/etc/scripts
	cp -r definitions.yaml $(PACK_PATH)
	cp -r static $(PACK_PATH)
	mkdir -p $(PACK_PATH)/pythonlib
	virtualenv -p "python3.6" "$(PACK_VENV_DIR)"
	$(PACK_VENV_PIP) install pip==20.2.4
	unset https_proxy && $(PACK_VENV_PIP) install --no-deps --target $(PACK_PATH)/pythonlib $(PACKAGES) .
	tar czf $@ -C $(PACK_PATH) .

yacalc/version.py:
	echo "__version__ = '$(shell git describe --tags --always)'" > $@

requirements.txt:
	pipenv lock -r | grep -v '\-i http' > requirements.txt

merge_to_test1:
	$(MAKE) .merge_to_test1 BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

.merge_to_test1:
	git stash
	git checkout test1
	git pull
	git merge $(BRANCH)
	git push origin test1
	git checkout $(BRANCH)
	git stash pop
