R__ADD_INCLUDE_PATH($O2DPG_ROOT/MC/config/PWGDQ/EvtGen)
R__ADD_INCLUDE_PATH($PYTHIA_ROOT/include)

#include "GeneratorEvtGen.C"
#include "Pythia8/Pythia.h"


FairGenerator*
GeneratorBcFwd(TString pdgs = "541;443")
{
  auto gen = new o2::eventgen::GeneratorEvtGen<o2::eventgen::GeneratorPythia8>();

  std::string spdg;
  TObjArray *obj = pdgs.Tokenize(";");
  gen->SetSizePdg(obj->GetEntriesFast());
  for(int i=0; i<obj->GetEntriesFast(); i++) {
   spdg = obj->At(i)->GetName();
   gen->AddPdg(std::stoi(spdg),i);
   printf("PDG %d \n",std::stoi(spdg));
  }
  gen->SetForceDecay(kBc3Muon);
  // print debug
  // gen->PrintDebug();

  return gen;
}

