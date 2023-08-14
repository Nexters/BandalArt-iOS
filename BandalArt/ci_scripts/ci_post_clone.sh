
#!/bin/sh

# swiftlint 다운로드
brew install swiftlint

cd ..

# fetch를 통해 라이브러리 다운로드
.tuist-bin/tuist fetch

# generate를 통해 .xcworkspace 받아오기
.tuist-bin/tuist generate
