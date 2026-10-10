DIR=testdir
MAL=quarantine
INTERVAL=3

setup:
    mkdir -p $(MAL)

run: setup
	./antivirusd.sh $(DIR) $(MAL) $(INTERVAL)

restore: setup
	./restore.sh $(MAL) $(DIR)
