
# Assumes that the QVIP configurator was already run, but uncomment the following
# to do it
#${QUESTA_MVC_HOME}/bin/qvip_configurator -commands ../../qvip_configurator/block_c_configurator.cmd

# Stop-gap script to generate YAML describing the QVIP configurator output. If the above command
# was run in $CWD then there will be a qvip_agents_dir.  This will create "qvip_agents_subenv_config.yaml"
gen_qvip_yaml.py qvip_agents_dir 

./api_files/mem_if_config.py --yaml
./api_files/pkt_if_config.py --yaml
./api_files/block_c_env_config.py --yaml
./api_files/block_c_bench_config.py --yaml
