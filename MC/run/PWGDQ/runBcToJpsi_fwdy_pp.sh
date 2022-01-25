#!/usr/bin/env bash

# make sure O2DPG + O2 is loaded
[ ! "${O2DPG_ROOT}" ] && echo "Error: This needs O2DPG loaded" && exit 1
[ ! "${O2_ROOT}" ] && echo "Error: This needs O2 loaded" && exit 1


# ----------- LOAD UTILITY FUNCTIONS --------------------------
. ${O2_ROOT}/share/scripts/jobutils.sh 

export CFGPATH=$PWD
echo "Beams:frameType = 4" >> $CFGPATH/pythia8_BcFwd.cfg 
echo "Beams:LHEF = "${O2DPG_ROOT}"/MC/config/common/pythia8/Bc/bcvegpy.lhe" >> $CFGPATH/pythia8_BcFwd.cfg

RNDSEED=${RNDSEED:-0}
NSIGEVENTS=${NSIGEVENTS:-1}
NBKGEVENTS=${NBKGEVENTS:-1}
NWORKERS=${NWORKERS:-8} 
NTIMEFRAMES=${NTIMEFRAMES:-1}

${O2DPG_ROOT}/MC/bin/o2dpg_sim_workflow.py -eCM 900 -gen external -j ${NWORKERS} -ns ${NSIGEVENTS} -tf ${NTIMEFRAMES} -e TGeant4 -mod "--skipModules ZDC" \
	-trigger "external" -ini $O2DPG_ROOT/MC/config/PWGDQ/ini/GeneratorBcFwd.ini  \
        -genBkg pythia8 -procBkg inel -colBkg pp --embedding -nb ${NBKGEVENTS} --mft-reco-full

# run workflow
${O2DPG_ROOT}/MC/bin/o2_dpg_workflow_runner.py -f workflow.json

rm $CFGPATH/pythia8_BcFwd.cfg
