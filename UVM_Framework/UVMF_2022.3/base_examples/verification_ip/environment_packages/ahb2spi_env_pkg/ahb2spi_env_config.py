#! /usr/bin/env python

import uvmf_gen
env = uvmf_gen.EnvironmentClass('ahb2spi')


##   addSubEnv(<sub_env_handle_name>,<sub_env_package_name>,<number_of_agents_in_the_sub_env>)
env.addSubEnv('ahb2wb_env', 'ahb2wb', 2)
env.addSubEnv('wb2spi_env', 'wb2spi', 2)

env.create() 
