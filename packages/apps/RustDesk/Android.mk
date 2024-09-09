LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
#TeamViewerHost为应用名称
LOCAL_MODULE := RustDesk
# TeamViewerHost.apk为安装包文件名，这里也可以用$(LOCAL_MODULE).apk代替
LOCAL_SRC_FILES := RustDesk.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_BUILT_MODULE_STEM := package.apk
#LOCAL_CERTIFICATE 参数说明
#1.testkey：普通APK，默认情况下使用。
#2.platform：该APK完成一些系统的核心功能。经过对系统中存在的文件夹的访问测试，这种方式编译出来的APK所在进程的UID为system。
#3.shared：该APK需要和home/contacts进程共享数据。
#4.media：该APK是media/download系统中的一环。
#5.PRESIGNED：使用apk原来的签名（这里应为是第三方应用，所以直接使用原签名）。
LOCAL_CERTIFICATE := platform
LOCAL_PROGUARD_ENABLED := disabled
LOCAL_DEX_PREOPT := false
LOCAL_PRIVILEGED_MODULE := true
include $(BUILD_PREBUILT)