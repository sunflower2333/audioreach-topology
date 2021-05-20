include(`audioreach/audioreach.m4') dnl
include(`util/pcm.m4') dnl
include(`audioreach/subgraph.m4') dnl
include(`audioreach/container.m4') dnl
include(`audioreach/module_wrsh.m4') dnl
include(`audioreach/module_pcmdec.m4') dnl
include(`audioreach/module_pcmcnv.m4') dnl
include(`audioreach/module_log.m4') dnl
include(`util/mixer.m4') dnl
dnl
# SubGraph  for PCM Playback
# 
#  ______________________________________________
# |               Sub Graph 1                    |
# | [WR_SH] -> [PCM DEC] -> [PCM CONV] -> [LOG]  |---KCONTROL--
# |______________________________________________|
#
define(`WRSH_MODULE_IID', MOD_IID_START) dnl
define(`PCMDEC_MODULE_IID', eval(MOD_IID_START + 1)) dnl
define(`PCMCNV_MODULE_IID', eval(MOD_IID_START + 2)) dnl
define(`LOG_MODULE_IID', eval(MOD_IID_START + 3)) dnl
define(`NUM_CONTAINERS', 1) dnl
define(`NUM_MODULES', 4) dnl
dnl
dnl STREAM_PLAYBACK_ROUTE(stream-index)
define(`STREAM_PLAYBACK_ROUTE',
`'
`SectionGraph."NAME_PREFIX.$1 Graph" {'
`        index STR($1)'
`        lines ['
`                "NAME_PREFIX.pcm_decoder$1, , NAME_PREFIX.wrsh_ep$1"'
`                "NAME_PREFIX.pcm_converter$1, , NAME_PREFIX.pcm_decoder$1"'
`                "NAME_PREFIX.logger$1, , NAME_PREFIX.pcm_converter$1"'
`        ]'
`}')

dnl
AR_PCM_PLAYBACK(PCM_DAI_ID, PCM_FORMAT, PCM_MIN_RATE, PCM_MAX_RATE, PCM_MIN_CHANNELS, PCM_MAX_CHANNELS)

AR_SUBGRAPH(PCM_INDEX, PCM_DAI_ID, SG_IID_START, PCM_PERF_MODE, PCM_DIRECTION, CONT_SENARIO_ID, NUM_CONTAINERS)

AR_CONTAINER(PCM_INDEX, CONT_IID_START,  APM_CONTAINER_CAP_ID_CD, 8192, APM_CONT_GRAPH_POS_STREAM, APM_PROC_DOMAIN_ID_ADSP, NUM_MODULES)
AR_MODULE_WRSH(PCM_INDEX, PCM_INDEX, PCM_INDEX, WRSH_MODULE_IID,   0, 1, 0, 0, 0,                 0, PCMDEC_MODULE_IID, 2)
AR_MODULE_PCMDEC(PCM_INDEX, 1, 1, PCMDEC_MODULE_IID, 1, 1, 2, 1, WRSH_MODULE_IID,   1, PCMCNV_MODULE_IID, 2, PCM_INTERLEAVED)
AR_MODULE_PCMCNV(PCM_INDEX, 1, 1, PCMCNV_MODULE_IID, 1, 1, 2, 1, PCMDEC_MODULE_IID, 1, LOG_MODULE_IID, 2, PCM_DEINTERLEAVED_UNPACKED)
AR_MODULE_LOG(PCM_INDEX,    1, 1, LOG_MODULE_IID,    1, 1, 2, 1, PCMCNV_MODULE_IID, 1, 0, 	    2, 0x000019af, 1, 0)
STREAM_PLAYBACK_MIXER(PCM_INDEX)
STREAM_PLAYBACK_ROUTE(PCM_INDEX) 
