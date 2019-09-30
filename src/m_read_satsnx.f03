MODULE m_read_satsnx

! ----------------------------------------------------------------------
! MODULE: m_read_satsnx.f03
! ----------------------------------------------------------------------
! Purpose:
!
!  Module for reading IGS metadat SINEX file and stroing info as global
!  variables 
! 
! ----------------------------------------------------------------------
! Author :	Tzupang Tseng, Geoscience Australia, Australia
! Created:	05-09-2019
! ----------------------------------------------------------------------

      IMPLICIT NONE
!      SAVE		
  	  
Contains
  
SUBROUTINE read_satsnx (satsinex_filename, Iyr, iday, Sec_00, PRN_isat)

! ----------------------------------------------------------------------
! SUBROUTINE: read_satsnx.f03
! ----------------------------------------------------------------------
! Purpose:
!  Read and store satellite metadata information
! ----------------------------------------------------------------------
! Input arguments:
! - satsinex_filename:	Name of satellite SINEX file containing 
!                       satellite prn and svn numbers, transmitting antenna power,
!                       satellite mass and satellite block types
! - Iyr    : 4 digit year
! - iday   : Day of year
! - Sec_00 : Seconds of the day
!
! Ouptut arguments: (None)
! ----------------------------------------------------------------------
! Remarks:
!  
      USE mdl_precision
      USE mdl_num
      USE mdl_param
      USE mdl_config
      USE m_read_svsinex
      IMPLICIT NONE

! ----------------------------------------------------------------------
! Dummy argument declarations
! ----------------------------------------------------------------------
      CHARACTER (LEN=100) :: satsinex_filename
      CHARACTER (LEN=3) :: PRN_isat
      CHARACTER (LEN=1) :: gnss
! ----------------------------------------------------------------------
! Local variables declaration
! ----------------------------------------------------------------------
      INTEGER (KIND = prec_int4) :: i
      INTEGER (KIND = prec_int2) :: ios
      INTEGER (KIND = prec_int2) :: ios_line, ios_key, ios_data
      INTEGER (KIND = prec_int2) :: AllocateStatus
      INTEGER (KIND = prec_int2) :: idir     ! Direction of PRN->SVN or visa-vers
      INTEGER (KIND = prec_int4) :: UNIT_IN,isat,iyr,iday,ihr,imin

      REAL (KIND = prec_d) :: Sec_00
      CHARACTER (LEN=128)  :: cha
! ----------------------------------------------------------------------
      UNIT_IN = 90  												
      idir = -1
      ihr  = MOD(Sec_00,3600.d0)
      imin = INT(Sec_00/60.d0 - MOD(Sec_00,60.d0))
      READ(PRN_isat,'(A1,I2)')gnss, isat

! ----------------------------------------------------------------------
! Open IGS metadata file
      OPEN (UNIT = UNIT_IN, FILE = TRIM(satsinex_filename), status='old', IOSTAT = ios)
      
      IF (ios /= 0) THEN
         PRINT *, "Error in opening IGS metadata file:", satsinex_filename
         PRINT *, "OPEN IOSTAT=", ios
         STOP
      END IF
      
      CALL read_svsinex(UNIT_IN,idir,iyr,iday,ihr,imin,gnss,isat, &
                  SVNID,BLKTYP,BLKID,MASS,power)
 
! ----------------------------------------------------------------------
      CLOSE (UNIT=UNIT_IN)
      	  
END SUBROUTINE

END
