#! /usr/bin/env python

import re
import sys
import os

sys.path.insert(0,os.path.dirname(os.path.dirname(os.path.realpath(__file__)))+"/templates/python/python2")

try:
    component_name = sys.argv[1]
except:
    print("Error: Must provide a prediction model build")
    quit(1)
try:
    stim_name = sys.argv[2]
except IndexError:
    print("Note: No stimulus build. Continuing with only prediction")
    stim_name = None

#TODO need to make this list more complete
sizes = {'bit': 1,
         'bit signed': 1,
         'byte': 8,
         'byte unsigned': 8,
         'shortint': 16,
         'shortint unsigned': 16, 
         'int': 32,
         'int unsigned': 32,
         'longint': 64,  
         'longint unsigned': 64
         }

def calc_port_size(funcType, packedList):
    try:
        res = sizes[funcType.strip()]
    except KeyError:
        print("Error: base type " + funcType + " not known")
        quit(1)
    
    #Comment these out since we are not including unpacked sizes
    # for entry in unpackedList:
    #     res = res * sizeOfEntry(entry)
    for entry in packedList:
        res = res * sizeOfEntry(entry)
    return res
    

def sizeOfEntry(entry):
    entry = entry[1:-1]
    entry = entry.split(':')
    if (len(entry) > 1 ):
        res = abs(int(entry[0])-int(entry[1])) + 1  
    else:
        res = int(entry[0])
    return res

def getCFiles(directory):
    dir_list = os.listdir(directory)
    res = []
    for file in dir_list:
        if file.endswith('.c'):
            res.append(file)
    
    return res

def parseLine(s):
    res={}
    sr = re.match(r"\s*(input|inout)\s+", s)
    if sr != None:
        res['direction'] = sr.group(1)
    else:
        # default direction is input
        res['direction'] = 'input'
    if (len(s.split())==2):
        s = 'input ' + s
    s = s.split(' ', 1)[1]
    res['unpacked-size']=[]
    res['packed-size']=[]
    while (s[-1]==']'):
        # sr = re.match(r".*(\[[0-9]+\])$", s)
        sr = re.match(r".*(\[[0-9]+(:[0-9]+)?\])$", s)
        if sr != None:
            res['unpacked-size'].insert(0, sr.group(1))
            s=s[0:len(s)-len(sr.group(1))]
    #check if we have an unpacked size. if we dont, assign size to 1
    # if len(res['unpacked-size'])==0:
    #     res['unpacked-size'].insert(0, '[1]')
    sp = s.split()
    res['name'] = sp[-1]
    s = ' '.join(sp[0:-1])
    while (s[-1]==']'):
        sr = re.match(r".*(\[[0-9]+(:[0-9]+)?\])$", s)
        if sr != None:
            res['packed-size'].insert(0, sr.group(1))
            s=s[0:len(s)-len(sr.group(1))]
    res['type'] = s.strip()
    return res

def parseFunction(funcitonDef):
    res = {}
    o = re.match(r"import \"DPI-C\" function (\w+) (\w+)\(([\S\s]*?)\)", funcitonDef)
    res['returnType'] = o.group(1)
    res['name'] = o.group(2)
    res['parms']=[]
    for parm in o.group(3).split(','):
        res['parms'].append(parseLine(parm))
    return res

def parseDpiParms(parms):
    res = {}
    res['parmName'] = parms.split()[-1]
    res['type'] = parms[0:len(parms)-len(res['parmName'])]
    return res


def parseDpiFunctions(functionDef):
    res = {}
    #DPI_LINK_DECL DPI_DLL_EXPORT <type> [*] <function name> [Parms_type  [*] variable ...]
    o = re.match(r"DPI_LINK_DECL DPI_DLL_EXPORT\s(\w+[\*\s])\s*(\w+)\((.*)\);", functionDef )
    if(o != None):
        res['cReturnType'] = o.group(1)
        res['cFunctionName'] = o.group(2)
        res['cParms'] = []
        for parm in o.group(3).split(','):
            res['cParms'].append(parseDpiParms(parm.strip()))
        return res


#PREDICTION
# bring in files
# component_name = "pathfinder_rxss_shell"
# component_name = sys.argv[1];
c_header = str(component_name + "_build/" + component_name + "_dpi.h")
sv_pkg = str(component_name + "_build/" + component_name + "_dpi_pkg.sv")

pred_c_files = getCFiles('./' + component_name + '_build//')


#main dictionary
dpiFunctions = {}
dpiFunctions['cFunctions'] = []
dpiFunctions['svFunctions'] = []
#output YAML file
# o_file=open("output_mtlb.yaml", "w")



#c header
with open(c_header, 'r') as i:
    lines = i.readlines()
    # print(text)
    for line in lines:
        if(line.startswith("DPI_LINK_DECL")):
            dpiFunctions['cFunctions'].append(parseDpiFunctions(line))
            # print(dpiFunctions)

#sv package
with open(sv_pkg, 'r') as i:
    lines = i.readlines()
    #need to build function blocks like above
    functions = []
    
    for line in lines:
        if(line.startswith("import")):
            functions.append(line)
        elif(line.startswith("input") or line.startswith("inout")):
            functions[len(functions)-1] = functions[len(functions)-1] + line

