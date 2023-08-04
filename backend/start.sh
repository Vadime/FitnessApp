# !/bin/sh

# kill process running on port 9000 (for firestore)
lsof -ti tcp:9000 | xargs kill -9
lsof -ti tcp:8080 | xargs kill -9

# declare where to store cache
cacheDir=/Users/vn/.cache/firebase/emulator_cache

# so that i can restore configs from previous run
firebase emulators:start --import $cacheDir --export-on-exit $cacheDir