Here I provide the code to randomly select a given number of genomic sequences (reconstructed) and automatically generate the input files for DILS.<br>
(my fasta sequences are on the genotoul cluster, with the following format  /work/genphyse/cytogen/Thibault/SeqApiPop_completevcf/Species/reconstr_speces_chrXXX.bed.tmp/*.fasta )<br><br>

The first lines of the file script_generate_inputfiles_DILS.sh should be modified, then all is generated automatically in the directory /work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS/<br>
<b>Lines to be modified:</b><br>
Define the focal species<br>
Species1=$(echo "Species1")<br>
Species2=$(echo "Species2")<br>
nbloci=$(echo "nb_loci_to_pickup" | bc)<br>
constant_or_variable_Ne_through_time=$(echo "constant") # constant: Ne constant after split or variable: to consider population growth / bottleneck<br>
use_the_SFS=$(echo "no") # yes/no<br>
