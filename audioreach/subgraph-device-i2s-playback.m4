include(`audioreach/audioreach.m4') dnl
include(`util/pcm.m4') dnl
include(`audioreach/subgraph.m4') dnl
include(`audioreach/container.m4') dnl
include(`audioreach/module_log.m4') dnl
include(`audioreach/module_i2s.m4') dnl
include(`util/mixer.m4') dnl
dnl
#
# SubGraph for Device Backend
# 
#  ______________________
# |   Sub Graph          |
# | [LOG] -> [DEVICE EP] |
# |______________________|

define(`LOG_MODULE_IID', MOD_IID_START) dnl
define(`CDC_DMA_MODULE_IID', eval(MOD_IID_START + 1)) dnl
define(`SG_INDEX', DEVICE_INDEX) dnl
define(`CONTAINER_INDEX', DEVICE_INDEX) dnl
dnl DEVICE_PLAYBACK_ROUTE(stream-index, dai-id)
define(`DEVICE_PLAYBACK_ROUTE',
`'
`SectionGraph."NAME_PREFIX.$1 $2 Graph" {'
`        index STR($1)'
`        lines ['
`                "NAME_PREFIX.logger$1, , $2 Audio Mixer"'
`                "NAME_PREFIX.i2s_rx$1, , NAME_PREFIX.logger$1"'
`                "$2, , NAME_PREFIX.i2s_rx$1"'
`        ]'
`}')


AR_SUBGRAPH(DEVICE_INDEX, DEVICE_DAI_ID, SG_IID_START, DEVICE_PERF_MODE, DEVICE_DIRECTION, CONT_SENARIO_ID)
AR_CONTAINER(DEVICE_INDEX, CONT_IID_START, CONT_CAP, CONT_STACK_SIZE, CONT_POSITION, DEVICE_DOMAIN_ID)
AR_MODULE_LOG(DEVICE_INDEX, SG_INDEX, CONTAINER_INDEX, 		LOG_MODULE_IID,     1, 1, 2, 1, 1, 2, 0x000019ab, 1, 0)
AR_MODULE_I2S_RX(DEVICE_INDEX, SG_INDEX, CONTAINER_INDEX, CDC_DMA_MODULE_IID, 1, 0, 2, 0, 1, 0, DEVICE_INTF_TYPE, DEVICE_INTF_INDEX, DEVICE_DATA_FORMAT) 
DEVICE_PLAYBACK_ROUTE(DEVICE_INDEX, `DEVICE_NAME') 

