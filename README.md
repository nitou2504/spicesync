# SpiceSync
A recipes app writen in Dart & Flutter, along with its backend written in Python. The backend is composed by a MySQL database, a web scrapper and a restAPI using Flask. 

Developed as part of the Advanced Programing course `CMP3104` at USFQ.

## Usage
### Backend
Start the pre-configured mysql database for the project using docker-compose

```bash
docker-compose -f spicesync_backend/docker-compose.yml up -d
```

## Testing and debuging

We can run app.py and make requests in another terminal using curl like this:

```bash
curl -X POST http://127.0.0.1:2525/scrape

curl -X GET "http://localhost:2525/recipes/search?name=<NAME>&batch_size=15&offset=0"

curl -X GET "http://localhost:2525/latest_recipes?batch_size=15&offset=0"

curl -X GET http://localhost:2525/tags  
```