#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('chip')

##   addSubEnv(<sub_env_handle_name>,<sub_env_package_name>,<number_of_agents_in_the_sub_env>)
env.addSubEnv('block_a_env', 'block_a', 4)
env.addSubEnv('block_b_env', 'block_b', 4)

env.create() 

