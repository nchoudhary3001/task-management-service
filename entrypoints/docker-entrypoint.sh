#!/bin/sh

set -e

mvn package
mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)
chown -R rails:rails target/
