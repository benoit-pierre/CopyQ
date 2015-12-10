#! /bin/bash

set -ex

cd "$(dirname "$0")"
. ./PKGBUILD
pkgver="$(git describe --tags | sed -n '/^v\([0-9.]\+\)-\([0-9]\+\)-\([0-9a-z]\+\)$/{s//\1.\2.\3/;s/-/./g;p;Q0};Q1')"
src="src/$_realname-$pkgver"
rm -rf src pkg
mkdir -p "$src"
cp -l "$pkgbase.install" src/
sed "s/^pkgver=.*\$/pkgver=$pkgver/" PKGBUILD >PKGBUILD.tmp
(cd "$OLDPWD" && git ls-files -z | xargs -0 cp -a --no-dereference --parents --target-directory="$OLDPWD/$src")
makepkg --{sync,rm}deps --clean --force --noextract -p PKGBUILD.tmp "$@"
rm -f PKGBUILD.tmp
