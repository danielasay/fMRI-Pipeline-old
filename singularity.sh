#!/bin/bash


#SBATCH --job-name="fmriprep"
#SBATCH --output="fmriprep.%j.%N.out"
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --export=ALL
#SBATCH --time 5:45:00


cd /oasis/scratch/comet/dasay/temp_project/data

singularity run --cleanenv --bind /oasis/scratch /home/dasay/myimages/fmriprep.img \
    /oasis/scratch/comet/dasay/temp_project/data /oasis/scratch/comet/dasay/temp_project/data/1_derivatives \
    participant \
    --participant-label ${i} \
    --fs-license-file /oasis/scratch/comet/dasay/temp_project/license.txt















   # cd /home/dasay

#singularity run --cleanenv myimages/fmriprep.img \
#    /home/dasay/compute/data /home/dasay/compute/data/derivatives \
#    participant \
#    --participant-label 1425 1428 1435 1443 1461 1475 1476 1479 1514 1515 1516 1537 1538 1539 1540 1542 1543 1544 1545 1548 1549 1565 1568 1569 1570 1572 1573 1587 1588 1589 1591 1592 1593 1594 1597 1963 2259







