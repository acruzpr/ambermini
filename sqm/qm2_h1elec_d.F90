! <compile=optimized>
#include "copyright.h"
#include "../include/dprec.fh"
subroutine qm2_h1elec_d(R2,XI,XJ, n_atomic_orbi,n_atomic_orbj,indexi, indexj, qmitype,qmjtype,  &
                        totalNumberOrbitals, H)

!***********************************************************************
!
!  qm2_h1elec_d forms the one-electron matrix between two atoms and
!  calculates the overlaps. (resonance integrals)
!
! This version is a wrapper of Thiel's code.
! created by Taisung Lee (Rutgers, 2011)
!
!   ON INPUT
!               XI   = COORDINATES OF FIRST ATOM.
!               XJ   = COORDINATES OF SECOND ATOM.
!  n_atomic_orbi,j   = number of atomic orbitals on i and j.
!                                                 
!   ON OUTPUT  H filled with the one electrion reasonance integral
!***********************************************************************


      use constants          , only : A2_TO_BOHRS2, A_TO_BOHRS, half
      use Rotation           , only : GetRotationMatrix, Rotate1Elec
      use ElementOrbitalIndex, only: MaxValenceOrbitals,MaxGaussianExpansion, MaxValenceDimension
      use SlaterOverlap      , only :GetSlaterOverlap
      use qmmm_module        , only : qm2_params, EXPONENTIAL_CUTOFF
      use utilitiesmodule, only : print

      implicit none

!Passed In
      _REAL_, intent(in) :: R2,XI(3),XJ(3) 
      integer, intent(in) :: n_atomic_orbi, n_atomic_orbj
      integer, intent(in) :: indexi, indexj, qmitype,qmjtype
      integer, intent(in) :: totalNumberOrbitals
             
      _REAL_, intent(inout)::H(totalNumberOrbitals*(totalNumberOrbitals+1)/2)

      !These are passed in here rather than used from the module to avoid
      !
      
!Local
      _REAL_ :: z(14), xij(3)
      _REAL_ :: matrix(15,45)
      _REAL_ :: betasas,betasap,betapas,betasad, betadas, betapap, betapad, betadap, betadad                      

      _REAL_ ::rab
      _REAL_ ::zeta_si, zeta_sj, zeta_pi, zeta_pj, zeta_di, zeta_dj
      integer:: ni, nj, ndi, ndj

      logical::isISAtom=.false., isISPAtom=.false.,isISPDAtom=.false.
      logical::isJSAtom=.false., isJSPAtom=.false.,isJSPDAtom=.false.

        betasas     =qm2_params%betasas(qmitype,qmjtype)
        betasap     =qm2_params%betasap(qmitype,qmjtype)
        betapas     =qm2_params%betasap(qmjtype,qmitype)
        betasad     =qm2_params%betasad(qmitype,qmjtype)
        betadas     =qm2_params%betasad(qmjtype,qmitype)        
        betapap     =qm2_params%betapap(qmitype,qmjtype)
        betapad     =qm2_params%betapad(qmitype,qmjtype)
        betadap     =qm2_params%betapad(qmjtype,qmitype)        
        betadad     =qm2_params%betadad(qmitype,qmjtype) 
      
        ni=qm2_params%sp_quantum_number(qmitype)
        ndi = qm2_params%d_quantum_number(qmitype)
        nj=qm2_params%sp_quantum_number(qmjtype) 
        ndj = qm2_params%d_quantum_number(qmjtype)
        zeta_si=qm2_params%s_orb_exp_by_type(qmitype)
        zeta_sj=qm2_params%s_orb_exp_by_type(qmjtype)  
        zeta_pi=qm2_params%p_orb_exp_by_type(qmitype)
        zeta_pj=qm2_params%p_orb_exp_by_type(qmjtype) 
        zeta_di=qm2_params%d_orb_exp_by_type(qmitype)
        zeta_dj=qm2_params%d_orb_exp_by_type(qmjtype)
        rab=sqrt(R2)            
                        
        isISAtom=(n_atomic_orbi==1)
        isISPAtom=(n_atomic_orbi==4)
        isISPDAtom=(n_atomic_orbi==9)   

        isJSAtom=(n_atomic_orbj==1)
        isJSPAtom=(n_atomic_orbj==4)
        isJSPDAtom=(n_atomic_orbj==9)         

