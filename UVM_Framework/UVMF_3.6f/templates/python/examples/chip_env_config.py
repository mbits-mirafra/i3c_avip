#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('chip')

env.addParamDef('CHIP_CP_IN_DATA_WIDTH','int','20')
env.addParamDef('CHIP_CP_IN_ADDR_WIDTH','int','10')
env.addParamDef('CHIP_CP_OUT_ADDR_WIDTH','int','25')
env.addParamDef('CHIP_UDP_DATA_WIDTH','int','40')

##   addSubEnv(<sub_env_handle_name>,<sub_env_package_name>,<number_of_agents_in_the_sub_env>)
env.addSubEnv('block_a_env', 'block_a', 4)
env.addSubEnv('block_b_env', 'block_b', 4, {'CP_IN_DATA_WIDTH':'CHIP_CP_IN_DATA_WIDTH',
                                            'CP_IN_ADDR_WIDTH':'CHIP_CP_IN_ADDR_WIDTH',
					    					'CP_OUT_ADDR_WIDTH':'CHIP_CP_OUT_ADDR_WIDTH',
					  					    'UDP_DATA_WIDTH':'CHIP_UDP_DATA_WIDTH'})

env.create() 

