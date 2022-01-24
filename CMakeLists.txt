# SPDX-License-Identifier: BSD-3-Clause
# With inspiration from SoF
cmake_minimum_required(VERSION 3.10)
# Array of "input-file-name;output-file-name;"
set(TPLGS
	"Qualcomm-RB5-WSA8815-Speakers-DMIC0\;Qualcomm-RB5-WSA8815-Speakers-DMIC0\;"
	"SM8250-MTP-WCD9380-WSA8810-VA-DMIC\;SM8250-MTP-WCD9380-WSA8810-VA-DMIC\;"
	"Google-SC7180-WSA-Speakers-SEC-I2S-VA-DMIC-WCD-TX3\;Google-SC7180-WSA-Speakers-SEC-I2S-VA-DMIC-WCD-TX3\;"
)

add_custom_target(topologies ALL)

foreach(tplg ${TPLGS})
	list(GET tplg 0 input)
	list(GET tplg 1 output)

	add_custom_command(
		OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${output}.conf
		COMMAND m4 -I ${CMAKE_CURRENT_BINARY_DIR}
			-I ${CMAKE_CURRENT_SOURCE_DIR}
			 ${CMAKE_CURRENT_SOURCE_DIR}/${input}.m4
			 > ${CMAKE_CURRENT_BINARY_DIR}/${output}.conf
		DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${input}.m4
		VERBATIM
		USES_TERMINAL
	)
	add_custom_command(
		OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${output}.tplg
		COMMAND "alsatplg \$\${VERBOSE:+-v 1} -c ${output}.conf -o ${output}.tplg"
		DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${output}.conf
		VERBATIM
		USES_TERMINAL
	)

	add_custom_target(topology_${output} DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${output}.tplg)
        add_dependencies(topologies topology_${output})
endforeach()
