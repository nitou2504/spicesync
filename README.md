## Usage
### Backend
Start the pre-configured mysql database for the project using docker-compose

```bash
docker-compose -f spicesync_backend/docker-compose.yml up -d
```

## Testing and debuging

We can run app.py and make the requests in another terminal using curl like this:

```bash
curl -X POST http://127.0.0.1:2525/scrape
```