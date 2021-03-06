SRC=external_src

DEP_INCLUDE_DIR=deps/include
DEP_LIB_DIR=deps/lib

CLONE_DIR=packages

LOCAL_REPO_DIR=$(HOME)/git-repos

CXXURL_DIR=$(SRC)/CxxUrl
URLPARSER_DIR=$(SRC)/uri
SIMPLEBUFFER=simple_buffer.h simple_buffer.c
HTTP_PARSER_C=http_parser.c http_parser.h

MYINSTALLS=$(HOME)/MyInstalls
OPENSSL_DIR=$(MYINSTALLS)/openssl/openssl-1.0.1g
OPENSSL_INCLUDE = $(OPENSSL_DIR)/include
OPENSSL_LIBS=$(OPENSSL_DIR)

$(CLONE_DIR):
	mkdir $(CLONE_DIR)
	
$(SRC):
	mkdir $(SRC)

$(CXXURL_DIR):	
	mkdir $(CXXURL_DIR)

$(URLPARSER_DIR):	
	mkdir $(URLPARSER_DIR)

cpp-catch:
	git clone $(LOCAL_REPO_DIR)/cpp-catch $(CLONE_DIR)/cpp-catch
	cp $(CLONE_DIR)/cpp-catch/*.hpp  $(SRC)/


simple_buffer:
	git clone $(LOCAL_REPO_DIR)/simple_buffer $(CLONE_DIR)/simple_buffer
	cp $(CLONE_DIR)/simple_buffer/src/*.c  $(SRC)/
	cp $(CLONE_DIR)/simple_buffer/src/*.h  $(SRC)/

http_parser:
	git clone $(LOCAL_REPO_DIR)/http-parser $(CLONE_DIR)/http-parser
	cp $(CLONE_DIR)/http-parser/http_parser.c  $(SRC)/
	cp $(CLONE_DIR)/http-parser/http_parser.h  $(SRC)/

cxxurl: $(CXXURL_DIR)
	rm -rf $(CLONE_DIR)/cxxurl
	git clone https://github.com/chmike/CxxUrl.git $(CLONE_DIR)/cxxurl
	# git clone $(REPO_DIR)/http-parser $(CLONE_DIR)/http-parser
	cp $(CLONE_DIR)/CxxUrl/url.hpp  $(CXXURL_DIR)/
	cp $(CLONE_DIR)/CxxUrl/url.cpp  $(CXXURL_DIR)/

urlparser:: $(URLPARSER_DIR)
	rm -rf $(CLONE_DIR)/urlparser
	git clone https://github.com/CovenantEyes/uri-parser.git  $(CLONE_DIR)/urlparser
	cp $(CLONE_DIR)/urlparser/UriParser.hpp  $(URLPARSER_DIR)/

openssl_include:
	-rm -rf $(DEP_INCLUDE_DIR)/openssl
	ln -s $(OPENSSL_INCLUDE)/openssl $(DEP_INCLUDE_DIR)/openssl

openssl_libs:
	-rm $(DEP_LIB_DIR)/libcrypto.a
	ln -s $(OPENSSL_LIBS)/libcrypto.a $(DEP_LIB_DIR)/libcrypto.a
	-rm $(DEP_LIB_DIR)/libssl.a
	ln -s $(OPENSSL_LIBS)/libssl.a $(DEP_LIB_DIR)/libssl.a


openssl: openssl_include openssl_libs


install_deps: $(CLONE_DIR)  $(SRC) simple_buffer http_parser cpp-catch cxxurl urlparser
	
	
clean_CLONE_DIR:	
	rm -Rf $(SRC)/*
	rm -Rf $(CLONE_DIR)/*