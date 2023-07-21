# oclc-download-files
Download OCLC xref files.

## Setting up oclc-download-files

Clone the repo

```
git clone git@github.com:dfulmer/oclc-download-files.git
cd oclc-download-files
```

copy .env-example to .env

```
cp .env-example .env
```

edit .env with actual environment variables

build container
```
docker-compose build
```

bundle install
```
docker-compose run --rm app bundle install
```

start container
```
docker-compose up -d
```

## Using This to Download Files
docker-compose run --rm app bundle exec ruby oclc_ftp_downloader.rb

## Flowchart
![downloadflow](https://github.com/dfulmer/oclc-download-files/assets/18075253/77721e03-7fff-48ab-aa41-2a8bb0d093b5)
