      PROGRAM MAIN

C  THIS IS THE FITSIO COOKBOOK PROGRAM THAT CONTAINS AN ANNOTATED LISTING OF
C  VARIOUS COMPUTER PROGRAMS THAT READ AND WRITE FILES IN FITS FORMAT
C  USING THE FITSIO SUBROUTINE INTERFACE.  THESE EXAMPLES ARE
C  WORKING PROGRAMS WHICH USERS MAY ADAPT AND MODIFY FOR THEIR OWN
C  PURPOSES.  THIS COOKBOOK SERVES AS A COMPANION TO THE FITSIO USER'S
C  GUIDE THAT PROVIDES MORE COMPLETE DOCUMENTATION ON ALL THE
C  AVAILABLE FITSIO SUBROUTINES.

C  CALL EACH SUBROUTINE IN TURN:

      CALL WRITEIMAGE
      CALL WRITEASCII
      CALL WRITEBINTABLE
      CALL COPYHDU
      CALL SELECTROWS
      CALL READHEADER
      CALL READIMAGE
      CALL READTABLE
      PRINT *
      PRINT *,"ALL THE FITSIO COOKBOOK ROUTINES RAN SUCCESSFULLY."

      END
