# DILS_genologin
For details regarding DILS, please see: <br>
https://github.com/popgenomics/DILS<br>

Here, the repository explains how to use the software DILS on the genologin computing cluster (genotoul)<br>

## Launch DILS on the test dataset
The script_lanceur_DILS_test.sh is used to launch the script on the cluster.<br>
Edit the path in the bidon.yaml to the data and where the DILS scripts are on the cluster.<br>
Then launch the computation:<br>
sbatch script_lanceur_DILS_test.sh<br>

## Modifications to do
Take care of all the dependencies regarding python2 and R !! Everything work well on the R version R-3.5.2, but before I tried many other R version installed on the cluster with different problems regarding the R librairies dependencies (this is perhaps associated with this reported issue: https://groups.google.com/g/dils---demographic-inferences-with-linked-selection/c/mMBJjj79LoQ, not sure). Anyway, it works if you load the module associated to the version R-3.5.2, see script_lanceur_DILS_test.sh.<br>
Change "binpath =" in the snakemake files (./bin/) e.g. ./bin/Snakefile_2pop <br>
Currently I used the lightMode, but I should probably switch to the normal mode to really benefit from the HTC cluster.<br>
Use my modified version of the R scripts using abcrf (e.g. model_comp_2pop_allModels.R, due to an error in abcrf: see discussion in https://groups.google.com/g/dils---demographic-inferences-with-linked-selection/c/Qcu3rqvPXWc )<br>