!C     Z(1)   = S(I)       / S(J)
        z(1)=GetSlaterOverlap(ni, 0, nj, 0, 0, zeta_si, zeta_sj,rab)*half*betasas
       if (.not.isJSAtom) then 
!C     Z(2)   = S(I)       / P-SIGMA(J)
        z(2)=GetSlaterOverlap(ni, 0, nj, 1, 0, zeta_si, zeta_pj,rab)*half*betasap   
       end if
       if (.not.isISAtom) then 
!C     Z(3)   = P-SIGMA(I) / S(J)
        z(3)=GetSlaterOverlap(ni, 1, nj, 0, 0, zeta_pi, zeta_sj,rab)*half*betapas
       endif
       if (.not.isJSAtom .and. .not.isISAtom) then 
!C     Z(4)   = P-SIGMA(I) / P-SIGMA(J)
        z(4)=GetSlaterOverlap(ni, 1, nj, 1, 0, zeta_pi, zeta_pj,rab)*half*betapap
!C     Z(5)   = P-PI(I)    / P-PI(J)
        z(5)=GetSlaterOverlap(ni, 1, nj, 1, 1, zeta_pi, zeta_pj,rab)*half*betapap
       endif
       if (isJSPDAtom) then 
!C     Z(7)   = D-SIGMA(J) / S(I)
        z(7)=GetSlaterOverlap(ni, 0, ndj, 2, 0, zeta_si, zeta_dj,rab)*half*betasad
       endif
       if (isISPDAtom) then        
!C     Z(6)   = S(J)       / D-SIGMA(I)
        z(6)=GetSlaterOverlap(ndi, 2, nj, 0, 0, zeta_di, zeta_sj,rab)*half*betadas
       end if
       if (.not.isISAtom .and. isJSPDAtom) then 
!C     Z(9)   = D-SIGMA(J) / P-SIGMA(I)
        z(9)=GetSlaterOverlap(ni, 1, ndj, 2, 0, zeta_pi, zeta_dj,rab)*half*betapad      
!C     Z(11)  = D-PI(J)    / P-PI(I)
        z(11)=GetSlaterOverlap(ni, 1, ndj, 2, 1, zeta_pi, zeta_dj,rab)*half*betapad*3.0d0
       end if
       if (isISPDAtom .and. .not.isJSAtom) then        
!C     Z(8)   = P-SIGMA(J) / D-SIGMA(I)
        z(8)=GetSlaterOverlap(ndi, 2, nj, 1, 0, zeta_di, zeta_pj,rab)*half*betadap
!C     Z(10)  = P-PI(J)    / D-PI(I)
        z(10)=GetSlaterOverlap(ndi, 2, nj, 1, 1, zeta_di, zeta_pj,rab)*half*betadap*3.0d0
       end if
       if (isISPDAtom .and. isJSPDAtom) then           
!C     Z(12)  = D-SIGMA(J) / D-SIGMA(I)
        z(12)=GetSlaterOverlap(ndi, 2, ndj, 2, 0, zeta_di, zeta_dj,rab)*half*betadad
!C     Z(13)  = D-PI(J)    / D-PI(I)
        z(13)=GetSlaterOverlap(ndi, 2, ndj, 2, 1, zeta_di, zeta_dj,rab)*half*betadad*9.0d0
!C     Z(14)  = D-DELTA(J) / D-DELTA(I)
        z(14)=GetSlaterOverlap(ndi, 2, ndj, 2, 2, zeta_di, zeta_dj,rab)*half*betadad
       end if
     
      xij=xj-xi
      call GetRotationMatrix(xij, matrix, .true.)   
      call Rotate1Elec(indexi,indexj,n_atomic_orbi,n_atomic_orbj,Z,matrix, &
               totalNumberOrbitals, H, totalNumberOrbitals*(totalNumberOrbitals+1)/2)     
 
end subroutine qm2_h1elec_d


                        
