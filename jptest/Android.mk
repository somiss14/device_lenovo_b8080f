LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := jptest.c
LOCAL_MODULE := jptest
LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libdl libcutils liblog
include $(BUILD_EXECUTABLE)
