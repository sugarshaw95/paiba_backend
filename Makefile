VENV = ./venv
REQUI = ./requirements
REQUI_DEV = $(REQUI)/local.txt
REQUI_TST = $(REQUI)/test.txt
REQUI_DEP = $(REQUI)/production.txt

dev: $(REQUI_DEV)
	rm -rf $(VENV)
	virtualenv $(VENV) \
	&& . ./$(VENV)/bin/activate \
	&& pip install -r $<

test: $(REQUI_TST)
	rm -rf $(VENV)
	virtualenv $(VENV) \
	&& . ./$(VENV)/bin/activate \
	&& pip install -r $<

deploy: $(REQUI_DEP)
	rm -rf $(VENV)
	virtualenv $(VENV)
	virtualenv $(VENV) \
	&& . ./$(VENV)/bin/activate \
	&& pip install -r $<

clean:
	rm -rf $(VENV)

.PHONY: dev test deploy clean
