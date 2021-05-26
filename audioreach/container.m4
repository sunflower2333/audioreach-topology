include(`util/util.m4') dnl
dnl AR_CONTAINER(index, container-id, cap-id, stack-size, graph-pos, domain)
define(`AR_CONTAINER',
`'
`SectionVendorTuples."NAME_PREFIX.container$1_tuples" {'
`        tokens "audio_reach_tokens"'
`        tuples."word.u32_data" {'
`                AUDIOREACH_TKN_U32_CONAINER_ID STR($2)'
`                AUDIOREACH_TKN_U32_CAPABILITY_ID STR($3)'
`                AUDIOREACH_TKN_U32_STACK_SIZE STR($4)'
`                AUDIOREACH_TKN_U32_GRAPH_POS STR($5)'
`                AUDIOREACH_TKN_U32_PROC_DOMAIN STR($6)'
`        }'
`}'
`'
`SectionData."NAME_PREFIX.container$1_data" {'
`        tuples "NAME_PREFIX.container$1_tuples"'
`}') dnl
