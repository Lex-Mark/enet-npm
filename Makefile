EMCC=`./find-emcc.py`/emcc
#closure generates code which uses eval() - disabled for chrome-ext
OPTIMISE= -O2 --closure 0 -s ASM_JS=1 --llvm-opts 1 --memory-init-file 0
ENET_SOURCE=./src/enet-1.3.5

EXPORTED_FUNCTIONS= -s EXPORTED_FUNCTIONS="[ \
	'_jsapi_init', \
	'_enet_host_service', \
	'_enet_host_destroy', \
	'_enet_host_flush', \
	'_enet_host_bandwidth_throttle', \
	'_enet_host_broadcast', \
	'_enet_host_compress_with_range_coder', \
	'_enet_host_compress', \
	'_jsapi_host_get_receivedAddress', \
	'_jsapi_host_get_socket', \
	'_jsapi_enet_host_create', \
	'_jsapi_enet_host_create_client', \
	'_jsapi_enet_host_connect', \
	'_enet_packet_create', \
	'_enet_packet_destroy', \
	'_jsapi_packet_set_free_callback', \
	'_jsapi_packet_get_data', \
	'_jsapi_packet_get_dataLength', \
	'_jsapi_event_new', \
	'_jsapi_event_free', \
	'_jsapi_event_get_type', \
	'_jsapi_event_get_peer', \
	'_jsapi_event_get_packet', \
	'_jsapi_event_get_data', \
	'_jsapi_event_get_channelID', \
	'_jsapi_address_get_host', \
	'_jsapi_address_get_port', \
	'_enet_peer_send', \
	'_enet_peer_reset', \
	'_enet_peer_ping', \
	'_enet_peer_disconnect', \
	'_enet_peer_disconnect_now', \
	'_enet_peer_disconnect_later', \
	'_jsapi_peer_get_address', \
	'_jsapi_peer_get_state', \
	'_jsapi_peer_get_incomingDataTotal', \
	'_jsapi_peer_get_outgoingDataTotal' ]"

module:
	$(EMCC) src/jsapi.c $(ENET_SOURCE)/*.c -I$(ENET_SOURCE)/include \
		--pre-js src/enet_pre.js -o lib/enet_.js $(OPTIMISE) \
		--js-library src/library_node_sockets.js --js-library src/library_inet.js \
		-s TOTAL_MEMORY=1048576  -s TOTAL_STACK=409600 -s ALLOW_MEMORY_GROWTH=0 -s LINKABLE=1 $(EXPORTED_FUNCTIONS) \
		-s RESERVED_FUNCTION_POINTERS=32
	cat src/wrap_header.js lib/enet_.js src/wrap_footer.js src/bindings.js > lib/enet.js
	rm lib/enet_.js