for fcn in functions:
    dpiFunctions['svFunctions'].append(parseFunction(fcn))

#STIMGEN
# stim_name = 'pathfinder_rxss_siggen'

#Bring in files
if(stim_name != None):
    stim_c_header = str(stim_name + "_build/" + stim_name + "_dpi.h")
    stim_sv_pkg = str(stim_name + "_build/" + stim_name + "_dpi_pkg.sv")

    stim_c_files = getCFiles('./' + stim_name + '_build//')

    #main dictionary
    stimDpiFunctions = {}
    stimDpiFunctions['cFunctions'] = []
    stimDpiFunctions['svFunctions'] = []
    #output YAML file
    # o_file=open("output_mtlb.yaml", "w")

    #c header
    with open(stim_c_header, 'r') as i:
        lines = i.readlines()
        # print(text)
        for line in lines:
            if(line.startswith("DPI_LINK_DECL")):
                stimDpiFunctions['cFunctions'].append(parseDpiFunctions(line))
                # print(dpiFunctions)

    #sv package
    with open(stim_sv_pkg, 'r') as i:
        lines = i.readlines()
        #need to build function blocks like above
        functions = []
        
        for line in lines:
            if(line.startswith("import")):
                functions.append(line)
            elif(line.startswith("input") or line.startswith("inout")):
                functions[len(functions)-1] = functions[len(functions)-1] + line

    for fcn in functions:
        stimDpiFunctions['svFunctions'].append(parseFunction(fcn))
   
data = {}
interfaces = {}
input_if = {}
input_if['clock'] = 'clk'
input_if['reset'] = 'rst'
input_if['veloce_ready'] = 'True'
input_if['mtlb_ready'] = 'True'
input_if['ports'] = []
input_if['transaction_vars'] = []
first = 1
for i in dpiFunctions['svFunctions'][2]['parms']:
    if(first == 0 and i['direction'] == 'input'):
        if (i['unpacked-size'] == []):
                portName = i['name']
                input_if['ports'].append({'name':portName, 
                                    'width':str(calc_port_size(i['type'],i['packed-size'])),
                                    'dir':'output'})
                input_if['transaction_vars'].append({  'name':portName,
                                                    #check for multiple dimensions
                                                    'type': i['type'] + ' '.join(i['packed-size']),
                                                    'isrand':'True',
                                                    'iscompare':'True'})
        else:
            for j in range(sizeOfEntry(i['unpacked-size'][0])):
                
                
                portName = i['name']+'_'+str(j)
                input_if['ports'].append({'name':portName, 
                                    'width':str(calc_port_size(i['type'],i['packed-size'])),
                                    'dir':'output'})
                
                type_s = i['type'] + ' '.join(i['packed-size'])
                input_if['transaction_vars'].append({  'name':portName,
                                                    #check for multiple dimensions
                                                    'type': type_s,
                                                    'isrand':'True',
                                                    'iscompare':'True'})
                                                    #'unpacked_dimension':' '.join(i['unpacked-size'])})
    else:
        first = 0
if stim_name != None:
    input_if['dpi_define'] = {}
    input_if['dpi_define'] = {}
    input_if['dpi_define']['name'] = stim_name
    input_if['dpi_define']['comp_args'] = '-c -DPRINT32 -O2'
    input_if['dpi_define']['link_args'] = '-shared'
    input_if['dpi_define']['files'] = []
    for c_file in stim_c_files:
        input_if['dpi_define']['files'].append(c_file)
    input_if['dpi_define']['imports'] = []
    i = 0
    for svFunc in stimDpiFunctions['svFunctions']:
        # function['']
        cFunc = stimDpiFunctions['cFunctions'][i]
        v = {}
        v['name'] = svFunc['name']
        v['c_return_type'] = cFunc['cReturnType']
        v['sv_return_type'] = svFunc['returnType']
        #cArgs
        s = "("
        for parm in cFunc['cParms']:
            s = s + " " + parm['type'] + parm['parmName'] + ','
        s = s[:-1]    
        s = s + " )"
        v['c_args'] = s
        #svArgs
        v['sv_args'] = []
        for parm in svFunc['parms']:
            v['sv_args'].append({'name': parm['name'],
                                'type': parm['type'] + ' ' + ''.join(parm['packed-size']), 
                                'unpacked_dimension': ''.join(parm['unpacked-size']), 
                                'dir': parm['direction']
                                })

        
        input_if['dpi_define']['imports'].append(v)
        i = i+1

