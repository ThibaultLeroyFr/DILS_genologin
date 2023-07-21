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

## Modifications to do
Take care of all the dependencies regarding python2 and R !! Everything work well on the R version R-3.5.2, but before I tried several other R versions currently installed on the cluster and I experienced different problems regarding the R librairy dependencies (this is perhaps associated with this reported issue: https://groups.google.com/g/dils---demographic-inferences-with-linked-selection/c/mMBJjj79LoQ, not sure). Anyway, it works if you load the module associated to the version R-3.5.2, see script_lanceur_DILS_test.sh.<br><br>
Change "binpath =" in the snakemake files (./DILS/bin/) e.g. ./DILS/bin/Snakefile_2pop <br><br>
Currently I used the lightMode, but I should probably switch to the normal mode to really benefit from the HTC cluster.<br><br>
Use my modified version of the R scripts that require the abcrf function (e.g. model_comp_2pop_allModels.R, for details, see discussion in https://groups.google.com/g/dils---demographic-inferences-with-linked-selection/c/Qcu3rqvPXWc )<br>

