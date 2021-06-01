include(`audioreach/audioreach.m4') dnl
include(`util/pcm.m4') dnl
include(`audioreach/subgraph.m4') dnl
include(`audioreach/container.m4') dnl
include(`audioreach/module_rdsh.m4') dnl
include(`audioreach/module_pcmenc.m4') dnl
include(`audioreach/module_pcmcnv.m4') dnl
include(`audioreach/module_log.m4') dnl
include(`util/mixer.m4') dnl
dnl
# SubGraph  for PCM Capture
# 
#  ______________________________________________
# |               Sub Graph 1                    |
# | [RD_SH]<-- [PCM ENC] <--[PCM CONV] <--[LOG]  |-[DAPM - MIXER]
# |  PCM(n)                                      |
# |______________________________________________|
#
define(`LOG_MODULE_IID', MOD_IID_START) dnl
define(`PCMCNV_MODULE_IID', eval(MOD_IID_START + 1)) dnl
define(`PCMENC_MODULE_IID', eval(MOD_IID_START + 2)) dnl
define(`RDSH_MODULE_IID', eval(MOD_IID_START + 3)) dnl
define(`SG_INDEX', PCM_INDEX) dnl
define(`CONTAINER_INDEX', PCM_INDEX) dnl
dnl
dnl STREAM_CAPTURE_ROUTE(stream-index)
define(`STREAM_CAPTURE_ROUTE',
`'
`SectionGraph."NAME_PREFIX.$1 Graph" {'
`        index STR($1)'
`        lines ['
`                "NAME_PREFIX.logger$1, , MultiMedia$1 Mixer"'
`                "NAME_PREFIX.pcm_converter$1, , NAME_PREFIX.logger$1"'
`                "NAME_PREFIX.pcm_encoder$1, , NAME_PREFIX.pcm_converter$1"'
`                "NAME_PREFIX.rdsh_ep$1, , NAME_PREFIX.pcm_encoder$1"'
`        ]'
`}')
dnl AR_PCM_CAPTURE(index, formats, rate_min, rate_max, ch_min, ch_max)
AR_PCM_CAPTURE(PCM_DAI_ID, PCM_FORMAT, PCM_MIN_RATE, PCM_MAX_RATE, PCM_MIN_CHANNELS, PCM_MAX_CHANNELS)

AR_SUBGRAPH(SG_INDEX, PCM_DAI_ID, SG_IID_START, PCM_PERF_MODE, PCM_DIRECTION, CONT_SENARIO_ID)

AR_CONTAINER(CONTAINER_INDEX, CONT_IID_START,  CONT_CAP, CONT_STACK_SIZE, CONT_POSITION, PCM_DOMAIN_ID)

dnl AR_MODULE_LOG(index, sgidx, container-idx, iid,               maxip-ports, max-op-ports, in-ports, outports, src-mod, src-port, dst-mod, dst-port,
AR_MODULE_LOG(PCM_INDEX,    SG_INDEX, CONTAINER_INDEX, LOG_MODULE_IID,    1, 1, 2, 1, 1, 2, 0x000019af, 1, 0)
AR_MODULE_PCMCNV(PCM_INDEX, SG_INDEX, CONTAINER_INDEX, PCMCNV_MODULE_IID, 1, 1, 2, 1, 1, 2, PCM_INTERLEAVED)
AR_MODULE_PCMENC(PCM_INDEX, SG_INDEX, CONTAINER_INDEX, PCMENC_MODULE_IID, 1, 1, 2, 1, 1, 2, PCM_INTERLEAVED)
AR_MODULE_RDSH(PCM_INDEX,   SG_INDEX, CONTAINER_INDEX, RDSH_MODULE_IID,   1, 0, 2, 0, 1, 0)

dnl STREAM_CAPTURE_MIXER(PCM_INDEX)
STREAM_CAPTURE_ROUTE(PCM_INDEX) 
