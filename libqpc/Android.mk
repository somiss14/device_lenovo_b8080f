LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := libqpc.c
LOCAL_MODULE := libqpc
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libcrypto
include $(BUILD_SHARED_LIBRARY)
