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

Another example is a docker for a Hugo based blog:
```
./dlab build --type lab lab
./dlab shell lab --docker-run-args "-p 1313:1313"
```
