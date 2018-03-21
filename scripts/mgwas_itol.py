#This script constructs an iTOL tree with information of loci counts and heritability using itol.py
#It is based on the example.py script provided by A. Wang at https://github.com/albertyw/itolapi
#To use mgwas_itol.py, you need a tree, a loci counts table and heritability data.

#Import required modules
import os
import sys
from itolapi import Itol, ItolExport

#Define paths
pathname = os.path.dirname(sys.argv[0])
fullpath = os.path.abspath(pathname)
parent_path = fullpath + "/../"
sys.path.append(parent_path)

print('Running itol and itolexport script')
print('')
print('Creating the upload params')

# Set the tree file, loci counts and heritability data
treefile = sys.argv[1]
tree = fullpath + '/' + treefile
locicountsfile = sys.argv[2]
locicounts = fullpath + '/' + locicountsfile
heritabilityfile = sys.argv[3]
heritability = fullpath + '/' + heritabilityfile

# Create the Itol class
mgwastree = Itol.Itol()
mgwastree.add_variable('treeFile', tree)

# Add parameters
mgwastree.add_variable('treeName', 'mgwastree')
mgwastree.add_variable('treeFormat', 'newick')
# Add parameters for loci counts (dataset1)
mgwastree.add_variable('dataset1File', locicounts)
mgwastree.add_variable('dataset1Label', 'colors')
mgwastree.add_variable('dataset1Separator', 'comma')
mgwastree.add_variable('dataset1Type', 'multibar')
mgwastree.add_variable('dataset1PieTransparent', 'multibar')
mgwastree.add_variable('dataset1PieRadiusMax', '200')
# Add parameters for heritability (dataset2)
mgwastree.add_variable('dataset2File', heritability)
mgwastree.add_variable('dataset2Label', 'colors')
mgwastree.add_variable('dataset2Type', 'colorstrip')
mgwastree.add_variable('dataset2Separator', 'space')
mgwastree.add_variable('dataset2BranchColoringType', 'branch')

# Check parameters
mgwastree.print_variables()
# Submit the tree
print('')
print('Uploading the tree. This may take some time depending on how large the tree is and how much load there is on the itol server')
good_upload = mgwastree.upload()
if not good_upload:
    print('There was an error:' + mgwastree.comm.upload_output)
    sys.exit(1)

# Read the tree ID
print('Tree ID: ' + str(mgwastree.comm.tree_id))
# Read the iTOL API return statement
print('iTOL output: ' + str(mgwastree.comm.upload_output))
# Website to be redirected to iTOL tree
print('Tree Web Page URL: ' + mgwastree.get_webpage())
# Warnings associated with the upload
print('Warnings: ' + str(mgwastree.comm.warnings))

# Export the tree above to svg
print('Exporting to svg')
itol_exporter = mgwastree.get_itol_export()
export_location = 'mgwas_tree.svg'
itol_exporter.set_export_param_value('format', 'svg')
#itol_exporter.set_export_param_value('resolution', '300')
itol_exporter.set_export_param_value('fontSize', '90')
itol_exporter.set_export_param_value('lineWidth', '18')
itol_exporter.set_export_param_value('colorBranches', '1')
itol_exporter.set_export_param_value('datasetList', 'dataset1,dataset2')
itol_exporter.export('mgwas_tree.svg')
print('exported tree to ', export_location)
