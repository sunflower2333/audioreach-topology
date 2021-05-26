include(`util/util.m4') dnl
dnl AR_SUBGRAPH(index, graph-id, sub-graph-id, perf-mode, dir, sid)
define(`AR_SUBGRAPH',
`'
`SectionVendorTuples."NAME_PREFIX.sub_graph$1_tuples" {'
`        tokens "audio_reach_tokens"'
`        tuples."word.u32_data" {'
`                AUDIOREACH_TKN_U32_SUB_GRAPH_ID STR($3)'
`                AUDIOREACH_TKN_U32_GRAPH_ID STR($2)'
`                AUDIOREACH_TKN_U32_PERF_MODE STR($4)'
`                AUDIOREACH_TKN_U32_SG_DIRECTION STR($5)'
`                AUDIOREACH_TKN_U32_SCENARIO_ID STR($6)'
`        }'
`}'
`'
`SectionData."NAME_PREFIX.sub_graph$1_data" {'
`        tuples "NAME_PREFIX.sub_graph$1_tuples"'
`}') dnl
