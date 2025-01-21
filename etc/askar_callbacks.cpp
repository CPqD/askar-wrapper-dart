#include <stdio.h>
#include <stdint.h>

typedef int32_t ErrorCode;
typedef int64_t CallbackId;
typedef int64_t StoreHandle;

extern "C" void cb_with_handle(CallbackId cb_id, ErrorCode err, StoreHandle handle) {
    // Handle the callback logic here
    if (err != 0) {
        // Handle error
        printf("Error: %d\n", err);
    } else {
        // Handle success
        printf("Callback ID: %lld, Store Handle: %lld\n", cb_id, handle);
    }
}

extern "C" void cb_without_handle(CallbackId cb_id, ErrorCode err) {
    // Handle the callback logic here
    if (err != 0) {
        // Handle error
        printf("Error: %d\n", err);
    } else {
        // Handle success
        printf("Callback ID: %lld, Success\n", cb_id);
    }
}