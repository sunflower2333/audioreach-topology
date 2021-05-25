include(`audioreach/audioreach.m4')
include(`audioreach/stream-subgraph.m4')
include(`audioreach/device-subgraph.m4')
include(`util/route.m4')
include(`util/mixer.m4')
include(`audioreach/tokens.m4')
#
# Stream SubGraph  for PCM Playback
# 
#  ______________________________________________
# |               Sub Graph 1                    |
# | [WR_SH] -> [PCM DEC] -> [PCM CONV] -> [LOG]  |- Kcontrol
# |______________________________________________|
#
dnl Playback PCM0
STREAM_SG_PCM_ADD(audioreach/subgraph-stream-playback.m4, FRONTEND_DAI_MULTIMEDIA1, 1,
	`S16_LE', 48000, 48000, 2, 2,	
	APM_SG_PERF_MODE_LOW_LATENCY, APM_SUB_GRAPH_DIRECTION_RX, APM_SUB_GRAPH_SID_AUDIO_PLAYBACK,
	APM_CONTAINER_CAP_ID_CD, APM_CONT_GRAPH_POS_STREAM, APM_PROC_DOMAIN_ID_ADSP, 8192,
	0x00004001, 0x00004001, 0x00006001)
dnl Playback PCM1
STREAM_SG_PCM_ADD(audioreach/subgraph-stream-playback.m4, FRONTEND_DAI_MULTIMEDIA2, 2,
	`S16_LE', 48000, 48000, 2, 2,	
	APM_SG_PERF_MODE_LOW_LATENCY, APM_SUB_GRAPH_DIRECTION_RX, APM_SUB_GRAPH_SID_AUDIO_PLAYBACK,
	APM_CONTAINER_CAP_ID_CD, APM_CONT_GRAPH_POS_STREAM, APM_PROC_DOMAIN_ID_ADSP, 8192,
	0x00004002, 0x00004002, 0x00006010)
dnl Capture PCM1
STREAM_SG_PCM_ADD(audioreach/subgraph-stream-capture.m4, FRONTEND_DAI_MULTIMEDIA3, 3,
	`S16_LE', 48000, 48000, 2, 2,	
	APM_SG_PERF_MODE_LOW_LATENCY, APM_SUB_GRAPH_DIRECTION_TX,
	APM_SUB_GRAPH_SID_AUDIO_RECORD, APM_CONTAINER_CAP_ID_CD, APM_CONT_GRAPH_POS_GLOBAL_DEV,
	APM_PROC_DOMAIN_ID_ADSP, 8192,
	0x00004003, 0x00004003, 0x00006020)
dnl Capture PCM2
STREAM_SG_PCM_ADD(audioreach/subgraph-stream-capture.m4, FRONTEND_DAI_MULTIMEDIA4, 4,
	`S16_LE', 48000, 48000, 2, 2,	
	APM_SG_PERF_MODE_LOW_LATENCY, APM_SUB_GRAPH_DIRECTION_TX,
	APM_SUB_GRAPH_SID_AUDIO_RECORD, APM_CONTAINER_CAP_ID_CD, APM_CONT_GRAPH_POS_GLOBAL_DEV,
	APM_PROC_DOMAIN_ID_ADSP, 8192,
	0x00004004, 0x00004004, 0x00006030)
#
#
# Device SubGraph  for WSA RX0 Backend
# 
#         ___________________
#        |   Sub Graph 2     |
# Mixer -| [LOG] -> [WSA EP] |
#        |___________________|
#
dnl DEVICE_SG_ADD(stream, stream-dai-id, stream-index, 
dnl 	format, min-rate, max-rate, min-channels, max-channels,
dnl	perf-mode, direction, senario-id, container-cap, container-pos,
dnl	domain, stack-size,
dnl	interface-type, interface-index, data-format,
dnl	sg-iid-start, cont-iid-start, mod-iid-start
dnl WSA Playback
DEVICE_SG_ADD(audioreach/subgraph-device-codec-dma-playback.m4, `WSA_CODEC_DMA_RX_0', WSA_CODEC_DMA_RX_0, 1,
	`S16_LE', 48000, 48000, 2, 2,	
	APM_SG_PERF_MODE_LOW_LATENCY, APM_SUB_GRAPH_DIRECTION_TX, APM_SUB_GRAPH_SID_AUDIO_PLAYBACK,
	APM_CONTAINER_CAP_ID_EP, APM_CONT_GRAPH_POS_STREAM, APM_PROC_DOMAIN_ID_ADSP, 8192,
	LPAIF_INTF_TYPE_WSA, CODEC_INTF_IDX_RX0, DATA_FORMAT_FIXED_POINT,
	0x00004005, 0x00004005, 0x00006050)
dnl
STREAM_DEVICE_PLAYBACK_MIXER(1, ``WSA_CODEC_DMA_RX_0'', ``PCM1'', ``PCM2'')
STREAM_DEVICE_PLAYBACK_ROUTE(1, ``WSA_CODEC_DMA_RX_0 Audio Mixer'', ``PCM1, stream.logger1'', ``PCM2, stream.logger2'')

dnl WCDRX Playback
DEVICE_SG_ADD(audioreach/subgraph-device-codec-dma-playback.m4, `RX_CODEC_DMA_RX_0', RX_CODEC_DMA_RX_0, 2,
	`S16_LE', 48000, 48000, 2, 2,	
	APM_SG_PERF_MODE_LOW_LATENCY, APM_SUB_GRAPH_DIRECTION_TX, APM_SUB_GRAPH_SID_AUDIO_PLAYBACK,
	APM_CONTAINER_CAP_ID_EP, APM_CONT_GRAPH_POS_STREAM, APM_PROC_DOMAIN_ID_ADSP, 8192,
	LPAIF_INTF_TYPE_RXTX, CODEC_INTF_IDX_RX0, DATA_FORMAT_FIXED_POINT,
	0x00004006, 0x00004006, 0x00006060)
dnl
STREAM_DEVICE_PLAYBACK_MIXER(2, ``RX_CODEC_DMA_RX_0'', ``PCM1'', ``PCM2'')
STREAM_DEVICE_PLAYBACK_ROUTE(2, ``RX_CODEC_DMA_RX_0 Audio Mixer'', ``PCM1, stream.logger1'', ``PCM2, stream.logger2'')

dnl VA Capture
DEVICE_SG_ADD(audioreach/subgraph-device-codec-dma-capture.m4, `VA_CODEC_DMA_TX_0', VA_CODEC_DMA_TX_0, 3,
	`S16_LE', 48000, 48000, 2, 2,	
	APM_SG_PERF_MODE_LOW_LATENCY, APM_SUB_GRAPH_DIRECTION_TX, APM_SUB_GRAPH_SID_AUDIO_RECORD,
	APM_CONTAINER_CAP_ID_EP, APM_CONT_GRAPH_POS_GLOBAL_DEV, APM_PROC_DOMAIN_ID_ADSP, 8192,
	LPAIF_INTF_TYPE_VA, CODEC_INTF_IDX_TX0, DATA_FORMAT_FIXED_POINT,
	0x00004007, 0x00004007, 0x00006070)
dnl
dnl WCDTX Capture
DEVICE_SG_ADD(audioreach/subgraph-device-codec-dma-capture.m4, `TX_CODEC_DMA_TX_3', TX_CODEC_DMA_TX_3, 4,
	`S16_LE', 48000, 48000, 2, 2,	
	APM_SG_PERF_MODE_LOW_LATENCY, APM_SUB_GRAPH_DIRECTION_TX, APM_SUB_GRAPH_SID_AUDIO_RECORD,
	APM_CONTAINER_CAP_ID_EP, APM_CONT_GRAPH_POS_GLOBAL_DEV, APM_PROC_DOMAIN_ID_ADSP, 8192,
	LPAIF_INTF_TYPE_RXTX, CODEC_INTF_IDX_TX3, DATA_FORMAT_FIXED_POINT,
	0x00004008, 0x00004008, 0x00006080)

dnl STREAM_DEVICE_CAPTURE_MIXER(stream-index, kcontro1, kcontrol2... kcontrolN)
STREAM_DEVICE_CAPTURE_MIXER(3, ``VA_CODEC_DMA_TX_0'',``TX_CODEC_DMA_TX_3'' )
STREAM_DEVICE_CAPTURE_MIXER(4, ``VA_CODEC_DMA_TX_0'',``TX_CODEC_DMA_TX_3'' )
dnl STREAM_DEVICE_CAPTURE_ROUTE(stream-index, mixer-name, route1, route2.. routeN)
STREAM_DEVICE_CAPTURE_ROUTE(3, ``MultiMedia3 Mixer'', ``VA_CODEC_DMA_TX_0, device.logger3'', ``TX_CODEC_DMA_TX_3, device.logger4'')
STREAM_DEVICE_CAPTURE_ROUTE(4, ``MultiMedia4 Mixer'', ``VA_CODEC_DMA_TX_0, device.logger3'', ``TX_CODEC_DMA_TX_3, device.logger4'')
