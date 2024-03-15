IMAGE_NAME:= openid-connect-4-identity-assurance
SPEC_FILES:= $(wildcard openid-*.md)

all: build mmark xml2rfc

build:
	docker build -t $(IMAGE_NAME) .

mmark: $(patsubst %.md, %.xml, $(SPEC_FILES))

xml2rfc: $(patsubst %.md, %.html, $(SPEC_FILES))

%.xml: %.md
	docker run --rm -v $$(pwd):/opt $(IMAGE_NAME) mmark $< > $@

%.html: %.xml
	docker run --rm -v $$(pwd):/opt $(IMAGE_NAME) xml2rfc -p . --html $<
