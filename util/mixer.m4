include(`audioreach/audioreach.m4') dnl
dnl stream_device_list: list the devices or streams from argument list
define(`stream_device_list',
`ifelse(`$#', `1', ,
`stream_device_list(shift($@))
		$2')') dnl
dnl 
dnl STREAM_DEVICE_CAPTURE_MIXER(stream-index)
define(`STREAM_DEVICE_CAPTURE_MIXER',
`'
`SectionWidget."MultiMedia$1 Mixer" {'
`    	reg "-1"'
`        index STR($1)'
`        type "mixer"'
`'
`        mixer ['
`		stream_device_list($@)'
`        ]'
`'
`	data ['
`                "stream.sub_graph$1_data"'
`	]'
`}')
dnl
dnl STREAM_DEVICE_PLAYBACK_MIXER(dev-index, device-mixer, strem1, stream2... streamN)
define(`STREAM_DEVICE_PLAYBACK_MIXER',
`'
`SectionWidget."$2 Audio Mixer" {'
`    	reg "-1"'
`        index STR($1)'
`        type "mixer"'
`'
`        mixer ['
`		stream_device_list(shift($@))'
`        ]'
`'
`	data ['
`                "device.sub_graph$1_data"'
`	]'
`}')
dnl
dnl DEVICE_CAPTURE_MIXER(index, name)
define(`DEVICE_CAPTURE_MIXER',
`'
`SectionControlMixer."$2" {'
`	reg "-1"'
`	index STR($1)'
`	max "1"'
`	invert "false"'
`'
`	channel."fl" {'
`                reg "-1"'
`    		 max "1"'
`        }'
`'
`	ops."ctl" {'
`		get "SND_SOC_AR_TPLG_FE_BE_GRAPH_CTL_MIX"'
`		put "SND_SOC_AR_TPLG_FE_BE_GRAPH_CTL_MIX"'
`		info "1"'
`	}'
`'
`	data ['
`                "NAME_PREFIX.sub_graph$1_data"'
`	]'
`}')
dnl
dnl STREAM_PLAYBACK_MIXER(stream-index)
define(`STREAM_PLAYBACK_MIXER',
`'
`SectionControlMixer."PCM$1" {'
`	reg "-1"'
`	index STR($1)'
`	max "1"'
`	invert "false"'
`'
`	channel."fl" {'
`                reg "-1"'
`    		max "1"'
`        }'
`'
`	ops."ctl" {'
`		get "SND_SOC_AR_TPLG_FE_BE_GRAPH_CTL_MIX"'
`		put "SND_SOC_AR_TPLG_FE_BE_GRAPH_CTL_MIX"'
`		info "1"'
`	}'
`'
`	data ['
`                "NAME_PREFIX.sub_graph$1_data"'
`	]'
`}')