output_if = {}
output_if['reset'] = 'rst'
output_if['clock'] = 'clk'
output_if['veloce_ready'] = 'True'
output_if['mtlb_ready'] = 'True'
output_if['ports'] = []
output_if['transaction_vars'] = []
first = 1
for i in dpiFunctions['svFunctions'][2]['parms']:
    if(first == 0 and i['direction'] == 'inout'):
        #TODO will need to change sizeofentry paramter to accept multiple unpacked if needed
        if i['unpacked-size'] == []:
            output_if['ports'].append({'name':i['name'],
                                    'width':str(calc_port_size(i['type'],i['packed-size'])),
                                    'dir':'input'})
            output_if['transaction_vars'].append({   'name':i['name'],
                                                #check for multiple dimensions
                                                'type':i['type'] + ' '.join(i['packed-size']),
                                                'isrand':'True',
                                                'iscompare':'True'})
        else:
            for j in range(sizeOfEntry(i['unpacked-size'][0])):
                output_if['ports'].append({'name':i['name']+'_'+str(j),
                                    'width':str(calc_port_size(i['type'],i['packed-size'])),
                                    'dir':'input'})
                output_if['transaction_vars'].append({   'name':i['name']+'_'+str(j),
                                                    #check for multiple dimensions
                                                    'type':i['type'] + ' '.join(i['packed-size']),
                                                    'isrand':'True',
                                                    'iscompare':'True'})
                                                    #'unpacked_dimension':' '.join(i['unpacked-size'])})

    else:
        first = 0
interfaces[component_name + '_input_agent'] = input_if
interfaces[component_name + '_output_agent'] = output_if

#Environment
matlab_env = {}
matlab_env['mtlb_ready'] = 'True'
matlab_env['agents'] = []
matlab_env['agents'].append({'name':component_name + '_in_agent','type':component_name+'_input_agent' })
matlab_env['agents'].append({'name':component_name + '_out_agent','type':component_name+'_output_agent' })
matlab_env['analysis_components'] = [{'name':component_name + '_pred', 'type':component_name + '_predictor'}]
matlab_env['scoreboards'] = [{'name':component_name + '_sb', 'sb_type':'uvmf_in_order_race_scoreboard', 'trans_type': component_name + '_output_agent_transaction'}]
matlab_env['tlm_connections'] = []
matlab_env['tlm_connections'].append({'driver': component_name + '_in_agent.monitored_ap', 'receiver':component_name + '_pred.from_in_agent_ae' })
matlab_env['tlm_connections'].append({'driver': component_name + '_out_agent.monitored_ap', 'receiver':component_name + '_sb.actual_analysis_export' })
matlab_env['tlm_connections'].append({'driver': component_name + '_pred.to_sb_ap', 'receiver':component_name + '_sb.expected_analysis_export' })
matlab_env['dpi_define'] = {}
matlab_env['dpi_define']['name'] = component_name
matlab_env['dpi_define']['comp_args'] = '-c -DPRINT32 -O2'
matlab_env['dpi_define']['link_args'] = '-shared'
matlab_env['dpi_define']['files'] = []
for c_file in pred_c_files:
    matlab_env['dpi_define']['files'].append(c_file)
matlab_env['dpi_define']['imports'] = []
i = 0
for svFunc in dpiFunctions['svFunctions']:
    # function['']
    cFunc = dpiFunctions['cFunctions'][i]
    v = {}
    v['name'] = svFunc['name']
    v['c_return_type'] = cFunc['cReturnType']
    v['sv_return_type'] = svFunc['returnType']
    #cArgs
    s = "("
    for parm in cFunc['cParms']:
        s = s + " " + parm['type'] + parm['parmName'] + ','
    s = s[:-1]    
    s = s + " )"
    v['c_args'] = s
    #svArgs
    v['sv_args'] = []
    for parm in svFunc['parms']:
        if parm['unpacked-size']== []:
            v['sv_args'].append({'name': parm['name'],
                                'type': parm['type'] + ' ' + ''.join(parm['packed-size']), 
                                # 'unpacked_dimension': ''.join(parm['unpacked-size']), 
                                'dir': parm['direction']
                                })
        else:
            v['sv_args'].append({'name': parm['name'],
                                'type': parm['type'] + ' ' + ''.join(parm['packed-size']), 
                                'unpacked_dimension': ''.join(parm['unpacked-size']), 
                                'dir': parm['direction']
                                })

    
    matlab_env['dpi_define']['imports'].append(v)
    i = i+1

environments = {}
environments[component_name] = matlab_env

matlab_bench = {}
matlab_bench['top_env'] = component_name
matlab_bench['veloce_ready'] = 'True'
matlab_bench['mtlb_ready'] = 'True'


benches = {}
benches[component_name] = matlab_bench

matlab_utils = {}
matlab_utils['type'] = 'predictor_mtlb'
matlab_utils['analysis_exports'] = []
matlab_utils['analysis_exports'].append({'name': 'from_in_agent_ae', 'type': component_name + '_input_agent_transaction'})

matlab_utils['analysis_ports'] = []
matlab_utils['analysis_ports'].append({'name': 'to_sb_ap', 'type': component_name + '_output_agent_transaction'})

util_components = {}
util_components[component_name + '_predictor'] = matlab_utils
data['uvmf'] = {}
data['uvmf']['util_components'] = util_components
data['uvmf']['interfaces'] = interfaces
data['uvmf']['environments'] = environments
data['uvmf']['benches'] = benches

import yaml
with open('output_mtlb.yaml', 'w') as outfile:
    yaml.dump(data, outfile, default_flow_style=False,width=float('inf'))



