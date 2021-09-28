# Copyright (C) 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PACKAGE_NAME := CtsRsBlasTestCases

# Don't include this package in any target.
LOCAL_MODULE_TAGS := optional

# Include both the 32 and 64 bit versions
LOCAL_MULTILIB := both

# When built, explicitly put it in the data partition.
LOCAL_MODULE_PATH := $(TARGET_OUT_DATA_APPS)

LOCAL_STATIC_JAVA_LIBRARIES := ctstestrunner-axt
LOCAL_JAVA_LIBRARIES := android.test.base.stubs
LOCAL_JNI_SHARED_LIBRARIES := libbnnmdata_jni

LOCAL_SRC_FILES := $(call all-java-files-under, src) $(call all-renderscript-files-under, src)

LOCAL_RENDERSCRIPT_FLAGS := -Wno-error=deprecated-declarations

# Tag this module as a cts test artifact
LOCAL_COMPATIBILITY_SUITE := cts vts10 general-tests

LOCAL_SDK_VERSION := current

include $(BUILD_CTS_PACKAGE)
include $(call all-makefiles-under,$(LOCAL_PATH))
