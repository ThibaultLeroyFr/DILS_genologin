#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --cpus-per-task=2
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=30G
#SBATCH -p unlimitq

module load bioinfo/snakemake-7.8.1
module load system/pypy2.7-v7.3.12
module load system/Python-2.7.15
#module load system/R-3.5.2
module load system/R-4.1.2_gcc-9.3.0
snakemake --snakefile /work/genphyse/cytogen/Thibault/Softwares/DILS-master/bin/Snakefile_2pop -p -j 2 --configfile /work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS/Mellifera_Ouessant_constantNe_noSFS_nooutgroup/Mellifera_Ouessant_constantNe_noSFS_nooutgroup.yaml --cluster-config /work/genphyse/cytogen/Thibault/SeqApiPop_demography/DILS/Mellifera_Ouessant_constantNe_noSFS_nooutgroup/cluster2.json --cluster "sbatch --exclude={cluster.exclude} --nodes={cluster.node} --ntasks={cluster.n} --cpus-per-task={cluster.cpusPerTask} --time={cluster.time}"


