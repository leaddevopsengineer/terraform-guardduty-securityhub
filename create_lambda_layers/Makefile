get-lambda-layer:
	@echo ___ Starting Lambda Layer creation Utility ____
	@echo ___ Running Ubuntu container ___
	docker run -dit --name ubuntu ubuntu:latest
	@echo ___ copying requirements file to container ___
	docker cp ./requirements.in ubuntu:/root/requirements.in
	docker exec -it ubuntu bash -c "apt -y update \
		&& apt install -y python3 python3-pip \
		&& python3 --version \
		&& apt-get install -y zip \
		&& cd /root/ \
		&& pwd \
		&& mkdir -p build/python/lib/python3.10/site-packages \
		&& python3 -m pip install --upgrade pip \
		&& pip3 install -r /root/requirements.in -t build/python/lib/python3.9/site-packages \
		&& pip3 install -r /root/requirements.in -t build/python/lib/python3.8/site-packages \
		&& cd build \
		&& zip -r package.zip ."
	docker cp ubuntu:/root/build/package.zip .