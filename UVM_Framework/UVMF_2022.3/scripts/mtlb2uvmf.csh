#!/bin/csh

# create yaml
# Usage mtlb2yaml.py directory_with_prediction_DPI-C [directory_with_stimulus_DPI-C]
# Both directory names above do not include _build portion of directory name
$UVMF_HOME/scripts/mtlb2yaml.py  $1  $2

# create bench
$UVMF_HOME/scripts/yaml2uvmf.py    output_mtlb.yaml

# cd in generated code to make matlab overlays
cd uvmf_template_output/project_benches/$1/sim
make -f $1_mtlb.mk  mtlb_conversion

cd ../../../..
cp output_mtlb.yaml output_mtlb_$1.yaml
echo ""
echo "IMPORTANT: The names of environment variables needed to reference DPI-C and RTL source are located in uvmf_template_output/project_benches/$1/setup_$1_environment_variables.source"
