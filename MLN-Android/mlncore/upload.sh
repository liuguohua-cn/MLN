#!/usr/bin/env bash
# 基础版本号

function changeSettingBefore {
    sed -i '' "s/\(include.*\)/\/\/\1/g" ../settings.gradle

    sed -i '' "s/\/*\(include.*mlncore\)/\1/g" ../settings.gradle
}

function changeSettingAfter {
    sed -i '' "s/\/*\(include.*\)/\1/g" ../settings.gradle
}

function closeNativeInfo() {
    sed -i '' "s/#*\(.*DJ_API_INFO\)/#\1/g" ./src/main/jni/japi/CMakeLists.txt
    sed -i '' "s/#*\(.*DMEM_INFO\)/#\1/g" ./src/main/jni/japi/CMakeLists.txt
    sed -i '' "s/#*\(.*DSTATISTIC_PERFORMANCE\)/#\1/g" ./src/main/jni/japi/CMakeLists.txt
}

function openNativeInfo() {
    sed -i '' "s/#*\(.*DJ_API_INFO\)/\1/g" ./src/main/jni/japi/CMakeLists.txt
#    sed -i '' "s/#*\(.*DMEM_INFO\)/\1/g" ./src/main/jni/japi/CMakeLists.txt
    sed -i '' "s/#*\(.*DSTATISTIC_PERFORMANCE\)/\1/g" ./src/main/jni/japi/CMakeLists.txt
}

changeSettingBefore
closeNativeInfo

echo '--------------task:bintrayUpload--------------'
./../gradlew :mlncore:publish
ret=$?

changeSettingAfter
openNativeInfo
exit $ret