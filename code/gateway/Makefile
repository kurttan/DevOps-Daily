start:
	(cd gateway && nohup python ./server.py &)
test:
	./tests.sh all  2>/dev/null | grep error

test2:
	./tests.sh all

update:
	(cd cmd && ./mongo_index.sh '2014-01-27')

install:
	(cd ./cmd && ./install.sh)

clean:
	./tests.sh clean
