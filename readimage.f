C *************************************************************************
      SUBROUTINE READIMAGE

C  READ A FITS IMAGE AND DETERMINE THE MINIMUM AND MAXIMUM PIXEL VALUE.
C  RATHER THAN READING THE ENTIRE IMAGE IN
C  AT ONCE (WHICH COULD REQUIRE A VERY LARGE ARRAY), THE IMAGE IS READ
C  IN PIECES, 100 PIXELS AT A TIME.  

      INTEGER STATUS,UNIT,READWRITE,BLOCKSIZE,NAXES(2),NFOUND
      INTEGER GROUP,FIRSTPIX,NBUFFER,NPIXELS,I
      REAL DATAMIN,DATAMAX,NULLVAL,BUFFER(100)
      LOGICAL ANYNULL
      CHARACTER FILENAME*80

C  THE STATUS PARAMETER MUST ALWAYS BE INITIALIZED.
      STATUS=0

C  GET AN UNUSED LOGICAL UNIT NUMBER TO USE TO OPEN THE FITS FILE.
      CALL FTGIOU(UNIT,STATUS)

C  OPEN THE FITS FILE PREVIOUSLY CREATED BY WRITEIMAGE
      FILENAME='ATESTFILEZ.FITS'
      READWRITE=0
      CALL FTOPEN(UNIT,FILENAME,READWRITE,BLOCKSIZE,STATUS)

C  DETERMINE THE SIZE OF THE IMAGE.
      CALL FTGKNJ(UNIT,'NAXIS',1,2,NAXES,NFOUND,STATUS)

C  CHECK THAT IT FOUND BOTH NAXIS1 AND NAXIS2 KEYWORDS.
      IF (NFOUND .NE. 2)THEN
          PRINT *,'READIMAGE FAILED TO READ THE NAXISN KEYWORDS.'
          RETURN
       END IF

C  INITIALIZE VARIABLES
      NPIXELS=NAXES(1)*NAXES(2)
      GROUP=1
      FIRSTPIX=1
      NULLVAL=-999
      DATAMIN=1.0E30
      DATAMAX=-1.0E30

      DO WHILE (NPIXELS .GT. 0)
C         READ UP TO 100 PIXELS AT A TIME 
          NBUFFER=MIN(100,NPIXELS)
      
          CALL FTGPVE(UNIT,GROUP,FIRSTPIX,NBUFFER,NULLVAL,
     &            BUFFER,ANYNULL,STATUS)

C         FIND THE MIN AND MAX VALUES
          DO I=1,NBUFFER
              DATAMIN=MIN(DATAMIN,BUFFER(I))
              DATAMAX=MAX(DATAMAX,BUFFER(I))
          END DO

C         INCREMENT POINTERS AND LOOP BACK TO READ THE NEXT GROUP OF PIXELS
          NPIXELS=NPIXELS-NBUFFER
          FIRSTPIX=FIRSTPIX+NBUFFER
      END DO

      PRINT *
      PRINT *,'MIN AND MAX IMAGE PIXELS = ',DATAMIN,DATAMAX

C  THE FITS FILE MUST ALWAYS BE CLOSED BEFORE EXITING THE PROGRAM. 
C  ANY UNIT NUMBERS ALLOCATED WITH FTGIOU MUST BE FREED WITH FTFIOU.
      CALL FTCLOS(UNIT, STATUS)
      CALL FTFIOU(UNIT, STATUS)

C  CHECK FOR ANY ERROR, AND IF SO PRINT OUT ERROR MESSAGES.
C  THE PRINTERROR SUBROUTINE IS LISTED NEAR THE END OF THIS FILE.
      IF (STATUS .GT. 0)CALL PRINTERROR(STATUS)
      END