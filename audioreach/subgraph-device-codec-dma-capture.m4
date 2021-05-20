include(`audioreach/audioreach.m4') dnl
include(`util/pcm.m4') dnl
include(`audioreach/subgraph.m4') dnl
include(`audioreach/container.m4') dnl
include(`audioreach/module_log.m4') dnl
include(`audioreach/module_pcmenc.m4') dnl
include(`audioreach/module_pcmcnv.m4') dnl
include(`audioreach/module_codec_dma.m4') dnl
include(`util/mixer.m4') dnl
dnl
#
# SubGraph for Device Backend
# 
#             ________________________________________________
#             |   Sub Graph                                    |
# [KControl]->| [DEVICE-TX] <- [PCM CNV] <- [PCM-ENC] <- [DEVICE EP] |
#  Switch     |________________________________________________|
undefine(`CDC_DMA_MODULE_IID') dnl
undefine(`PCMENC_MODULE_IID') dnl
undefine(`PCMCNV_MODULE_IID') dnl
undefine(`LOG_MODULE_IID') dnl
undefine(`SG_INDEX') dnl
undefine(`CONTAINER_INDEX') dnl
undefine(`NUM_CONTAINERS') dnl
undefine(`NUM_MODULES') dnl
define(`CDC_DMA_MODULE_IID', MOD_IID_START) dnl
define(`PCMENC_MODULE_IID', eval(MOD_IID_START + 1)) dnl
define(`PCMCNV_MODULE_IID', eval(MOD_IID_START + 2)) dnl
define(`LOG_MODULE_IID', eval(MOD_IID_START + 3)) dnl
define(`SG_INDEX', DEVICE_INDEX) dnl
define(`CONTAINER_INDEX', DEVICE_INDEX) dnl
define(`NUM_CONTAINERS', 1) dnl
define(`NUM_MODULES', 4) dnl
dnl
dnl DEVICE_CAPTURE_ROUTE(stream-index, dai-id)
define(`DEVICE_CAPTURE_ROUTE',
`'
`SectionGraph."NAME_PREFIX.$1 $2 Graph" {'
`        index STR($1)'
`        lines ['
`		"NAME_PREFIX.codec_dma_tx$1, , $2"' 
`                "NAME_PREFIX.pcm_encoder$1, , NAME_PREFIX.codec_dma_tx$1"'
`                "NAME_PREFIX.pcm_converter$1, , NAME_PREFIX.pcm_encoder$1"'
`                "NAME_PREFIX.logger$1, , NAME_PREFIX.pcm_converter$1"'
`        ]'
`}')

AR_SUBGRAPH(DEVICE_INDEX, DEVICE_DAI_ID, SG_IID_START, DEVICE_PERF_MODE, DEVICE_DIRECTION, CONT_SENARIO_ID, NUM_CONTAINERS)

AR_CONTAINER(DEVICE_INDEX, CONT_IID_START, CONT_CAP, CONT_STACK_SIZE, CONT_POSITION, DEVICE_DOMAIN_ID, NUM_MODULES)

AR_MODULE_CODEC_DMA_TX(DEVICE_INDEX, SG_INDEX, CONTAINER_INDEX, CDC_DMA_MODULE_IID, 0, 1, 0, 2, 0                 , 0, PCMENC_MODULE_IID, 2, DEVICE_INTF_TYPE, DEVICE_INTF_INDEX, DEVICE_DATA_FORMAT) 
AR_MODULE_PCMENC(DEVICE_INDEX, SG_INDEX,       CONTAINER_INDEX, PCMENC_MODULE_IID,  1, 1, 2, 1, CDC_DMA_MODULE_IID, 1, PCMCNV_MODULE_IID  , 2, PCM_INTERLEAVED)
AR_MODULE_PCMCNV(DEVICE_INDEX, SG_INDEX,       CONTAINER_INDEX, PCMCNV_MODULE_IID,  1, 1, 2, 1, PCMENC_MODULE_IID , 1, LOG_MODULE_IID,      2, PCM_DEINTERLEAVED_UNPACKED)
AR_MODULE_LOG(   DEVICE_INDEX, SG_INDEX,       CONTAINER_INDEX, LOG_MODULE_IID,     1, 1, 2, 1, PCMCNV_MODULE_IID , 1, 0,                   2, 0x000019ab, 1, 0)
dnl kcontrol switch
DEVICE_CAPTURE_MIXER(DEVICE_INDEX, `DEVICE_NAME')
DEVICE_CAPTURE_ROUTE(DEVICE_INDEX, `DEVICE_NAME') 
