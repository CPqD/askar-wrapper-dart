#include <stdio.h>
#include <stdint.h>
#include <unordered_map>

typedef int32_t ErrorCode;
typedef int64_t CallbackId;
typedef int64_t StoreHandle;

struct CallbackParams {
    ErrorCode err;
    StoreHandle handle;
    bool finished;
};

std::unordered_map<CallbackId, CallbackParams> g_callback_params_map;

extern "C" CallbackId next_cb_id() {
    static CallbackId current_id = 0;
    return ++current_id;
}

extern "C" CallbackParams get_cb_params(CallbackId cb_id) {
    return g_callback_params_map[cb_id];
}

extern "C" void cb_with_handle(CallbackId cb_id, ErrorCode err, StoreHandle handle) {
    CallbackParams params = {err, handle, true};
    g_callback_params_map[cb_id] = params;
}

extern "C" void cb_without_handle(CallbackId cb_id, ErrorCode err) {
    CallbackParams params = {err, -1, true};
    g_callback_params_map[cb_id] = params;
}
