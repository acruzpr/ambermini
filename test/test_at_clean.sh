#!/bin/sh

/bin/rm -f \
TEST_FAILURES.diff \
antechamber/ash/antechamber.out \
antechamber/ash/sqm.in \
antechamber/ash/sqm.out \
antechamber/bondtype/antechamber.out \
antechamber/c60/antechamber.out \
antechamber/charmm/antechamber.out \
antechamber/fluorescein/antechamber.out \
antechamber/fluorescein/sqm.in \
antechamber/fluorescein/sqm.out \
antechamber/fpph/antechamber.out \
antechamber/guanine_amber/antechamber.out \
antechamber/guanine_amber/sqm.in \
antechamber/guanine_amber/sqm.out \
antechamber/residuegen/ala_conf1.esp \
antechamber/residuegen/ala_conf2.esp \
antechamber/residuegen/ANTECHAMBER_AC.AC \
antechamber/residuegen/ANTECHAMBER_AC.AC0 \
antechamber/residuegen/ANTECHAMBER_BOND_TYPE.AC \
antechamber/residuegen/ANTECHAMBER_BOND_TYPE.AC0 \
antechamber/residuegen/antechamber.out \
antechamber/residuegen/ATOMTYPE.INF \
antechamber/residuegen/esout \
antechamber/residuegen/espgen.out \
antechamber/residuegen/NEWPDB.PDB \
antechamber/residuegen/PREP.INF \
antechamber/residuegen/punch \
antechamber/residuegen/QIN \
antechamber/residuegen/qout \
antechamber/residuegen/RESIDUE_GEN_MAINCHAIN.DAT \
antechamber/residuegen/RESIDUE_GEN_RESP.INPUT1 \
antechamber/residuegen/RESIDUE_GEN_RESP.INPUT2 \
antechamber/residuegen/RESIDUE_GEN_RESP.OUTPUT1 \
antechamber/residuegen/RESIDUE_GEN_RESP.OUTPUT2 \
antechamber/residuegen/RESIDUE_GEN_RESPGEN.DAT \
antechamber/residuegen/RESIDUE_GEN.AC \
antechamber/residuegen/residuegen.out \
antechamber/sustiva/antechamber.out \
antechamber/sustiva/leap.log \
antechamber/sustiva/prmtop \
antechamber/sustiva/sqm.in \
antechamber/sustiva/sqm.out \
antechamber/tp/antechamber.out \
antechamber/tp/sqm.out \
leap/ff91.log \
leap/ff94_prm.log \
leap/ff94_prm.out \
leap/ff94.log \
leap/ions91.log \
leap/ions94.log \
leap/leap.log \
leap/lib91.out \
leap/lib94.out \
leap/x.lib \
sqm/ch3f/ch3f.pm6.go.out \

find . -name "*.dif" -print0 | xargs -0 /bin/rm -f