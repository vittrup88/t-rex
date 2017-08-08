# This script takes care of testing your crate

set -ex

# TODO This is the "test phase", tweak it as you see fit
main() {
    cross build --target $TARGET
    cross build --target $TARGET --release

    if [ ! -z $DISABLE_TESTS ]; then
        return
    fi

    #cross test --target $TARGET
    cross test -p t-rex-core -p t-rex-service -p t-rex-webserver --target $TARGET --release

    cargo test -p t-rex-core -p t-rex-service -p t-rex-webserver --target $TARGET
    # cross ignores DBCONN env variable (https://github.com/japaric/cross/issues/76)
    cargo test -p t-rex-core -p t-rex-service -p t-rex-webserver --target $TARGET -- --ignored

    #cross run --target $TARGET
    cargo run --target $TARGET
    cross run --target $TARGET --release
}

# we don't run the "test phase" when doing deploys
if [ -z $TRAVIS_TAG ]; then
    main
fi
