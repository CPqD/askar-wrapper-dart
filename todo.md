- [x] askar_version: () => string;

- [x] askar_get_current_error: (args_0: Buffer) => number;

- [x] askar_buffer_free: (args_0: Buffer) => unknown;

- [x] askar_clear_custom_logger: () => unknown;

- [x] askar_set_custom_logger: (args_0: number, args_1: Buffer, args_2: number, args_3: number, args_4: number) => number;

- [x] askar_set_default_logger: () => number;

- [x] askar_set_max_log_level: (args_0: number) => number;

- [x] askar_entry_list_count: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_entry_list_free: (args_0: Buffer) => unknown;

- [x] askar_entry_list_get_category: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_entry_list_get_name: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_entry_list_get_tags: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_entry_list_get_value: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_string_list_count: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_string_list_free: (args_0: Buffer) => unknown;

- [x] askar_string_list_get_item: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_key_aead_decrypt: (args_0: Buffer, args_1: Buffer, args_2: Buffer, args_3: Buffer, args_4: Buffer, args_5: Buffer) => number;

- [x] askar_key_aead_encrypt: (args_0: Buffer, args_1: Buffer, args_2: Buffer, args_3: Buffer, args_4: Buffer) => number;

- [x] askar_key_aead_get_padding: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_key_aead_get_params: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_aead_random_nonce: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_convert: (args_0: Buffer, args_1: string, args_2: Buffer) => number;

- [x] askar_key_crypto_box: (args_0: Buffer, args_1: Buffer, args_2: Buffer, args_3: Buffer, args_4: Buffer) => number;

- [x] askar_key_crypto_box_open: (args_0: Buffer, args_1: Buffer, args_2: Buffer, args_3: Buffer, args_4: Buffer) => number;

- [x] askar_key_crypto_box_random_nonce: (args_0: Buffer) => number;

- [x] askar_key_crypto_box_seal: (args_0: Buffer, args_1: Buffer, args_2: Buffer) => number;

- [x] askar_key_crypto_box_seal_open: (args_0: Buffer, args_1: Buffer, args_2: Buffer) => number;

- [x] askar_key_derive_ecdh_1pu: (args_0: string, args_1: Buffer, args_2: Buffer, args_3: Buffer, args_4: Buffer, args_5: Buffer, args_6: Buffer, args_7: Buffer, args_8: number, args_9: Buffer) => number;

- [x] askar_key_derive_ecdh_es: (args_0: string, args_1: Buffer, args_2: Buffer, args_3: Buffer, args_4: Buffer, args_5: Buffer, args_6: number, args_7: Buffer) => number;

- [x] askar_key_entry_list_count: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_entry_list_free: (args_0: Buffer) => unknown;

- [x] askar_key_entry_list_get_algorithm: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_key_entry_list_get_metadata: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_key_entry_list_get_name: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_key_entry_list_get_tags: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_key_entry_list_load_local: (args_0: Buffer, args_1: number, args_2: Buffer) => number;

- [x] askar_key_free: (args_0: Buffer) => unknown;

- [x] askar_key_from_jwk: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_from_key_exchange: (args_0: string, args_1: Buffer, args_2: Buffer, args_3: Buffer) => number;

- [x] askar_key_from_public_bytes: (args_0: string, args_1: Buffer, args_2: Buffer) => number;

- [x] askar_key_from_secret_bytes: (args_0: string, args_1: Buffer, args_2: Buffer) => number;

- [x] askar_key_from_seed: (args_0: string, args_1: Buffer, args_2: string, args_3: Buffer) => number;

- [x] askar_key_generate: (args_0: string, args_1: string, args_2: number, args_3: Buffer) => number;

- [x] askar_key_get_algorithm: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_get_ephemeral: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_get_jwk_public: (args_0: Buffer, args_1: string, args_2: Buffer) => number;

- [x] askar_key_get_jwk_secret: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_get_jwk_thumbprint: (args_0: Buffer, args_1: string, args_2: Buffer) => number;

- [x] askar_key_get_public_bytes: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_get_secret_bytes: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_key_sign_message: (args_0: Buffer, args_1: Buffer, args_2: string, args_3: Buffer) => number;

