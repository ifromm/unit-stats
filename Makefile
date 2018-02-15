CSV	= $(wildcard *.CSV)
PLOTS	= ${CSV:.CSV=_csv_plots.pdf}

.SUFFIXES: .CSV _csv_plots.pdf

.CSV_csv_plots.pdf: ass-stats.r
	./ass-stats.r $(basename $<) > $(basename $<)_stats.txt

all: $(PLOTS)

clean:
	rm *_CSV_plots.pdf

stats: all

new: clean all


