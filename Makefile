bootstrap:
	npm install -g serverless
	sls plugin install -n serverless-wsgi
	sls plugin install -n serverless-python-requirements

reqs:
	pipenv requirements > src/requirements.txt

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean: clean-pyc
	- rm -rf ./dist
	- cd src && serverless requirements clean

prep: clean reqs

deploy: prep
	cd src && serverless deploy

un-deploy:
	cd src && serverless remove

package: prep
	mkdir -p ./dist
	cd src && serverless package --package ../dist

serve:
	cd src && serverless wsgi serve

run:
	FLASK_APP=src/app.py pipenv run flask run

shell:
	pipenv shell

