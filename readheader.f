C *************************************************************************
      SUBROUTINE READHEADER

C  PRINT OUT ALL THE HEADER KEYWORDS IN ALL EXTENSIONS OF A FITS FILE

      INTEGER STATUS,UNIT,READWRITE,BLOCKSIZE,NKEYS,NSPACE,HDUTYPE,I,J
      CHARACTER FILENAME*80,RECORD*80

C  THE STATUS PARAMETER MUST ALWAYS BE INITIALIZED.
      STATUS=0

C  GET AN UNUSED LOGICAL UNIT NUMBER TO USE TO OPEN THE FITS FILE.
      CALL FTGIOU(UNIT,STATUS)

C     NAME OF FITS FILE 
      FILENAME='ATESTFILEZ.FITS'

C     OPEN THE FITS FILE, WITH READ-ONLY ACCESS.  THE RETURNED BLOCKSIZE
C     PARAMETER IS OBSOLETE AND SHOULD BE IGNORED. 
      READWRITE=0
      CALL FTOPEN(UNIT,FILENAME,READWRITE,BLOCKSIZE,STATUS)

      J = 0
100   CONTINUE
      J = J + 1

      PRINT *,'HEADER LISTING FOR HDU', J

C  THE FTGHSP SUBROUTINE RETURNS THE NUMBER OF EXISTING KEYWORDS IN THE
C  CURRENT HEADER DATA UNIT (CHDU), NOT COUNTING THE REQUIRED END KEYWORD,
      CALL FTGHSP(UNIT,NKEYS,NSPACE,STATUS)

C  READ EACH 80-CHARACTER KEYWORD RECORD, AND PRINT IT OUT.
      DO I = 1, NKEYS
          CALL FTGREC(UNIT,I,RECORD,STATUS)
          PRINT *,RECORD
      END DO

C  PRINT OUT AN END RECORD, AND A BLANK LINE TO MARK THE END OF THE HEADER.
      IF (STATUS .EQ. 0)THEN
          PRINT *,'END'
          PRINT *,' '
      END IF

C  TRY MOVING TO THE NEXT EXTENSION IN THE FITS FILE, IF IT EXISTS.
C  THE FTMRHD SUBROUTINE ATTEMPTS TO MOVE TO THE NEXT HDU, AS SPECIFIED BY
C  THE SECOND PARAMETER.   THIS SUBROUTINE MOVES BY A RELATIVE NUMBER OF
C  HDUS FROM THE CURRENT HDU.  THE RELATED FTMAHD ROUTINE MAY BE USED TO
C  MOVE TO AN ABSOLUTE HDU NUMBER IN THE FITS FILE.  IF THE END-OF-FILE IS
C  ENCOUNTERED WHEN TRYING TO MOVE TO THE SPECIFIED EXTENSION, THEN A
C  STATUS = 107 IS RETURNED.
      CALL FTMRHD(UNIT,1,HDUTYPE,STATUS)

      IF (STATUS .EQ. 0)THEN
C         SUCCESS, SO JUMP BACK AND PRINT OUT KEYWORDS IN THIS EXTENSION
          GO TO 100

      ELSE IF (STATUS .EQ. 107)THEN
C         HIT END OF FILE, SO QUIT
          STATUS=0
      END IF

C  THE FITS FILE MUST ALWAYS BE CLOSED BEFORE EXITING THE PROGRAM. 
C  ANY UNIT NUMBERS ALLOCATED WITH FTGIOU MUST BE FREED WITH FTFIOU.
      CALL FTCLOS(UNIT, STATUS)
      CALL FTFIOU(UNIT, STATUS)

C  CHECK FOR ANY ERROR, AND IF SO PRINT OUT ERROR MESSAGES.
C  THE PRINTERROR SUBROUTINE IS LISTED NEAR THE END OF THIS FILE.
      IF (STATUS .GT. 0)CALL PRINTERROR(STATUS)
      END
