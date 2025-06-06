# Copyright, Linaro Ltd, 2023
# SPDX-License-Identifier: BSD-3-Clause
include(`util/util.m4') dnl
dnl AR_MODULE_LOG(index, sgidx, container-idx, iid,  maxip-ports, max-op-ports, src-port, dst-port,
dnl log-code, log-tap-point, log-mode, dst-iid)
define(`AR_MODULE_LOG',
`'
`SectionVendorTuples."NAME_PREFIX.logger$1_tuples" {'
`        tokens "audioreach_tokens"'
`'
`        tuples."word.u32_data" {'
`                AR_TKN_U32_MODULE_INSTANCE_ID STR($4)'
`                AR_TKN_U32_MODULE_ID STR(MODULE_ID_LOG)'
`                AR_TKN_U32_MODULE_MAX_IP_PORTS STR($5)'
`                AR_TKN_U32_MODULE_MAX_OP_PORTS STR($6)'
`                AR_TKN_U32_MODULE_SRC_OP_PORT_ID STR($7)'
`                AR_TKN_U32_MODULE_DST_IN_PORT_ID STR($8)'
`                AR_TKN_U32_MODULE_SRC_INSTANCE_ID STR($4)'
`                AR_TKN_U32_MODULE_DST_INSTANCE_ID STR($12)'
`                AR_TKN_U32_MODULE_LOG_CODE STR($9)'
`                AR_TKN_U32_MODULE_LOG_TAP_POINT_ID STR($10)'
`                AR_TKN_U32_MODULE_LOG_MODE STR($11)'
`        }'
`}'
`'
`SectionData."NAME_PREFIX.logger$1_data" {'
`        tuples "NAME_PREFIX.logger$1_tuples"'
`}'
`'
`SectionWidget."NAME_PREFIX.logger$1" {'
`        index STR($1)'
`        type "buffer"'
`        no_pm "true"'
`        subseq "10"'
`        data ['
`                "NAME_PREFIX.sub_graph$2_data"'
`                "NAME_PREFIX.container$3_data"'
`                "NAME_PREFIX.logger$1_data"'
`        ]'
`}') dnl
