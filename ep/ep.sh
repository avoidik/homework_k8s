#!/usr/bin/env bash

git clean -dxf
mvn --batch-mode --quiet clean -U package
