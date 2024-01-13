# Development tools

## dlab

`dlab` is a little development helper.
For example you can create an ESP32 development container with just:
```
./dlab build --type esp32 esp32
./dlab shell esp32
```
and you are inside the container with ESP32 IDF SDK and what not.
Prerequisites: `python3`, `docker`, `docker-buildx`.
