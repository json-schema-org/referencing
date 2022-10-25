LIBDIR := lib
include $(LIBDIR)/main.mk

XML2RFC_CSS := $(LIBDIR)/.venv/lib/python3.8/site-packages/xml2rfc/data/xml2rfc.css

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update $(CLONE_ARGS) --init
else
	git clone -q --depth 10 $(CLONE_ARGS) \
	    -b main https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
