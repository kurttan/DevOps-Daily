start:
	(cd ./cmd && ./start_service.sh)

check:
	(cd ./cmd && ./health_check.sh)

test:
	(cd ./code/gateway && make test)

jobs:start
	echo "TODO"

install:
	(cd ./cmd && ./installation.sh)

upgrade:
	(cd ./cmd && ./upgrade.sh)
