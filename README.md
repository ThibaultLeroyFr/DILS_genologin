# DILS_genologin
For details regarding DILS, please see: <br>
https://github.com/popgenomics/DILS<br>

Here, the repository only explains how to use the software DILS on the genologin computing cluster (genotoul)<br>

## Launch DILS on the example dataset
Data from the example dataset: https://github.com/popgenomics/DILS/tree/master/example <br>
The script_lanceur_DILS_test.sh is used to launch the script on the genologin cluster.<br>
Edit the path in the bidon.yaml to the data and where the DILS scripts are on the cluster.<br><br>
Then launch the computation:<br>
sbatch script_lanceur_DILS_test.sh<br>

## Modifications to do to adjust to your own environment
Take care of all the dependencies regarding python2 and R !! Everything work well on the R version R-4.1.2_gcc-9.3.0, but before I tried several other R versions currently installed on the cluster and I experienced different problems regarding the R librairy dependencies (oen perhaps associated with this reported issue: https://groups.google.com/g/dils---demographic-inferences-with-linked-selection/c/mMBJjj79LoQ, not sure). Anyway, it is expected to work if you load the module associated to the version R-4.1.2_gcc-9.3.0, see script_lanceur_DILS_test.sh.<br><br>
Change "binpath =" in the snakemake files (./DILS/bin/) e.g. ./DILS/bin/Snakefile_2pop <br><br>
Currently I used the lightMode, but I should probably switch to the normal mode to really benefit from the HTC cluster.<br><br>
Use my modified version of the R scripts that require the abcrf function (e.g. model_comp_2pop_allModels.R, for details, see discussion in https://groups.google.com/g/dils---demographic-inferences-with-linked-selection/c/Qcu3rqvPXWc )<br>

## Exclude some specific nodes (slurm)
To exclude nodes that lead to jobs stuck running on these nodes (e.g. node129 recently), it is possible to use the function: <br>
"#SBATCH --exclude=node129" <br>
To exclude more nodes:<br>
"#SBATCH --exclude=node127,node128,node129,node130,node131,node132,node133,node134,node135,node136" or directly "#SBATCH --exclude=node[127-136]"<br>
But this also requires to adjust the script that launch the snakemake and the associated json file (see script_lanceur2_DILS.sh & cluster2.json) <br>

## Generate the input files for DILS (see ./generate_inputfiles/)
The script script_generate_inputfiles_DILS.sh helps to generate the input files for DILS on my own data. The script will select a given number of genomic regions and then change the header in order to obtain the following format (>locusID|pop|ind|Allele1). Note that here, the sequences data only contain Allele1 since the individuals are haploid (note that there is no problem to use haploid data in DILS, see Fraïsse et al. 2021). Thanks to this script, a directory is created, containing the sequence data, the yaml and json files, as well as the script to run DILS (script_lanceur_DILS.sh, see above). The script is just provided as an example on my own data! <br><br>
For my own work, only the first lines of the script should be modified: <br>
Species1=$(echo "Species1") #Define the name of the species1 <br>
Species2=$(echo "Species2") #Define the name of the species2 <br>
nbloci=$(echo "200" | bc) # Define the number of loci to randomly select <br>
constant_or_variable_Ne_through_time=$(echo "constant") #Define if DILS should run simulations assuming constant or variable Ne through time (constant/variable) <br>
 use_the_SFS=$(echo "no") # Define if DILS should consider the site frequency spectrum (yes/no) <br> <br>

Then to launch the script to generate the input files: sbatch script_lanceur_generate_inputfiles_DILS.sh <br>