- [x] askar_key_unwrap_key: (args_0: Buffer, args_1: string, args_2: Buffer, args_3: Buffer, args_4: Buffer, args_5: Buffer) => number;

- [x] askar_key_verify_signature: (args_0: Buffer, args_1: Buffer, args_2: Buffer, args_3: string, args_4: Buffer) => number;

- [x] askar_key_wrap_key: (args_0: Buffer, args_1: Buffer, args_2: Buffer, args_3: Buffer) => number;

- [x] askar_key_get_supported_backends: (args_0: Buffer) => number;

- [x] askar_scan_free: (args_0: number) => number;

- [x] askar_scan_next: (args_0: number, args_1: Buffer, args_2: number) => number;

- [x] askar_scan_start: (args_0: number, args_1: string, args_2: string, args_3: string, args_4: number, args_5: number, args_6: Buffer, args_7: number) => number;

- [x] askar_session_close: (args_0: number, args_1: number, args_2: Buffer, args_3: number) => number;

- [x] askar_session_count: (args_0: number, args_1: string, args_2: string, args_3: Buffer, args_4: number) => number;

- [x] askar_session_fetch: (args_0: number, args_1: string, args_2: string, args_3: number, args_4: Buffer, args_5: number) => number;

- [x] askar_session_fetch_all: (args_0: number, args_1: string, args_2: string, args_3: number, args_4: number, args_5: Buffer, args_6: number) => number;

- [x] askar_session_fetch_all_keys: (args_0: number, args_1: string, args_2: string, args_3: string, args_4: number, args_5: number, args_6: Buffer, args_7: number) => number;

- [x] askar_session_fetch_key: (args_0: number, args_1: string, args_2: number, args_3: Buffer, args_4: number) => number;

- [x] askar_session_insert_key: (args_0: number, args_1: Buffer, args_2: string, args_3: string, args_4: string, args_5: number, args_6: Buffer, args_7: number) => number;

- [x] askar_session_remove_all: (args_0: number, args_1: string, args_2: string, args_3: Buffer, args_4: number) => number;

- [x] askar_session_remove_key: (args_0: number, args_1: string, args_2: Buffer, args_3: number) => number;

- [x] askar_session_start: (args_0: number, args_1: string, args_2: number, args_3: Buffer, args_4: number) => number;

- [x] askar_session_update: (args_0: number, args_1: number, args_2: string, args_3: string, args_4: Buffer, args_5: string, args_6: number, args_7: Buffer, args_8: number) => number;

- [x] askar_session_update_key: (args_0: number, args_1: string, args_2: string, args_3: string, args_4: number, args_5: Buffer, args_6: number) => number;

- [x] askar_store_close: (args_0: number, args_1: Buffer, args_2: number) => number;

- [x] askar_store_copy: (args_0: number, args_1: string, args_2: string, args_3: string, args_4: number, args_5: Buffer, args_6: number) => number;

- [x] askar_store_create_profile: (args_0: number, args_1: string, args_2: Buffer, args_3: number) => number;

- [x] askar_store_generate_raw_key: (args_0: Buffer, args_1: Buffer) => number;

- [x] askar_store_get_profile_name: (args_0: number, args_1: Buffer, args_2: number) => number;

- [x] askar_store_get_default_profile: (args_0: number, args_1: Buffer, args_2: number) => number;

- [x] askar_store_list_profiles: (args_0: number, args_1: Buffer, args_2: number) => number;

- [x] askar_store_open: (args_0: string, args_1: string, args_2: string, args_3: string, args_4: Buffer, args_5: number) => number;

- [x] askar_store_provision: (args_0: string, args_1: string, args_2: string, args_3: string, args_4: number, args_5: Buffer, args_6: number) => number;

- [x] askar_store_rekey: (args_0: number, args_1: string, args_2: string, args_3: Buffer, args_4: number) => number;

- [x] askar_store_remove: (args_0: string, args_1: Buffer, args_2: number) => number;

- [x] askar_store_remove_profile: (args_0: number, args_1: string, args_2: Buffer, args_3: number) => number;

- [x] askar_store_set_default_profile: (args_0: number, args_1: string, args_2: Buffer, args_3: number) => number;

- [x] askar_migrate_indy_sdk: (args_0: string, args_1: string, args_2: string, args_3: string, args_4: Buffer, args_5: number) => number;
