       IDENTIFICATION DIVISION.                                         07/15/04
      *VSCOBII85.
       PROGRAM-ID.    FH02P0M3.                                            LV001
      *
       AUTHOR.        FEP INTERNAL.
      *
       DATE-WRITTEN.  JAN 01, 2002.
       DATE-COMPILED.
      *
      *
      *
      *
      *
      *
      *================================================================
      ***   THIS NEWCLAIMS PROGRAM IS AN EXTRACTION/MODIFICATION TO
      ***   SYSTEM85 PROGRAM FH02P5M2
      *================================================================
      *    FUNCTION:
      *================================================================
      *
      *    TO ROUTE CLAIMS THROUGH BENEFITS ADMINISTRATION, PRICING,
      *    PAYMENT CALCULATION, COB,  AND SUBSCRIBER LIABILITY
      *    PROCESSING.  IT WILL ALSO PERFORM CROSSFOOT LOGIC AND WRITE
      *    SUPPORTING HISTORY RECORDS.
      *
      *================================================================
      *    COPYBOOKS:
      *================================================================
      *
      *      FWG00013    LINKAGE   FH01-EXECUTIVE-DATA-FIELDS
      *      FWG00016    LINKAGE   ADMIN-MESSAGES-TOTALS
      *      FWG00018    LINKAGE   P0M3-EXECUTIVE-DATA-FIELDS
      *      FWG00052    LINKAGE   F00050-TABLE
      *      FWG00055    LINKAGE   MHSA-TREAT-PLAN-ARRAY
      *      FWG00200    W/S       HOLD-DIAGNOSIS-CODE-FAC
      *      FWG00200    W/S       HOLD-DIAGNOSIS-CODE-PRO
      *      FWG00206    W/S       BENEFIT-GROUP
      *      FWG00207    W/S       EDIT-SUPP-HIST-INFO
      *      FWG00209    W/S       BENEFIT-GROUP-BA-ID
      *      FWG00211    W/S       MGMT-ALERT-ERROR-RETURN
      *      FWG00212    LINKAGE   APPL-RETURN-AREA
      *      FWG00215    W/S       BENEFIT-ADMN-PAY-LVL-TABLE
      *      FWG00216    W/S       PERF-PROVIDER-COPAY-TABLE
      *      FWG00217    W/S       MGMT-ALERT-RECORD
      *      FWG00218    W/S       TOTALS-ACCUMULATIONS
      *      FWG00219    W/S       PRIMARY-SUPPORTING-HIST-TAB
      *      FWG00220    W/S       SECOND-SUP-HIST-HOLD
      *      FWG00221    W/S       COVERED-SERVICE-GROUP
      *      FWG03160    LINKAGE   FAMILY-WORK-RECORD
      *      FWG03170    LINKAGE   PATIENT-WORK-RECORD
      *      FWG04030    W/S       CLAIM-WORK-RECORD
      *      FWG04190    W/S       FX61-CLAIM-RETRIEVAL-DATA
      *      FWG04195    W/S       FX63-PARAMETER-FIELDS
      *      FWG05000    W/S       TWR-AUXILIARY-FIELDS
      *      FWG05007    W/S       INIT-AUX-FIELDS-RECORD
      *      FWG05010    W/S       ADJUSTMENT-REPORT-DATA
      *      FWG06002    W/S       TRANSACTION-COB-RECORD
      *      FWG06002    LINKAGE   TRANSACTION-ORG-RECORD
      *      FWG06002    W/S       TRANSACTION-WORK-RECORD
      *      FWG06004    W/S       INIT-TWR-RECORD
      *      FWG06005    W/S       HOLD-TWR-CHARGE-LINE
      *      FWG06008    W/S       SUPPORTING-HISTORY-WORK-RECORD
      *      FWG06009    W/S       SUPPORTING-HISTORY-BASE-RECORD
      *      FWG06150    W/S       SH-CALCULATION-N1-RECORD
      *      FWG06151    W/S       INITALIZE-N1-CALCULATION-LINE
      *      FWG06160    W/S       SH-COB-CALCULATION-N4-RECORD
      *      FWG06161    W/S       INITIALIZE-N4-CALCULATION-LINE
      *      FWG13802    W/S       FH01-OVERRIDES-AREAS
      *      FWG13804    W/S       F030-COMMON-NAMES
      *      FWG13807    W/S       LIFETIME-HOLD
      *
      *
      *
      *================================================================
      *    CALLED MODULES:
      *================================================================
      *
      *      FH02P3M1    CALL      FORMAT F00030
      *      FH02P3M2    CALL      CIRCUMSTANCES
      *      FH02P3M3    CALL      PAYMENT LEVEL
      *      FH02P3M4    CALL      PRICING SAVINGS & ALLOWABLE CHARGE
      *      FH02P3M5    CALL      VA/DOD/IHF
      *      FH02P3M6    CALL      DEDUCTIBLE
      *      FH02P3M7    CALL      COINSURANCE
      *      FH02P3M8    CALL      SPECIAL AMOUNT PAYABLE CALCULATIONS
      *      FH02P3M9    CALL      COB SECONDARY
      *      FH02P3MA    CALL      COB PRIMARY/SECONDARY DETERMINATION
      *      FH02P3MB    CALL      SUBSCRIBER LIABILITY
      *      FH02P3MG    CALL      EOB/INFO REMARKS
      *      FH02P3MH    CALL      PERF-PROVIDER-COPAY-TABLE
      *      FH02P3MI    CALL      DOLLAR MAXIMUMS
      *      FH02P3MJ    CALL      OPL SAVINGS
      *      FH02P1MW    LINK      WRITE
      *      FH02P1MW    LINK      WRITE SUPPORTING HISTORY
      *      FH02P6MW    LINK      WRITE MANAGEMENT ALERT MESSAGE
      *      FH02P0MH    CALL      FORMAT AND WRITE H3 SUPPORTING HIST  FH02P0M3
      *      FH02P0MK    CALL      FORMAT AND WRITE K1 SUPPORTING HIST  FH02P0M3
      *      FH02P0ML    CALL      FORMAT AND WRITE L1 SUPPORTING HIST  FH02P0M3
      *      FX70P2M6    DYNAMIC   CONVERT FEP CENTURY DATE TO
      *                            8 POSITION CALENDAR DATE
      *      FX60P0M1    CALL      READ HISTORY USING KEY INFORMATION
      *
      *================================================================
      *
      *  MAINTENANCE HISTORY:
      *
      *  VER    DATE       PPR     PROG  COMMENTS
      *  --  ----------  ---------  --   -------------------------------
      *  01  07/19/2002  NEWCLAIMS  EL   ORIGINAL VERSION.
      *
      *  02  11/08/2002  TT# 3720   EL   FKR INITIALIZATION PROBLEM  )
      *                                                              )
      *  03  01/01/2003  TT# 1913   EL   BASIC OPTION PRIOR-1        )
      *                                  CHANGES FOR YEAREND
      *                  TT# 1480   KX   FKSO PF5 PROBLEM FIX        )
      *                                                              )
      *  04  02/10/2003  TT# 4725   EL   INFO REMARK OFM7 FIX        )
      *                  TT# 5938   EL   USE MEDICARE ALLOWED AMOUNT )
      *                                  INSTEAD OF THE COVERED
      *                                  CHARGES TO CALCULATE ECF
      *                                  TOTAL CLAIM AMOUNT FOR THE
      *                                  FKR EDIT.
      *                                                              )
      *  05  04/14/2003  TT# 3612   EE   ADDED NEW RESPONSE REASONS  )
      *                             'FP8' OR 'FP9' TO BE USED
      *                             ALONG WITH EDIT 'FPB'.
      *                                                                 FH02P0M3
      *  06  04/19/2003  TT# 9451   EL   BYPASS CROSSFOOT LOGIC ON
      *                             RETAIL PHARMACY CLAIMS
      *                                  INVOLVING MEDICAID.
      *                                                                 FH02P0M3
      *  07  05/16/2003  TT# 3509   KJ   AT THE CLAIM LEVEL, INITIALIZE
      *                                  COPAY-MAX-PER-ADMN-DAYS-ACCUM
      *                                                                 FH02P0M3
      *  08  07/21/2003  CMR354750  AB   HIPAA - RENOVATION
      *                  TT# 6431   EK   MOVE THE ANNUAL DEDUCTIBLE
      *                                  ACCUM TO THE N1 SUPPORTING
      *                                  HISTORY RECORD EVEN WHEN
      *                                  BENEFITS ADMINISTRATION SAYS
      *                                  DEDUCTIBLE IS NOT APPLICABLE.
      *                  TT 9223    EL   SET THE CATASTROPHIC-MAX-IND TO
      *                                  'RESET' WHEN APPROPRIATE &
      *                                  BLANK OUT PATIENT, PLAN, AND
      *                                  CLAIM NUMBER THAT IDENTIFIES
      *                                  THE CLAIM WHICH CAUSED THE
      *                                  THE CATASTROPHIC MAX TO BE MET/
      *                                  EXCEEDED WHEN THE CATASTROPHIC
      *                                  ACCUMULATOR DROPS BELOW THE
      *                                  MAX.
      *
      *  09  09/22/2003  TT 7539    EL   ISSUE FKR WHEN MULTIPLE CLAIMS
      *                                  EXCEED THE SNF MAXIMUM.
      *                                                                 FH02P0M3
      *  10  01/02/2004  TT 13576   EL   MODIFY FOR THE ADDITION OF
      *                                  PRIOR-2 BASIC AND THE REMOVAL
      *                                  OF PRIOR-2 HIGH.
      *                  TT 10505/  EL   IN THE CLAIM INITIALIZATION
      *                     13172        PARAGRAPH, ALWAYS RE-SYNC THE
      *                                  COVERED CHARGES ON P0M3-EXEC-
      *                                  DATA-FIELDS WITH THE TWR.
      *                  TT 11823   KJ   REMOVE SMOKING CESSATION LOGIC
      *                  TT 13691   EL   YEARLY MAINTENANCE - MEDICARE
      *                                  DEDUCTIBLE, COINSURANCE, & CO-
      *                                  PAYMENT AMOUNTS.
      *                  TT 15738   EK   INVALID N1 LINES ON ADJUSTED
      *                                  CLAIMS WITH HISTORY APPROVED
      *                                  CHARGE LINE.
      *                  CMR 373029 EL   GET TRANSACTION-DISP-3-RECORD
      *                                  FROM FH02P0M0 AND PASS IT TO
      *                                  FH02P3M8.
      *                  CMR 377054 EE   TOB 81, 82 & 89 CAN BE INPAT OR
      *                                  OUTPAT. USE TYPE CLAIM FIELD ON
      *                                  TWR TO DETERMINE IF CLAIM IS TO
      *                                  BE PROCESSED AS INPAT OR OUTPAT
      *  11  04/19/2004  TT 14791   EL   REMOVE SAVINGS CODES FROM THE
      *                                  CHARGE LINES IF THE SAVINGS
      *                                  AMOUNT EQUALS 0.
      *                  TT 18735   EL   SUBROGATION CHANGES.
      *
      *  12  05/14/2004  TT 22916   EL   DON'T PROCESS SUBSEQUENT LINES
      *                                  ON THE CLAIM WHEN A CHARGE
      *                                  DEFERS; SIMPLY RETURN TO CALL-
      *                                  ING MODULE FH02P0M0.
      *
      *  13  06/06/2004  CMR371743  TP   REALTIME - MODIFICATIONS
      *
      *  14  07/19/2004  TT 26538   EK   GENERATE L1 RECORD WITH
      *                                  DEFERALS.
      *
      *  15  01/01/2005  CMR387791  EL   CLAIMS HISTORY DB2 CONVERSION  FH02P0M3
      *                  TT 22179   EL   PROPERLY HANDLE HISTORY CHARGE FH02P0M3
      *                                  ON A REBUILT DISP-6 CLAIM.     FH02P0M3
      *                  TT 26543   PE   UPDATED 9430 AND 9440 ROUTINES
      *                                  TO ALWAYS DISPLAY DEDUCT ACCUM
      *                                  AND CAT MAX ACCUM ON HISTORY
      *                                  LINES.
      *                  TT 34446   KM   YEARLY MAINTENANCE - MEDICARE  FH02P0M3
      *                                  DEDUCTIBLE, COINSURANCE, & CO- FH02P0M3
      *                                  PAYMENT AMOUNTS.               FH02P0M3
      *                  TT34821     PE  NON-PAR RELIEF
      *
      *  16  06/11/2005  TT 39717   EL   REMOVE TOS 600 & 6S0 FROM FKR  FH02P0M3
      *                                  EDIT CRITERIA.
      *                  TT 28077   PE   FIX PROBLEM WITH SUBROGATION
      *                                  INFO NOT BEING INITIALIZED
      *                                  PROPERLY ON ADJUSTMENTS
      *
      *  17  08/06/2005  TT 38875   PE   REVISE BFZD/BFNW LOGIC TO
      *                                  REMOVE OVERRIDE IF NOT
      *                                  NECESSARY.
      *                  TT 37520   PE   DO NOT CALL P3MG FOR
      *                     42698        PHARMACY CLAIMS
      *                  TT 47138   PE   REVISE BFZD/BFNW LOGIC TO
      *                                  ONLY CHECK APPROVED CHARGE
      *                                  LINES.
      *
      *  18  10/15/2005  TT 45391   EK   N1 LINES BEING CREATED FOR
      *                                  REJECTED CHARGE LINES OF
      *                                  APPROVED VOIDS IN ERROR.
      *
      *  19  01/02/2006  CMR387791  EL   DB2 CONVERSION PHASE 2         FH02P0M3
      *                  TT 47776   PE   ADD LOGIC FOR NUTRITIONAL
      *                                  COUNSELING VISITS
      *                  TT 44644   KJ   MOVE SUB LIAB CALC FROM
      *                                  FH02P3MB TO FH02P4M0
      *                  TT 48053   EE   DB2 CONVERSION OF F00050
      *                  TT 49949   PE   YEARLY MEDICARE MAINTENANCE
      *                  TT 10358   EK   DELETE PROCESS CODE G/
      *                                  ONE-STEP-PC-NO-REVU-
      *                  TT 51261   EL   USE SERVICE-ACCUM-ID FROM TWR
      *                  TT 51162   PE   INITIALIZE NPAR RELIEF SWITCH
      *                  TT 407750  PE   MEDICARE PART D CHANGES FOR
      *                                  RETAIL DRUGS
      *
      *  20  04/22/2006  TT 51370   EL   ONLY ISSUE FKR DEFERRAL ON
      *                                  SNF CLAIMS WHEN THE MEDICARE
      *                                  PAYMENT DISPOSITION EQUALS
      *                                  'A' OR 'G' OR 'J'.
      *                             KX   REMOVE REFERENCES TO DISP 6
      *                                  CLAIM PROCESSING
      *  21  08/16/2006  TT 57321   PE   ALLOW BFZD LOGIC TO CHECK ALL
      *                                  CHARGE LINES ON CLAIM FOR A2
      *                                  SAVINGS.
      *
      *  22  01/02/2007  TT 407939  EK   RECOMPILE FOR UB04, YE CHANGES
      *                  TT 68571   PE   YEARLY MEDICARE MAINTENANCE
      *                  TT 62090   PE   MODIFY FOR PANAMA PLAN CDS
      *
      *  23  04/14/2007  TT 78472   PE   FIX PROBLEM WITH DRUG DEDUCT.
      *                                  EOB MESSAGES
      *  24  06/09/2007  TT 70177   PE   PREVENT OBRA93 PRICED CLAIMS
      *                                  FROM ENTERING NPAR RELIEF LOGIC
      *
      *  25  01/02/2008  TT 84175   KX   HDHP IMPLEMENTATION
      *                  TT 86748   EK   YEARLY MEDICARE MAINTENANCE
      *                  TT 86616   KJ   ADD LOGIC FOR DENTAL ANES.
      *                                  OVERRIDE
      *                  TT 86219/  EL   ADD STATEMENT TO PERFORM THE
      *                     89136        PARAGRAPH THAT CALLS FH02P3MI.
      *  26  04/12/2008  TT 84291   PE   RETAIN CHARGE COMMENTS INFO ON
      *                                  SUBROGATION ADJUSTMENTS
      *  27  08/16/2008  TT 91691   PE   PREVENT PHARMACY CLAIMS FROM
      *                                  ENTERING NON-PAR RELIEF LOGIC
      *  28  01/02/2009  TT113181   KM   YEARLY MEDICARE MAINTENANCE
      *  29  04/04/2009  TT 103761  EL   BYPASS EDIT FKR WHEN A SNF
      *                                  CLAIM IS BEING PAID AT THE
      *                                  OUTPATIENT BENEFIT LEVEL.
      *                  TT 100638  EL   CHANGE EDIT FKR FROM A DEFERRAL
      *                                  TO A PARTIAL REJECTION & A
      *                                  REJECTION.
      *  30  01/02/2010  TT147992   KM   YEARLY MEDICARE MAINTENANCE
      *                  TT 184100  EL   MOVE VISIT IND 2 & VISIT ACCUM
      *                                  2 TO THE N1 LINE.
      *                  TT 175671  TP   EOB-PRINT-FLAG(OPT-IN/OPT-OUT)
      *                  TT CO237027TP   PAY-THE-SUB-TWR HANDLE IN P4M6
      *  31  02/27/2010  ADR        KX   UPDATE NEW OC GENERATED HISTORY
      *                                  INDICATOR
      *  32  01/01/2011  TT 251581  LT   YEARLY MEDICARE MAINTENANCE
      *                  TT 274033  EL   GET THE MEMBER & CONTRACT
      *                                  WELLNESS DEDUCTIBLE CREDIT
      *                                  IF APPLICABLE AND MOVE TO
      *                                  CORESPONDING FIELDS ON THE
      *                                  EXEC DATA FIELDS COPYBOOK.
      *                  TT 274020  PE   ADD NEW VISIT INDICATOR FOR
      *                                  MHSA MATERNITY TO N1 LINE
      *
      *  33  05/12/2011  TT 335300  KJ   ADD PATIENT WORK RECORD TO
      *                                  CALL OF P3M6 AND P3M7
      *                  TT 347464  PE   INITIALIZE PREV-PAY-IN-FULL-SW
      *
      *  34  05/27/2011  TT 380793  EL   ADD PATIENT WORK RECORD TO
      *                                  CALL OF FH02P3M4
      *  35  06/25/2011  TT 283828  G3   HIPAA 5010 PROJECT
      *  36  01/01/2012  TT 349648  EL   SET THE EOB INDICATOR TO PAPER
      *                                  WHEN THE MEMBER IS TERMINATED
      *                                  OR THE CLAIM INCURRED AT LEAST
      *                                  TWO YEARS AGO.
      *                  TT 349059  V5   YEARLY MEDICARE MAINTENANCE
      *                  TT 344326  KJ   NEW PLAN CODE 789 SPECIALTY
      *                                  PHARMACY
      *  37  07/14/2012  999 CHRGS  EL   INCREASE 40 CHARGES TO 999
      *                                  CHARGES
      *  38  01/01/2013  TT 472229  PE   ADD 5 NEW HISTORICAL MEDICAL
      *                                  ACCUM GROUPS TO 2200-CIRCUM.
      *                                  ROUTINE SO THAT PLAN APPROVED
      *                                  CLAIMS WILL DEFER FOR FZW.
      *                  TT 479411  PE   YEARLY MEDICARE MAINTENANCE
      *
      *  39  04/27/2013  TT 532808  PE   ADD NEW HYSTERECTOMY HME
      *                                  ACCUM LOGIC TO 2200-CIRCUM
      *                                  ROUTINE SO THAT PLAN APPROVED
      *                                  CLAIMS WILL DEFER FOR FZW.
      *  40  07/13/2013  TT 561912  PE   ADD MULTIPLE HME CATEGORIES
      *                                  TO 2200-CIRC ROUTINE SO THAT
      *                                  PLAN APPROVED CLAIMS WILL DEFER
      *                                  FOR FZW.
      *                  TT 548936  EL   MODIFY FKR TO USE STATEMENT END
      *                                  YEAR.
      *  41  09/28/2013  TT 570570  PE   ADD MULTIPLE HME CATEGORIES TO
      *                                  2200-CIRC ROUTINE SO THAT PLAN
      *                                  APPROVED CLAIMS WILL DEFER FOR
      *                                  FZW.
      *
      *  42  01/01/2014  TT 591420  PE   ADD NEW BRCA TEST CATEGORY TO
      *                                  2200-CIRC ROUTINE SO THAT PLAN
      *                                  APPROVED CLAIMS WILL DEFER FOR
      *                                  FZW.
      *                  TT 585337  EL   INITIALIZE & POPULATE THE
      *                                  CONTRACEPTIVE-DATE FIELDS.
      *                  R4 2013    V5   ADD INCURRED DATE TO ESU &
      *                                  CHANGE ESU COPY BOOK LEVELS.
      *                  TT 541029  ZZ   YEARLY MEDICARE MAINTENANCE.
      *
      *  43  04/26/2014  TT 579699  PE   ADD MULTIPLE HME CATEGORIES
      *                                  TO 2200-CIRC ROUTINE SO THAT
      *                                  PLAN APPROVED CLAIMS WILL DEFER
      *                                  FOR FZW.
      *
      *  44  09/27/2014 SOW10 ICD-10 KJ  ADD LOGIC FOR DUAL CODE PROCESS
      *
      *  45  01/01/2015  TT 690582  KJ   ADD TRANPLANT TRAVEL ACCUM
      *                                  TO 2200-CIRC ROUTINE SO THAT
      *                                  PLAN APPROVED CLAIMS WILL DEFER
      *                                  FOR FMG.
      *                  TT 681113  PE   YEARLY MEDICARE MAINTENANCE.
      *
      *  46  04/25/2015  TT 589436  EL   CORRECT SETTING OF THE EOB
      *                                  PRINT INDICATOR.
      *                  TT 715518  PE   NON-PAR BALANCE RELIEF
      *                                  EDITING REVISIONS
      *  47  07/12/2015  TT 681825  PE   REVISE SUBROGATION ADJUSTMENT
      *                                  LOGIC SO THAT EOB INFO REMARKS
      *                                  ARE RETAINED AND NOT OVERLAID
      *                                  WITH DISP. ONE INFO
      *  48  01/01/2016  TT 802267  PE   ADD NEW BART LIFETIME CATEGORY
      *                                  TO 2200-CIRC ROUTINE SO THAT
      *                                  PLAN APPROVED CLAIMS WILL DEFER
      *                                  FOR FZW.
      *                  TT 802259/ EL   MOVE THE MEMBER CATASTROPHIC
      *                     802262       ACCUMULATIONS TO THE N1 LINE.
      *                                  SET THE AMOUNT APPLIED TO THE
      *                                  CATASTROPHIC FOR L1 LINE.
      *                  TT 779579  V5   YEARLY MEDICARE MAINTENANCE.
      *  49  05/13/2016  TT 915663  EL   MAKE EDIT FNW A CLAIM-LEVEL
      *                                  DEFERRAL INSTEAD OF A CHARGE-
      *                                  LEVEL DEFERRAL TO STOP STORAGE
      *                                  VIOLATIONS.
      *
      *
      *  50  07/16/2016  TT 707524  PE   REMOVE REFERENCES TO LEFT AND
      *                                  RIGHT TUBAL LIGATION MODIFIERS
      *
      *  51  01/01/2017  TT 937809  PE   ADD MULTIPLE HME CATEGORIES
      *                                  TO 2200-CIRC ROUTINE SO THAT
      *                                  PLAN APPROVED CLAIMS WILL DEFER
      *                                  FOR FZW.
      *
      *  52  01/01/2017  TT 983486  P7   YEARLY MEDICARE MAINTENANCE
      *                                  UPDATE TO SQL TABLE LOOKUP.
      *
      *  53  01/01/2018  TT 880473  PE   ADD NEW REPLANTATION HME
      *                                  CATEGORY TO 2200-CIRC ROUTINE
      *                                  SO PLAN APPRVD CLAIMS WILL
      *                                  DEFER FOR FZW.
      *                  TT 1059453 PE   ADD NEW SEMEN ANALYSIS HME
      *                                  CATEGORY TO 2200-CIRC ROUTINE
      *                                  SO PLAN APPRVD CLAIMS WILL
      *                                  DEFER FOR FZW.
      *                  TT 1059469 P7   SKILLED NURSING ACCUM
      *
      *                  TT 1062761 H4   BYPASS PROFESSIONAL NPA RELIEF
      *                                  FOR TELEHEALTH TWR
      *
      *  54 04/21/2018   TT 1043099 PE   PULL CORRECT MEDICARE COINS
      *                                  RATE WHEN WE HAVE DATES OF
      *                                  THAT SPAN CALENDAR YEARS.
      *  55 01/01/2019   TT 1171411 PE   BLUE FOCUS IMPLEMENTATION
      *
      *  56 04/27/2019   TT 1038596 PE   ADD SERVICE IDS 1171 AND 1173
      *                                  TO CONTRACEPTIVE SERVICE ID
      *                                  88 LEVEL
      *
      *  57 07/13/2019   TT 1061955 EL   ADD VALUE B8 TO THE NEGATIVE
      *                                  SAVINGS CONDITION NAME.
      *  58 01/01/2020   TT 1278996 PE   REMOVE LOGIC THAT WIPES OUT
      *                                  EDITS WHEN PLAN APPROVED
      *  59 03/13/2020   TT 1363045 PE   ADD NEW 88 LEVEL ALL SERVICE
      *                                  ACCUM IDS FOR PLAN APPRVD LOGIC
      *                                  IN 2200-CIRCUMSTANCES ROUTINE.
      *=================================================================
      *NOTE: 9880- PARA NUMBER IS RESERVED FOR ERROR REPORTING SO AVOID
      *            USING THIS PARA NAME & NUMBER FOR ANY OTHER PURPOSES.
      *=================================================================
      *
      *================================================================
      *
      *
       ENVIRONMENT DIVISION.
      *
      *
       CONFIGURATION SECTION.
      *
       SOURCE-COMPUTER.  IBM-370.
       OBJECT-COMPUTER.  IBM-370.
      *
       DATA DIVISION.
      *
      *
       WORKING-STORAGE SECTION.
      *
       01  DUMMY-COMMAREA                   PIC X.
      *
      *01  FV01P3M0-MODULE           PIC X(8)   VALUE 'FV01P3M0'.
      *
       01  CONSTANTS.
           04  LIT-E                          PIC X     VALUE 'E'.
           04  LIT-F                          PIC X     VALUE 'F'.
           04  LIT-L                          PIC X     VALUE 'L'.
           04  LIT-N                          PIC X     VALUE 'N'.
           04  LIT-S                          PIC X     VALUE 'S'.
           04  LIT-U                          PIC X     VALUE 'U'.
           04  LIT-X                          PIC X     VALUE 'X'.
           04  LIT-1                          PIC X     VALUE '1'.
           04  LIT-6                          PIC X     VALUE '6'.
           04  LIT-7                          PIC X     VALUE '7'.
           04  YES                            PIC X     VALUE 'Y'.
           04  NOO                            PIC X     VALUE 'N'.
           04  PENDING-STATUS                 PIC XX    VALUE '65'.
           04  NOT-PROCESS-STATUS             PIC XX    VALUE '00'.
           04  ALL-NINES                    PIC X(9) VALUE '999999999'.
           04  R-FKR                          PIC XXX   VALUE 'FKR'.
           04  R-FP8                          PIC XXX   VALUE 'FP8'.
      *%%% EL TT 18735 - BEGIN
           04  R-FNM                          PIC XXX   VALUE 'FNM'.
      *%%% PE TT34821 - BEGIN
           04  R-FNW                          PIC XXX   VALUE 'FNW'.    FH02P0M3
      *%%% PE TT34821 - END
      *%%% PE TT85518 - BEGIN
           04  R-FZK                          PIC XXX   VALUE 'FZK'.    FH02P0M3
      *%%% PE TT85518 - END
      *%%% EL TT 18735 - END
           04  E-040                          PIC X(4)  VALUE 'E040'.
           04  E-231                          PIC X(4)  VALUE 'E231'.
           04  E-235                          PIC X(4)  VALUE 'E235'.
           04  E-236                          PIC X(4)  VALUE 'E236'.
           04  E-237                          PIC X(4)  VALUE 'E237'.
           04  E-303                          PIC X(4)  VALUE 'E303'.
           04  E-310                          PIC X(4)  VALUE 'E310'.
           04  E-320                          PIC X(4)  VALUE 'E320'.
           04  E-321                          PIC X(4)  VALUE 'E321'.
           04  E-600                          PIC X(4)  VALUE 'E600'.
           04  E-608                          PIC X(4)  VALUE 'E608'.
           04  E-609                          PIC X(4)  VALUE 'E609'.
           04  E-610                          PIC X(4)  VALUE 'E610'.
           04  E-617                          PIC X(4)  VALUE 'E617'.
           04  E-629                          PIC X(4)  VALUE 'E629'.
           04  E-630                          PIC X(4)  VALUE 'E630'.
           04  E-633                          PIC X(4)  VALUE 'E633'.
           04  E-637                          PIC X(4)  VALUE 'E637'.
           04  E-601                          PIC X(4)  VALUE 'E601'.
           04  E-FM2                          PIC X(4)  VALUE 'EFM2'.
           04  E-FM3                          PIC X(4)  VALUE 'EFM3'.
           04  E-FM4                          PIC X(4)  VALUE 'EFM4'.
           04  E-FM6                          PIC X(4)  VALUE 'EFM6'.
      ****TT 175671 BEGIN
           04  E-018                          PIC X(4)  VALUE 'E018'.
           04  E-304                          PIC X(4)  VALUE 'E304'.
           04  E-305                          PIC X(4)  VALUE 'E305'.
      ****TT 175671 END
      *
           04  WS-C-CALLING-PGM     PIC X(8)   VALUE 'FH02P0M3'.
      *
           04  COMP-CONSTANTS             COMP.
      *%%% EL TT# 100638 - BEGIN
               08  ECF-MAX-ALLOWABLE              PIC S9(6)V99
                                                       VALUE +0.00.
      *%%% EL TT# 100638 - END
               08  JAN-01-1999                    PIC 9(5)
                                                    VALUE 54422.
               08  JAN-01-2000                    PIC 9(5)
                                                    VALUE 54787.
               08  JAN-01-2001                    PIC 9(5)
                                                    VALUE 55153.
               08  JAN-01-2002                    PIC 9(5)
                                                    VALUE 55518.
               08  JAN-01-2003                    PIC 9(5)
                                                    VALUE 55883.
      *%%% EL TT# 13691 BEGIN
               08  JAN-01-2004                    PIC 9(5)
                                                    VALUE 56248.
      *%%% EL TT# 13691 END
      *%%% KM TT# 34446 BEGIN                                           FH02P0M3
               08  JAN-01-2005                    PIC 9(5)              FH02P0M3
                                                    VALUE 56614.        FH02P0M3
      *%%% KM TT# 34446 END                                             FH02P0M3
      *%%% PE TT# 49949                                                 FH02P0M3
               08  JAN-01-2006                    PIC 9(5)              FH02P0M3
                                                    VALUE 56979.        FH02P0M3
      *%%% PE TT# 68571                                                 FH02P0M3
               08  JAN-01-2007                    PIC 9(5)              FH02P0M3
                                                    VALUE 57344.        FH02P0M3
      *%%% EK TT# 86748 BEGIN                                           FH02P0M3
               08  JAN-01-2008                    PIC 9(5)              FH02P0M3
                                                    VALUE 57709.        FH02P0M3
      *%%% EK TT# 86748 END                                             FH02P0M3
      *%%% KM TT#113181 BEGIN                                           FH02P0M3
               08  JAN-01-2009                    PIC 9(5)              FH02P0M3
                                                    VALUE 58075.        FH02P0M3
      *%%% KM TT#113181 END                                             FH02P0M3
      *%%% KM TT#147992 BEGIN                                           FH02P0M3
               08  JAN-01-2010                    PIC 9(5)              FH02P0M3
                                                    VALUE 58440.        FH02P0M3
      *%%% KM TT#147992 END                                             FH02P0M3
      *%%% LT TT#251581 BEGIN: SET-UP JAN 1, 2011 CENTURY DATE          FH02P0M3
               08  JAN-01-2011                    PIC 9(5)              FH02P0M3
                                                    VALUE 58805.        FH02P0M3
      *%%% LT TT#251581 END                                             FH02P0M3
      *%%% V5 TT# 349059 BEGIN:
               08  JAN-01-2012                    PIC 9(5)
                                                    VALUE 59170.
      *%%% V5 TT# 349059 END
      *%%% PE TT# 479411 BEGIN:
               08  JAN-01-2013                    PIC 9(5)
                                                    VALUE 59536.
      *%%% PE TT# 479411 END
      *%%% ZZ TT# 541029 BEGIN:
               08  JAN-01-2014                    PIC 9(5)
                                                    VALUE 59901.
      *%%% ZZ TT# 541029 END
      *%%% PE TT# 681113 BEGIN:
               08  JAN-01-2015                    PIC 9(5)
                                                    VALUE 60266.
      *%%% PE TT# 681113 END
      *%%% V5 TT# 779579 BEGIN:
               08  JAN-01-2016                    PIC 9(5)
                                                    VALUE 60631.
      *%%% V5 TT# 779579 END
      *
       01  WORK-AREAS.

           04  NEG-AMT-PAID-MSG               PIC  X(33) VALUE
               '- CHARGE LINE HAS NEG AMOUNT PAID'.
           04  CROSSFOOT-ERROR-MSG.
               08  FILLER                     PIC X(04)  VALUE
               '-CF-'.
               08  CEM-CVRD-CHGS              PIC Z,ZZZ,ZZ9.99.
               08  FILLER                     PIC X(04)  VALUE ' ¬= '.
               08  CEM-PARTIAL-REJECT-AMT     PIC ZZ,ZZ9.99.
               08  FILLER                     PIC X(03)  VALUE ' + '.
               08  CEM-DEDUCT-AMOUNT          PIC Z,ZZ9.99.
               08  FILLER                     PIC X(03)  VALUE ' + '.
               08  CEM-COINS-AMOUNT           PIC ZZZ,ZZ9.99.
               08  FILLER                     PIC X(03)  VALUE ' + '.
               08  CEM-AMOUNT-PAID            PIC Z,ZZZ,ZZ9.99.
               08  FILLER                     PIC X(03)  VALUE ' + '.
               08  CEM-POSITIVE-SAVINGS       PIC Z,ZZZ,ZZ9.99.
               08  FILLER                     PIC X(03)  VALUE ' - '.
               08  CEM-NEGATIVE-SAVINGS       PIC Z,ZZZ,ZZ9.99.
           04  HOLD-SAVINGS-CODE              PIC  X(02) VALUE SPACES.
               88  HOSP-AUDIT-SAVINGS-CODES              VALUE
                   'L '  'M '.
      *%%% KJ TT# 47789 - BEGIN
      *%%% EL TT# 1061955 - BEGIN
               88  NEGATIVE-SAVINGS-CODES                VALUE
                   'E '  'P '  'S '  '0 '  'Z ' 'B2' 'B3' 'B4' 'B8'.
      *%%% EL TT# 1061955 - END
      *%%% KJ TT# 47789 - END
      *%%% EL TT# 585337 - BEGIN
           04  HOLD-FEP-SERVICE-ID-P0M3       PIC 9(04) VALUE ZEROES.
               88  CONTRACEPTIVE-SERVICE-ID             VALUE
      *%%% PE TT# 1038596 ADD 1171 AND 1173
                   917, 918, 924, 1171, 1173.
      *%%% EL TT# 585337 - END
           04  HOLD-REMARK-CODE               PIC X(04) VALUE SPACES.
           04  CODE-609-CNTR                  PIC X     VALUE SPACES.
           04  CODE-610-CNTR                  PIC X     VALUE SPACES.
           04  CODE-630-CNTR                  PIC X     VALUE SPACES.
           04  CODE-633-CNTR                  PIC X     VALUE SPACES.
           04  CODE-637-CNTR                  PIC X     VALUE SPACES.
           04  CODE-OTH-CNTR                  PIC X     VALUE SPACES.
           04  CODE-EFM-CNTR                  PIC X     VALUE SPACES.
           04  CHECK-FLD                      PIC X     VALUE SPACES.
           04  HOLD-PROCESS-SEQ               PIC 9(3).
           04  SPEC-MAX-AMOUNT-SIZER          PIC 9(7).
      * %% 5A CLE:
           04  CVRD-CHRGS-TABLE
      ****     OCCURS 40 TIMES
               OCCURS 999 TIMES
               INDEXED BY CC-NDX.
               08  LINE-NUMBER-CCT            PIC X(03).
               08  CVRD-CHRGS-ALL-SERVS-CCT   PIC S9(7)V99.
      *%%% EL TT# 4725 BEGIN
               08  MEDICARE-LIMIT-CHGS-CCT    PIC S9(9)V99.
      *%%% EL TT# 4725 BEGIN
      *%%% EL TT# 14791 BEGIN
           04 COMMON-SAVE-IND              PIC X(02) VALUE SPACES.
           04 SAVINGS-AMOUNT-WS            PIC S9(07)V99 VALUE +0.
           04 HOLD-SAVINGS-IND-1           PIC X(02).
           04 HOLD-SAVINGS-AMT-1           PIC X(09).
           04 HOLD-SAVINGS-AMT-1-CP        PIC 9(07)V99.
           04 HOLD-SAVINGS-IND-2           PIC X(02).
           04 HOLD-SAVINGS-AMT-2           PIC X(09).
           04 HOLD-SAVINGS-AMT-2-CP        PIC 9(07)V99.
           04 HOLD-SAVINGS-IND-3           PIC X(02).
           04 HOLD-SAVINGS-AMT-3           PIC X(09).
           04 HOLD-SAVINGS-AMT-3-CP        PIC 9(07)V99.
           04 HOLD-SAVINGS-IND-4           PIC X(02).
           04 HOLD-SAVINGS-AMT-4           PIC X(09).
           04 HOLD-SAVINGS-AMT-4-CP        PIC 9(07)V99.
      *%%% EL TT# 14791 END
      *%%% EL TT 18735 - BEGIN
           04 ADJUST-AMOUNT-WS             PIC S9(07)V99 VALUE +0.
           04 PREV-SUBROGATION-SAVINGS     PIC S9(07)V99 VALUE +0.
           04 HOLD-CHARGE-STATUS           PIC X(02).
           04 HOLD-APOC-IND                PIC X(02).
           04 HOLD-APOC-AMT-AN             PIC X(09).
           04 HOLD-APOC-AMT-CP             PIC 9(07)V99.
           04 HOLD-PREV-AMT-PAID-AN        PIC X(09).
           04 HOLD-PREV-AMT-PAID-CP        PIC 9(07)V99.
           04 HOLD-EDIT-OVERRIDE-CODES     PIC X(20).
           04 HOLD-ADJUSTMENT-REASON       PIC X(01).
      *%%% PE TT84291
           04 HOLD-CHARGE-COMMENTS         PIC X(80).
      *%%% PE TT 34821 - BEGIN
           04 NON-PAR-SVNGS-ACCUM          PIC 9(07)V99.                FH02P0M3
           04 NON-PAR-SVNGS-ACCUM-DISP2    PIC 9(07)V99.                FH02P0M3
           04 NPAR-AMT-REMAIN              PIC 9(07)V99.                FH02P0M3
           04 NON-PAR-SAV-ACCUM            PIC 9(07)V99.                FH02P0M3
           04 NP-RECALC-AMT                PIC 9(07)V99.                FH02P0M3
           04 NON-PAR-MAX                  PIC S9(07)V99                FH02P0M3
                                               VALUE +5000.00.
      *%%% PE TT 34821 - END
      *%%% PE TT 681825  BEGIN
           04 HOLD-EOB-REMARKS             PIC X(16).
           04 HOLD-INFO-REMARKS            PIC X(12).
      *%%% PE TT 681825 - END
      *%%% EL TT# 274033 - BEGIN
           04 SQL-SQLCODE                  PIC S9(9).                   FH02P2M1
              88 SQL-SUCCESS               VALUE 00.                    FH02P2M1
              88 SQL-NOTFND                VALUE +100.                  FH02P2M1
              88 SQL-DUPLICATE             VALUE -811, -803.            FH02P2M1
              88 SQL-DEADLOCK              VALUE -911, -913.            FH02P2M1
           04 WS-DB2HOLD-DATE.                                              FH02
              08 WS-DB2HOLD-YEAR4             PIC 9(4) VALUE 0.             FH02
              08 FILLER                       PIC X    VALUE '-'.           FH02
              08 WS-DB2HOLD-MONTH             PIC 99   VALUE 0.             FH02
              08 FILLER                       PIC X    VALUE '-'.           FH02
              08 WS-DB2HOLD-DAY               PIC 99   VALUE 0.             FH02
      *%%% EL TT# 274033 - END
      *%%% EL TT# 548936 - BEGIN
           04 FKR-YEAR4                    PIC X(04).
      *%%% EL TT# 548936 - END


      *
           04  COMP-WORK-AREAS            COMP.
               08  TOT-AMT-PAID-OTH-CARRIER       PIC S9(7)V99.
               08  TOT-ALLOWABLE-CHARGES          PIC S9(7)V99.
               08  ACCUM-AMT-PAID-OTH-CARRIER     PIC S9(7)V99.
               08  LINK-RESP                  PIC S9(9).
               08  VACOB-SAVINGS-AMOUNT       PIC S9(7)V99.
               08  HOLD-P0M3-ID-NUMBER        PIC 9(8).
               08  TOTAL-DEF-CHARGES          PIC S9(04).
               08  TOTAL-REJ-DISP6-CHARGES    PIC S9(04).
               08  HOLD-FKR-SAVINGS           PIC S9(7)V99.
               08  CCYYMMDD-DATE.
                   12  CC                     PIC 99 VALUE 0.
                   12  YY                     PIC 99 VALUE 0.
                   12  MM                     PIC 99 VALUE 0.
                   12  DD                     PIC 99 VALUE 0.
           04  COMP-3-WORK-AREAS          COMP-3.
               08  ECF-TOTAL-CLAIM-AMOUNT     PIC  9(07)V99.
      *%%% EL TT# 7539 BEGIN
               08  ECF-SNF-CURR-TOTAL-PAID    PIC S9(07)V99.
      *%%% EL TT# 100638 - BEGIN
               08  ECF-SNF-CURR-CHRG-PAID     PIC S9(07)V99.
      *%%% EL TT# 100638 - END
      *%%% EL TT# 7539 END
               08  TEMP-CHARGES               PIC  9(07)V99  VALUE 0.
               08  POSITIVE-SAVINGS-AMT       PIC  9(07)V99  VALUE 0.
               08  NEGATIVE-SAVINGS-AMT       PIC  9(07)V99  VALUE 0.
               08  CROSSFOOT-DIFFERENCE       PIC  9(07)V99  VALUE 0.
               08  HOLD-SAVINGS-AMOUNT        PIC  9(07)V99  VALUE 0.
      *
      *%%% KX CMR 387791
       01  WS-MESSAGE-TEXT.
           05 INVALID-PARM-MESSAGE.
              10                             PIC X(47) VALUE
                 'INVALID PARAMETER LIST WAS PASSED TO DATA LAYER'.
           05 INVALID-RC-MESSAGE.
              10                             PIC X(49) VALUE
                 'INVALID RESULT CODE WAS RETURNED FROM DATA LAYER'.
              10                             PIC X(17) VALUE
                 ' - RESULT CODE = '.
              10  DATA-LAYER-RC              PIC X(02).
              10                             PIC X(18) VALUE
                 ', FUNCTION CODE = '.
              10  DATA-LAYER-FC              PIC X(01).
      *%%% KX CMR 387791 END
      *
       01  SWITCHES.
           04  F030-PROCESS-SW                PIC X.
               88  BEGIN-CHARGE                       VALUE 'B'.
               88  END-CHARGE                         VALUE 'E'.
      *
           04  FIRST-CHARGE-SWITCH            PIC X  VALUE '1'.
               88  FIRST-CHARGE-THRU                  VALUE '1'.
      *
           04  ENTRY-SWITCH                   PIC X   VALUE 'Y'.
               88  ENTRY-FOUND                        VALUE 'Y'.
               88  ENTRY-NOT-FOUND                    VALUE 'N'.
      *
           04  COB-CHG-LINE-REJECT-SW         PIC X   VALUE 'N'.
               88  COB-CHG-LINE-REJECT                VALUE 'Y'.
      *
           04  DEFER-FP8-SW                   PIC X     VALUE 'N'.
               88   YES-DEFER-FP8                       VALUE 'Y'.
      *
      *%%% PE TT 34821 - BEGIN                                          FH02P0M3
           04  DEFER-FNW-SW                   PIC X     VALUE 'N'.      FH02P0M3
               88   YES-DEFER-FNW                       VALUE 'Y'.      FH02P0M3
      *%%% PE TT 34821 - END                                            FH02P0M3
           04  DIFF-SAVINGS1-SW               PIC X.
               88   NO-DIFF-SAVINGS1              VALUE 'N'.
               88   YES-DIFF-SAVINGS1             VALUE 'Y'.
      *
           04  DIFF-SAVINGS2-SW               PIC X.
               88   NO-DIFF-SAVINGS2              VALUE 'N'.
               88   YES-DIFF-SAVINGS2             VALUE 'Y'.
      *
           04  DIFF-SAVINGS3-SW               PIC X.
               88   NO-DIFF-SAVINGS3              VALUE 'N'.
               88   YES-DIFF-SAVINGS3             VALUE 'Y'.
      *
           04  DIFF-SAVINGS4-SW               PIC X.
               88   NO-DIFF-SAVINGS4              VALUE 'N'.
               88   YES-DIFF-SAVINGS4             VALUE 'Y'.
      *
           04  CALC-BY-MED-LIMITING-CHGS-SW   PIC X     VALUE 'N'.
               88   CALC-BY-MED-LIMITING-CHGS               VALUE 'Y'.
               88   NOT-CALC-BY-MED-LIMITING-CHGS           VALUE 'N'.
      *
           04  EDIT-TRANS-AGAINST-HISTORY-SW       PIC X.
               88  EDITTING-AGAINST-HISTORY        VALUE '1'.
               88  NOT-EDITTING-AGAINST-HISTORY    VALUE '0'.
      *
      *%%% EL TT 18735 - BEGIN
           04  SUBROGATION-ADJUSTMENT-SW           PIC X.
               88  IS-SUBROGATION-ADJUSTMENT       VALUE '1'.
               88  NOT-SUBROGATION-ADJUSTMENT      VALUE '0'.
           04  PREVIOUS-SUBROGATION-SW             PIC X.
               88  PREV-WAS-SUBROGATED             VALUE '1'.
               88  PREV-NOT-SUBROGATED             VALUE '0'.
      *%%% EL TT 18735 - END
      *
           04  NON-PAR-MAX-SW                PIC X     VALUE 'N'.       FH02P0M3
               88   NON-PAR-MAX-MET                    VALUE 'Y'.       FH02P0M3
      *                                                                 FH02P0M3
      *%%% PE TT57321 R2/2006 BEGIN                                     FH02P0M3
           04  A2-SAVINGS-SW                PIC X     VALUE 'N'.        FH02P0M3
               88   A2-SAVINGS-ON-CLM                  VALUE 'Y'.       FH02P0M3
               88   NO-A2-SAVINGS-ON-CLM               VALUE 'N'.       FH02P0M3
      *%%% PE TT57321 R2/2006 END                                       FH02P0M3
      *  *                                                              FH02P0M3
      *%%% PE TT70177 OC2 2007 BEGIN                                    FH02P0M3
           04  OBRA93-SW                     PIC X     VALUE 'N'.       FH02P0M3
               88   OBRA93-PRICING-ON-CLM              VALUE 'Y'.       FH02P0M3
               88   NO-OBRA93-PRICING-ON-CLM           VALUE 'N'.       FH02P0M3
      *%%% PE TT70177 OC2 2007 END                                      FH02P0M3
      *                                                                 FH02P0M3
           04  FZD-OVERRIDE-SW                PIC X     VALUE 'N'.      FH02P0M3
               88   YES-FZD-OVERRIDE                    VALUE 'Y'.      FH02P0M3
      *
           04  FNW-OVERRIDE-SW                PIC X     VALUE 'N'.      FH02P0M3
               88   YES-FNW-OVERRIDE                    VALUE 'Y'.      FH02P0M3
      *
           04  CHARGE-FZD-OVERRIDE-SW         PIC X     VALUE 'N'.      FH02P0M3
               88   CHARGE-FZD-OVERRIDE                 VALUE 'Y'.      FH02P0M3
      *
           04  CHARGE-FNW-OVERRIDE-SW         PIC X     VALUE 'N'.      FH02P0M3
               88   CHARGE-FNW-OVERRIDE                 VALUE 'Y'.      FH02P0M3
      *                                                                 FH02P0M3
      *%%% PE TT# 715518 - BEGIN
           04  ADMISSION-FOUND-SW             PIC X     VALUE 'N'.      FH02P0M3
               88   ADMISSION-FND                       VALUE 'Y'.      FH02P0M3
               88   ADMISSION-NOT-FND                    VALUE 'N'.     FH02P0M3
      *                                                                 FH02P0M3
           04  EROOM-FOUND-SW                 PIC X     VALUE 'N'.      FH02P0M3
               88   EROOM-FND                           VALUE 'Y'.      FH02P0M3
               88   EROOM-NOT-FND                       VALUE 'N'.      FH02P0M3
      *%%% PE TT# 715518 - END
      *%%% EL TT# 585337 - BEGIN
           04  LOAD-SW                        PIC X     VALUE 'N'.      FH02P0M3
               88   LOAD-IS-COMPLETE                    VALUE 'Y'.      FH02P0M3
               88   LOAD-IS-NOT-COMPLETE                VALUE 'N'.      FH02P0M3
      *%%% EL TT# 585337 - END
       01  SUBSCRIPTS.
           04  SUB1                       PIC S9(04) BINARY VALUE +0.
           04  SUB2                       PIC S9(04) BINARY VALUE +0.
           04  TWR-CRG-SUB                PIC S9(04) BINARY.
           04  ORG-CRG-SUB                PIC S9(04) BINARY.
           04  CHRG-SUB                   PIC S9(04) BINARY.
           04  COB-SUB                    PIC S9(04) BINARY.
           04  BKUP-SUB                   PIC S9(04) BINARY.
           04  TWR-CRG-SUB-HA             PIC S9(04) BINARY.
           04  NP-SUB                     PIC S9(04) BINARY.            FH02P0M3
      *%%% PE TT# 715518
           04  NP1-SUB                     PIC S9(04) BINARY.           FH02P0M3
           04  NP2-SUB                     PIC S9(04) BINARY.           FH02P0M3
           04  NP3-SUB                     PIC S9(04) BINARY.           FH02P0M3
           04  NP4-SUB                     PIC S9(04) BINARY.           FH02P0M3
           04  NP5-SUB                     PIC S9(04) BINARY.           FH02P0M3
           04  NP6-SUB                     PIC S9(04) BINARY.           FH02P0M3
      *%%% PE TT70177
           04  OBRA-SUB                    PIC S9(04) BINARY.           FH02P0M3

      *%%% EK TT# 15738 BEGIN
         01  SH-LINE-INITIALIZE         PIC X(2772) VALUE SPACES.
      *%%% EK TT# 15738 END
      *%%% P7 TT# 983486 START
       01 MED-MAX-SYS-EFF-DT.
          05 MED-MAX-SYS-EFF-DT-CCYY.
             10 MED-MAX-SYS-EFF-DT-CC   PIC X(02) VALUE SPACES.
             10 MED-MAX-SYS-EFF-DT-YY   PIC X(02) VALUE SPACES.
          05                            PIC X(01) VALUE '-'.
          05 MED-MAX-SYS-EFF-DT-MM      PIC X(02) VALUE SPACES.
          05                            PIC X(01) VALUE '-'.
          05 MED-MAX-SYS-EFF-DT-DD      PIC X(02) VALUE SPACES.

       01 MED-MAX-EFF-DT.
          05 MED-MAX-EFF-DT-CCYY.
             10 MED-MAX-EFF-DT-CC       PIC X(02) VALUE SPACES.
             10 MED-MAX-EFF-DT-YY       PIC X(02) VALUE SPACES.
          05                            PIC X(01) VALUE '-'.
          05 MED-MAX-EFF-DT-MM          PIC X(02) VALUE SPACES.
          05                            PIC X(01) VALUE '-'.
          05 MED-MAX-EFF-DT-DD          PIC X(02) VALUE SPACES.

       01 MGMT-ALERT-MED-MAX.
          04 MABPAA-MESSAGE                   PIC X(36).
               88 MABPAA-UNKNOWN-SQL-MSG      VALUE
                        'UNKNOWN SQL ERR - MEDICARE_MAX_AMT'.
      *%%% P7 TT# 983486 END
      *
      *-----------------------------------------------------------------
      * PARMS PASSED TO FX61:
      *-----------------------------------------------------------------
      *
       01  FX61-PARAMETERS.
      *%%% EL CMR# 387791 - BEGIN
           04  FX61-RESULT-CODE               PIC X(02)    VALUE ZEROES.
               88  NO-MATCHING-RECORD                  VALUE '09'.
               88  MATCHING-HISTORY-FOUND              VALUE '00', '01'.
               88  END-OF-PATIENT-FILE                 VALUE '04'.
               88  INVALID-PARM                        VALUE '22'.
               88  VALID-RESULT-CODE                   VALUES ARE
                                                 '00', '01', '04', '09'.
           04 FX61-PROCESS-YEAR.
               08 FX61-PROCESS-CC             PIC XX.
               08 FX61-PROCESS-YY             PIC XX.
           04 TWR-BEGIN-AND-END-DATES.
               08 TWR-BEGIN-DATE              PIC  9(05)  VALUE ZEROES
                                                          BINARY.
               08 TWR-END-DATE                PIC  9(05)  VALUE ZEROES
                                                          BINARY.
      *
           04  TYPE-FUNCTION                  PIC X       VALUE 'R'.
               88  RANDOM-RETRIEVAL                       VALUE 'R'.
               88  SEQUENTIAL-RETRIEVAL                   VALUE 'L'.
      *
      *  ADD SPECIAL FUNCTION CODE TO IGNORE PCS DRUG
      *  CLAIMS WHEN DOING SEQ CLAIM PROCESSING THRU EP 05 OF FX61.
      *  FX61 WILL RETRIEVE THE CLAIM KEY, EXAMINE THE PLAN
      *  CODE WITHIN, AND IF IT'S PLAN 089, AND THE USER HAS
      *  SET THIS FUNCTION CODE TO 'Z', THEN THAT CLAIM WILL
      *  BE IGNORED, AND THE NEXT SEQUENTIAL CLAIM WILL BE
      *  RETRIEVED.  THIS SHOULD SAVE SOME CPU TIME AS THE ENTIRE
      *  PCS CLAIM WILL NOT BE FORMATTED, JUST CLAIM KEY.
      *  DRUG CLAIMS ARE GOING OUT TO OUR F00040
      *  DATABASE BUT SHOULD NOT BE USED DURING REGULAR 'PLAN'
      *  CHARGE PROCESSING THAT P4M0 DOES THRU ENTRY PT 5.
      *  FUNCTION 'Z' IS ONLY VALID THRU ENTRY POINT 5 OF FX61.
      *
               88  SEQ-RET-IGNORE-DRUG-CLAIMS           VALUE 'Z'.
      *
               88  DUPLICATE-CLAIM-RETRIEVAL            VALUE 'C'.
      *%%% EL CMR# 387791 - END
      *
       01  PASSED-FIELDS.
      *
      *-----------------------------------------------------------------
      *  FOR FX85P0M0:
      *-----------------------------------------------------------------
      *
           04  TWR-LINE-NUMBER                PIC  9(03).
           04  CHG-SUB                        PIC S9(04)  BINARY.
           04  REASON                         PIC XXX.
           04  REASON-HOLD                    PIC XXX.
           04  CHARGE-STATUS                  PIC XX.

       01  K1-MESSAGE-LINE.
           04  PROV-ID-K1                PIC X(10).
           04  FILLER                    PIC X     VALUE SPACES.
           04  PROV-NAME-K1.
               08  PROV-LAST-NAME-K1     PIC X(8).
               08  PROV-FIRST-NAME-K1    PIC X(8).

       01  DATE-CONVERSION-FIELDS.

           05  MMDDCCYY-DATE.
               10  MMDDCCYY-MM                 PIC  9(02).
               10  MMDDCCYY-DD                 PIC  9(02).
               10  MMDDCCYY-CCYY               PIC  9(04).
               10  MMDDCCYY-CCYY-R             REDEFINES
                   MMDDCCYY-CCYY.
                   15  MMDDCCYY-CC             PIC  9(02).
                   15  MMDDCCYY-YY             PIC  9(02).

           05  FEP-CENTURY-DATE                PIC  9(05)  VALUE ZEROES.
      *
       01  NUMERIC-HOLD-FIELDS.
           04  HOLD-9-DIGIT-V99          PIC 9(7)V99  VALUE 0.
           04  HOLD-9-DIGIT-NUMERIC REDEFINES
               HOLD-9-DIGIT-V99          PIC 9(9).
      *%%% KX TT 84175 BEGIN
           04  HOLD-9-DIGIT-AN REDEFINES
               HOLD-9-DIGIT-V99          PIC X(9).
      *%%% KX TT 84175 END
           04  HOLD-8-DIGIT-V99          PIC 9(6)V99  VALUE 0.
           04  HOLD-8-DIGIT-NUMERIC REDEFINES
               HOLD-8-DIGIT-V99          PIC 9(8).
           04  HOLD-7-DIGIT-V99          PIC 9(5)V99  VALUE 0.
           04  HOLD-7-DIGIT-NUMERIC REDEFINES
               HOLD-7-DIGIT-V99          PIC 9(7).
           04  HOLD-6-DIGIT-V99          PIC 9(4)V99  VALUE 0.
           04  HOLD-6-DIGIT-NUMERIC REDEFINES
               HOLD-6-DIGIT-V99          PIC 9(6).
      *%%% KX TT 84175 BEGIN
           04  HOLD-6-DIGIT-AN REDEFINES
               HOLD-6-DIGIT-V99          PIC X(6).
      *%%% KX TT 84175 END
           04  HOLD-5-DIGIT-V99          PIC 9(3)V99  VALUE 0.
           04  HOLD-5-DIGIT-NUMERIC REDEFINES
               HOLD-5-DIGIT-V99          PIC 9(5).
           04  HOLD-4-DIGIT-NUMERIC      PIC 9(4).
           04  HOLD-3-DIGIT-NUMERIC      PIC 9(3).
           04  HOLD-2-DIGIT-V99          PIC V99      VALUE 0.
           04  HOLD-2-DIGIT-NUMERIC REDEFINES
               HOLD-2-DIGIT-V99          PIC 99.
      *
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      *  N1 SUPPORTING HISTORY
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      *
       01  N1-SUPPHIST-COMMAREA.
           05  N1-SUPPHIST-ERROR-RETURN.
               COPY FWG00211
                     REPLACING  ==:IO:==     BY ==SUPPHIST==.
           05  N1-SUPPHIST-RECORD            PIC X(2873).
      *
       01  AMOUNT-PAID-CRG                    PIC 9(7)V99.
       01  AMT-PD-CRG   REDEFINES
           AMOUNT-PAID-CRG.
           04  AMT-PD-CRG-PRT                 PIC X(9).
      *
       01  AMOUNT-PAID-CRG-NPAR               PIC 9(7)V99.
       01  AMT-PD-CRG-NPAR   REDEFINES
           AMOUNT-PAID-CRG-NPAR.
           04  AMT-PD-CRG-NPAR-PRT            PIC X(9).
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      *  FH02P6M0 PARAMETERS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      *
       01  FUNCTION-CODE                      PIC X     VALUE SPACES.
       01  ESRD-OR-INC-DATE                   PIC X(8)  VALUE ZEROS.
       01  DUMMY-REASON                       PIC XXX  VALUE LOW-VALUES.
       01  LINE-NUMBER                        PIC 9(03).
      *
       01  EVAL-EDIT-CODES-TBL.
           05  EVAL-EDIT-CODES.
               10  EVAL-EDIT-CODE-1.
                   15  EVAL-EDIT-IND-1         PIC  X(01).
                   15  EVAL-EDIT-CD-1          PIC  X(03).
               10  EVAL-EDIT-CODE-2.
                   15  EVAL-EDIT-IND-2         PIC  X(01).
                   15  EVAL-EDIT-CD-2          PIC  X(03).
               10  EVAL-EDIT-CODE-3.
                   15  EVAL-EDIT-IND-3         PIC  X(01).
                   15  EVAL-EDIT-CD-3          PIC  X(03).
               10  EVAL-EDIT-CODE-4.
                   15  EVAL-EDIT-IND-4         PIC  X(01).
                   15  EVAL-EDIT-CD-4          PIC  X(03).
               10  EVAL-EDIT-CODE-5.
                   15  EVAL-EDIT-IND-5         PIC  X(01).
                   15  EVAL-EDIT-CD-5          PIC  X(03).
           05  EVAL-EDIT-CODE-TABLE            REDEFINES
               EVAL-EDIT-CODES                 OCCURS 5 TIMES
                                               INDEXED BY EVAL-EDIT-IX.
               10  EVAL-EDIT-CODE.
                   15  EVAL-EDIT-IND           PIC  X(01).
                   15  EVAL-EDIT-CD            PIC  X(03).
                       88  EVAL-PCS-HOLD-HARMLESS      VALUE
                       '700' THRU '705' 'FCY'.
      *
      *
      ******************************************************************
      *
      *                       COPY FORMATS
      *
      ******************************************************************
      *
      *                   FX61 CLAIM RETRIEVAL DATA
       01  FILLER                           PIC X(8) VALUE 'FWG04190'.
      *
       COPY FWG04190.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-**-*-*-*-*-*
      *  CREATED NEW COPY FORMAT (FWG13807) TO PASS SECONDARY
      *   FIELDS BACK AND FORTH BETWEEN P5M2 AND P5M8.
      *
      *  HOLD AREA FOR ORIGINAL F00030 FIELDS BEFORE CALCULATING
      *  PRIMARY, WILL BE PASSED TO P5M8 TO ACCUMULATE SECONDARY
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-**-*-*-*-*-*
      *
      *                   HOLD SECONDARY FIELDS
      *
       01  FILLER                           PIC X(8) VALUE 'FWG13807'.
           COPY FWG13807.
      *
      *                      FX63 PARAMETERS
       01  FILLER                           PIC X(8) VALUE 'FWG04195'.
           COPY FWG04195.
      *                      ADJUSTMENT-REPORT-DATA
       01  FILLER                           PIC X(8) VALUE 'FWG05010'.
           COPY FWG05010.
      *                       AUXILIARY FIELDS HOLD A RECORD
       01  FILLER                           PIC X(8) VALUE 'HOLD AUX'.
           COPY FWG05000 REPLACING TWR-AUXILIARY-FIELDS BY
                                   HOLDA-AUXILIARY-FIELDS
                                   ==:TWR-AF:== BY ==HA-AF==.

      *                       INITIALIZE TWR
       01  FILLER                           PIC X(8) VALUE 'FWG06004'.
           COPY FWG06004.
      *                       INITIALIZE AUX FIELDS RECORD
       01  FILLER                           PIC X(8) VALUE 'FWG05007'.
           COPY FWG05007.
      *                       HOLD CHARGE LINE
       01  FILLER                           PIC X(8) VALUE 'FWG06005'.
           COPY FWG06005.
       01  FILLER                           PIC X(8) VALUE 'SUP HIST'.
       01  FILLER                           PIC X(8) VALUE 'WRK AREA'.
      *                       SUPPORTING HISTORY WORK RECORD
      *
      * WARNING...DO NOT ADD COPY FORMAT NAME FILLERS FOR FWG06008
      * FWG06009, FWG06140, FWG06150...THEY DO NOT START AT THE
      * 01 LEVEL. THAY START AT 04 AND EVEN 08 AND SOME ARE
      * REDEFINES OF A PREVIOUS COPY FORMAT.
      *
       01  SUPPORTING-HISTORY-WORK-RECORD.
      *                       SUPPORTING HISTORY WORK RECORD
           COPY FWG06008.
      *                       SUPPORTING HISTORY BASE RECORD
           COPY FWG06009.
      *                       SUPPORTING HISTORY N1 CALCULATION LINE
           COPY FWG06150.
      *                       SUPPORTING HISTORY N4 CALCULATION LINE
           COPY FWG06160.
      *
      *01  INITALIZE-N1-CALCULATION-LINE.
           COPY FWG06151.
      *01  INITALIZE-N4-CALCULATION-LINE.
           COPY FWG06161.
      *01  FH01-OVERRIDES-AREAS.
           COPY FWG13802.
      *01  F030-COMMON-NAMES.
           COPY FWG13804.
       01  BENEFIT-GROUP.
           COPY FWG00206.
       01  BENEFIT-GROUP-BA-ID.
           COPY FWG00209 REPLACING ==:BEN:== BY ==BEN==.
       01  BENEFIT-ADMN-PAY-LVL-TABLE.
           COPY FWG00215.
       01  PERF-PROVIDER-COPAY-TABLE.
           COPY FWG00216.
       01  TOTALS-ACCUMULATIONS.
           COPY FWG00218.
       01  PRIMARY-SUPPORTING-HIST-TAB.
           COPY FWG00219.
       01  SECOND-SUP-HIST-HOLD.
           COPY FWG00220.
       01  EDIT-SUPP-HIST-INFO.
           COPY FWG00207.

      *01  HOLD-DIAGNOSIS-CODE-TEMPX   USED FOR FV01P3M0 PARMS
           COPY FV01CC09 REPLACING ==:HDX:== BY ==TEMPX==.
      *%%% CWR CONTAINER DATA
           COPY FWG04192.

      *01  HOLD-DIAGNOSIS-CODE-FAC.
           COPY FV01CC09 REPLACING ==:HDX:== BY ==FAC==.
      *01  HOLD-DIAGNOSIS-CODE-PRO.
           COPY FV01CC09 REPLACING ==:HDX:== BY ==PRO==.
      *
      *%%% TT 48053 BEGIN                                               FH02P3M1
      *------------------------------------------------------------
      *    MHSA F00050 DELTA RECORD
      *------------------------------------------------------------
      *01  CA-F00050-TABLE.
             COPY FWG00052 REPLACING
                        F00050-TABLE
                  BY CA-F00050-TABLE
                        F00050-TABLE-MEMBER
                  BY CA-F00050-TABLE-MEMBER
                        F00050-TABLE-PROVIDER
                  BY CA-F00050-TABLE-PROVIDER
                        F00050-APPROVAL-BEGIN-DATE
                  BY CA-F00050-APPROVAL-BEGIN-DATE
                        F00050-APPROVAL-TYPE
                  BY CA-F00050-APPROVAL-TYPE
                        F00050-APPROVAL-END-DATE
                  BY CA-F00050-APPROVAL-END-DATE
                        F00050-TABLE-ALLOWED
                  BY CA-F00050-TABLE-ALLOWED
                        F00050-TABLE-USED
                  BY CA-F00050-TABLE-USED
                        F00050-TABLE-UPDATED-SW
                  BY CA-F00050-TABLE-UPDATED-SW
                        F00050-TREAT-PLAN-ID
                  BY CA-F00050-TREAT-PLAN-ID.
      *%%% TT 48053 END                                                 FH02P3M1
      *=================================================================
      *===   REAL TIME NEW COPY BOOKS.                              ====
      *=================================================================

      *01  FEP-MAF-PARAMETER-LIST.
           COPY FWG08312.

      *01  FEP-EXCEPTION-ERRORS.
           COPY FV11CC10.

      *01  BD-ERROR-REPORTING.
           COPY FH02CC01.

      *01  FV01P2M0-IN-PARMS.
           COPY FV01CC20.
      *TT#175671 BEGIN
      *01  FV02P1M0-IN-PARMS.
           COPY FV02CC10.
      *TT#175671 END
                                                                        FH02P3M6
      *%%% EL TT# 274033 - BEGIN
      *-------------------------------------------------------------*   FH02P2M1
      *                      DB2 DECLARATIONS                       *   FH02P2M1
      *-------------------------------------------------------------*   FH02P2M1
                                                                        FH02P2M1
           EXEC SQL                                                     FH02P2M1
                INCLUDE SQLCA                                           FH02P2M1
           END-EXEC.                                                    FH02P2M1
                                                                        FH02P2M1
           EXEC SQL                                                     FH02P2M1
                INCLUDE FMBWLPGM                                        FH02P2M1
           END-EXEC.                                                    FH02P2M1
                                                                        FH02P2M1
           EXEC SQL                                                     FH02P2M1
                INCLUDE FCTWLPGM                                        FH02P2M1
           END-EXEC.                                                    FH02P2M1
                                                                        FH02P2M1
           EXEC SQL                                                     FH02P2M1
                INCLUDE FWELLPGM                                        FH02P2M1
           END-EXEC.                                                    FH02P2M1
      *%%% EL TT# 274033 - END
      *%%% P7 TT# 983486 START
           EXEC SQL
                INCLUDE FMDCRMAX
           END-EXEC.
      *%%% P7 TT# 983486 END
      *=================================================================
      *===      LINKAGE SECTION
      *=================================================================
       LINKAGE SECTION.

       01  APPL-RETURN-AREA.
           COPY FWG00212.

       01  TRANSACTION-WORK-RECORD.
           COPY FWG06002 REPLACING ==:TWR:== BY ==TWR==.

      *01  TWR-AUXILIARY-FIELDS.
           COPY FWG05000 REPLACING ==:TWR-AF:== BY ==TWR-AF==.

       01  FAMILY-WORK-RECORD.
           COPY FWG03160 REPLACING ==:F:== BY ==FWR==.

       01  PATIENT-WORK-RECORD.
           COPY FWG03170 REPLACING ==:P:== BY ==PWR==.

       01  FH01-EXECUTIVE-DATA-FIELDS.
           COPY FWG00013.

       01  P0M3-EXECUTIVE-DATA-FIELDS.
           COPY FWG00018.

       01  COVERED-SERVICE-GROUP.
           COPY FWG00221.

      *01  F00050-TABLE.
           COPY FWG00052.

      * TT 48053 EE
      *01   MHSA-TREAT-PLAN-ARRAY
           COPY FWG00055.

       01  TRANSACTION-ORG-RECORD.
           COPY FWG06002 REPLACING ==:TWR:== BY ==ORG==.

       01  CONTINUE-PROCESSING-SW        PIC X   VALUE 'Y'.
           88  CONTINUE-PROCESSING               VALUE 'Y'.
           88  SKIP-PROCESSING                   VALUE 'N'.

       01  TRANSACTION-DISP-3-RECORD.
           COPY FWG06002 REPLACING ==:TWR:== BY ==D-3==.

      *                       TRANSACTION COB RECORD
       01  TRANSACTION-COB-RECORD.
           COPY FWG06002 REPLACING ==:TWR:== BY ==COB==.

      *--  TRANSACTION PRI RECORD
       01  TRANSACTION-PRI-RECORD.
           COPY FWG06002 REPLACING ==:TWR:== BY ==PRI==.

      *01  CLAIM-WORK-RECORD.
           COPY FWG04030.

      *=================================================================
      *===      PROCEDURE DIVISION
      *=================================================================
       PROCEDURE DIVISION  USING  APPL-RETURN-AREA
                                  TRANSACTION-WORK-RECORD
                                  TWR-AUXILIARY-FIELDS
                                  FAMILY-WORK-RECORD
                                  PATIENT-WORK-RECORD
                                  FH01-EXECUTIVE-DATA-FIELDS
                                  P0M3-EXECUTIVE-DATA-FIELDS
                                  COVERED-SERVICE-GROUP
                                  F00050-TABLE
                                  TRANSACTION-ORG-RECORD
                                  CONTINUE-PROCESSING-SW
      *%%% EE TT# 48053 - BEGIN
                                  TRANSACTION-DISP-3-RECORD
      *%%% EE TT# 48053 - END
                                  MHSA-TREAT-PLAN-ARRAY
                                  TRANSACTION-COB-RECORD
                                  TRANSACTION-PRI-RECORD.

      *=================================================================
      *===      MAINLINE
      *=================================================================
       0000-MAINLINE.

           PERFORM 1000-TRANS-INITIALIZATION THRU 1000-EXIT

           IF  VOID-D4-TWR
      *%%% EL TT 18735 - BEGIN
           OR  IS-SUBROGATION-ADJUSTMENT
           OR  PREV-WAS-SUBROGATED
      *%%% EL TT 18735 - END
               CONTINUE
           ELSE
               PERFORM 1300-OPL-SAVINGS THRU 1300-EXIT
           END-IF

           IF  PROCESS-PERIOD-NOT-ON-FILE
               PERFORM 4000-TIMELY-FILING THRU 4000-EXIT
                  VARYING TWR-CRG-SUB FROM 1 BY 1
                  UNTIL TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR
           ELSE
               IF ((ORIGINAL-D1-TWR OR ADJUSTMENT-D2-TWR)
                    AND (PROCESS-CODE-TWR = 'I' OR 'J'))
      *%%% KX TT 49146 - BEGIN
      *        OR (INTERIM-BILL-D6-TWR
      *            AND (PROCESS-CODE-TWR = 'E' OR 'I'))
      *%%% KX TT 49146 - END
                   CONTINUE
               ELSE
                   PERFORM 2999-PERF-PROV-COPAY-TABLE THRU 2999-EXIT
               END-IF

               PERFORM 2000-CHARGE-PROCESSING THRU 2000-EXIT
                  VARYING TWR-CRG-SUB FROM 1 BY 1
                  UNTIL TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR

               IF  PRODUCE-N4-LINES
               AND TOTAL-REJECTED-CHARGES < NUMBER-OF-CHARGES-TWR
               AND OC-CALCULATED
               AND (NO-ERRORS
                    OR REJECT-THIS-CHARGE
                    OR ANY-REJ-AFFECTED-CHRG-TWR (TWR-CRG-SUB))
                   PERFORM 1100-PRIM-SEC-DETERMINATION
                      THRU 1100-EXIT
               END-IF
           END-IF

      *%%% EL TT 9223 BEGIN
           EVALUATE TRUE
             WHEN CURR-PROCESS-PERIOD
             WHEN PR-1-PROCESS-PERIOD
             WHEN PR-2-PROCESS-PERIOD
               PERFORM 9600-RESET-CAT-MAX-IND THRU 9600-EXIT
           END-EVALUATE
      *%%% EL TT 9223 END

           IF  VOID-D4-TWR
               CONTINUE
           ELSE
      *%%% PE TT 34821 BEGIN
               PERFORM 1145-PROFESSIONAL-NPA-RELIEF THRU 1145-EXIT
      *%%% PE TT 34821 END
      *%%% PE TT 37520 42698 R2 2005
               IF PHARMACY-TWR AND (PROCESSING-CODE-TWR =
                    '5O' OR '3C')
                 CONTINUE
               ELSE
                 PERFORM 1200-GENERATE-REMARKS THRU 1200-EXIT
               END-IF
      *%%% KJ TT 44644 BEGIN
      *%%% EL TT 18735 - BEGIN
      *        IF  NOT-SUBROGATION-ADJUSTMENT
      *        AND PREV-NOT-SUBROGATED
      *            PERFORM 1400-CALC-SUB-LIABILITY THRU 1400-EXIT
      *        END-IF
      *%%% EL TT 18735 - END
      *%%% KJ TT 44644 BEGIN

               PERFORM 5000-FINALIZATION THRU 5000-EXIT
           END-IF
           .
       0000-GOBACK.
           GOBACK.

       1000-TRANS-INITIALIZATION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            INITIALIZATION PER CLAIM
      *  THIS SECTION IS PERFORMED ONCE FOR EACH CLAIM, BEFORE
      *  ANY OTHER PROCESSING OCCURS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *
           INITIALIZE     COB-CHG-LINE-REJECT-SW
                          MEDICARE-AND-COB-SW
                          TOTALS-ACCUMULATIONS
                          BENEFIT-GROUP
                          DCTB-ADMN-PER-CLM-ACCUM
      *%%% CMR 358583 KJ
                          COPAY-GP-PER-CLM-ACCUM
                          COPAY-ADMN-PER-CLM-ACCUM
      *%%% KJ TT 3509 BEGIN
                          COPAY-MAX-PER-ADMN-DAYS-ACCUM
      *%%% KJ TT 3509 END
      *%%% EL TT# 3720 BEGIN
                          VADOD-AMOUNT-PAID-ACCUM
      *%%% EL TT# 3720 END
      *%%% EL TT# 7539 BEGIN
                          ECF-SNF-HIST-TOTAL-PAID
                          ECF-SNF-CURR-TOTAL-PAID
      *%%% EL TT# 7539 END
      *%%% EL TT# 1171411 - BEGIN
                          COPAY-MAT-PER-CLM-ACCUM
      *%%% EL TT# 1171411 - END

           SET FIRST-CHARGE-THRU               TO TRUE
           SET PERF-PROV-NEED-HISTORY          TO TRUE
           SET PERF-PROV-NO-UPDATE-COPAY       TO TRUE
           SET VAMED-NEED-HISTORY              TO TRUE
           SET NO-VAMED-CHARGE                 TO TRUE
           SET PRIMARY-CALC                    TO TRUE
      *
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *  THE SECONDARY-SWITCH HAS FOUR POSITIONS.  THE FIRST APPLIES
      *  TO MEDICARE, THE SECOND TO WORKERS COMP,  THE 3RD TO REGULAR
      *  COB AND THE LAST TO SUBROGATION.
      *  A '1' IN A POSITION MEANS THAT TYPE OF SECONDARY COVERAGE
      *  IS APPLICABLE FOR THAT CHARGE.  IT IS POSSIBLE TO HAVE MORE
      *  THAN ONE TYPE OF SECONDARY COVERAGE PER CHARGE!
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           MOVE ZEROS TO SECONDARY-SWITCH
      *
           INITIALIZE   HOLD-PROCESS-SEQ
                        OTH-BENEFIT-PRD-F030
                        OTH-BENE-PERIOD-YEAR-OPTION

           INITIALIZE   CHARGE-UPDATED-PATIENT-SW
                        CHARGE-UPDATED-FAMILY-SW
                        FAMILY-UPDATED-P0M3-SW
                        PATIENT-UPDATED-P0M3-SW
                        SMOKE-ON-CHRG-SW
                        SUPP-HISTORY-WRITTEN-SW
                        WRITE-FH0113-RECORD-SWITCH
                        OTH-DEDUCT-STATUS-BYTES
                        ERROR-REASON
                        ERROR-REASON-ACTION
                        PROCESS-SW
      *
           INITIALIZE   TOTAL-DEF-CHARGES
                        REDUCTION-AMOUNT
                        TOTAL-COB-APP-CHGS-PRIME
                        TOTAL-COB-APP-CHGS-SEC
                        TOTAL-REJECTED-CHARGES
                        TOTAL-REJ-DISP6-CHARGES
      *%%% EL TT# 274033 - BEGIN
                        MBR-WELL-DED-CREDIT
                        CON-WELL-DED-CREDIT

           IF  STD-OPTION-CONTRACT-TWR
               PERFORM 1005-GET-MBR-WELL-DED-CR
                  THRU 1005-EXIT
               PERFORM 1010-GET-CON-WELL-DED-CR
                  THRU 1010-EXIT
           END-IF
      *%%% EL TT# 274033 - END

      *
      *-----------------------------------------------------------------
      *    SET UP THE SHBR AND SHWR ONCE FOR EACH TRANSACTION.  THESE
      *    AREAS APPLY TO SUPPORTING HISTORY.  THE SHWR IS THE 73-BYTE
      *    SORTWORD, THE SHBR IS THE BASE FOR THE SUPPORTING HISTORY
      *    LINE ITSELF.
      *-----------------------------------------------------------------
      *
           MOVE SPACES TO SORTWORD-SHWR
           MOVE REPORTING-PLAN-CODE-TWR TO REPORTING-PLAN-CODE-SHBR
                                           REPORTING-PLAN-CODE-SHWR
           MOVE BATCH-CREATION-DATE-TWR TO BATCH-CREATION-DATE-SHWR
           MOVE BATCH-DATE-TWR TO BATCH-DATE-SHWR
      *
      *
           MOVE BATCH-SEQUENCE-NUMBER-TWR TO BATCH-SEQUENCE-NUMBER-SHWR
      *
      *
           MOVE CONTRACT-ID-NUMBER-TWR TO CONTRACT-ID-NUMBER-SHBR
                                          CONTRACT-ID-NUMBER-SHWR
           MOVE CLAIM-NUMBER-TWR TO CLAIM-NUMBER-SHWR
                                    CLAIM-NUMBER-SHBR
           MOVE CLAIM-TYPE-TWR TO TRANS-TYPE-SHWR
           MOVE CLAIM-TRANSACTION-ID-TWR  TO TRANSACTION-ID-SHBR
           MOVE CLAIM-AFFECTING-TS-TWR    TO AFFECTING-TS-SHBR
           MOVE DATE-PROCESSED-CENT-TWR   TO FEP-CENTURY-DATE
           PERFORM 9700-CONVERT-FEP-CENTURY-DT
              THRU 9700-EXIT
           MOVE MMDDCCYY-DATE             TO PROCESSING-DT-SHBR
           MOVE CLAIM-OC-BATCH-ID-TWR     TO OC-BATCH-ID-SHBR
      *
      *----------------------------------------------------------------
      *    MOVE ADMISSION SWITCH SET IN P4M0 TO P0M3-EXECUTIVE-DATA-
      *    FIELDS SO IT WILL BE AVAILABLE IN SUBSEQUENT CALLS TO P5M7.
      *----------------------------------------------------------------
      *
           MOVE FH01-ADMISSION-1990-SW TO P0M3-ADMISSION-1990-SW

      ***  SET PROCESSING SWITCH
           EVALUATE  TRUE
             WHEN DISP1-1STEP-OC-CALC-TWR
             WHEN DISP2-1STEP-OC-CALC-TWR
      *%%% KX TT 49146 - BEGIN
      *      WHEN DISP6-1STEP-OC-CALC-TWR
      *%%% KX TT 49146 - BEGIN
               SET  OC-CALCULATED                          TO TRUE
             WHEN PLAN-APPROVED-CLAIM-TWR
               SET  PLAN-APPROVED                          TO TRUE
             WHEN DISP1-PCS-RECAP-TWR
             WHEN MAIL-ORDER-DRUG-PGM-TWR
               SET  DRUGS-PCS                              TO TRUE
             WHEN OTHER
               SET  PLAN-CALCULATED                        TO TRUE
           END-EVALUATE

      *%%% EL TT 18735 - BEGIN
           SET NOT-SUBROGATION-ADJUSTMENT TO TRUE
           SET PREV-NOT-SUBROGATED TO TRUE
      *%%% EL TT 18735 - END

      * %% FO CLE:
           PERFORM VARYING TWR-CRG-SUB FROM 1 BY 1
      ****    UNTIL TWR-CRG-SUB > 40
              UNTIL TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR
      * %% FO CLE END
      *%%% EL TT 18735 - BEGIN
                 IF  ADJUSTMENT-D2-TWR
                     IF  APPROVED-CHRG-TWR (TWR-CRG-SUB)
                     AND (APOC1-SUBROGATION-TWR (TWR-CRG-SUB)
                          OR APOC2-SUBROGATION-TWR (TWR-CRG-SUB))
      *%%% PE TT 28077- BEGIN
                     AND TWR-CRG-SUB IS NOT GREATER THAN
                       NUMBER-OF-CHARGES-TWR
      *%%% PE TT 28077- END
                         SET IS-SUBROGATION-ADJUSTMENT TO TRUE
                     END-IF
                     IF  HISTORY-CHRG-APPROVED-D-3 (TWR-CRG-SUB)
                     AND (APOC1-SUBROGATION-D-3 (TWR-CRG-SUB)
                          OR APOC2-SUBROGATION-D-3 (TWR-CRG-SUB))
                         SET PREV-WAS-SUBROGATED TO TRUE
                     END-IF
                 END-IF
      *%%% EL TT 18735 - END

                 INITIALIZE POSITIVE-SAVINGS-AMOUNT (TWR-CRG-SUB)
                            NEGATIVE-SAVINGS-AMOUNT (TWR-CRG-SUB)
                            TOTAL-SAVINGS-AMOUNT (TWR-CRG-SUB)
                            MEDICARE-SAVINGS-AMOUNT (TWR-CRG-SUB)
                            GENERATE-REMARKS-COPAY-SW (TWR-CRG-SUB)
      *%%% EL TT# 184100 - BEGIN
                            CWM-ELIGIBILITY-SW (TWR-CRG-SUB)
      *%%% EL TT# 184100 - END
      *%%% PE TT  347464 - BEGIN
                            PREV-PAY-IN-FULL-SW (TWR-CRG-SUB)
      *%%% PE TT  347363 - END
      *%%% EL TT# 10505/13172 BEGIN
                 MOVE CVRD-CHRGS-ALL-SERVS-CP-P0M3 (TWR-CRG-SUB)
                   TO CVRD-CHRGS-ALL-SERVS-CCT (TWR-CRG-SUB)
      *%%% EL TT# 4725 BEGIN
                 MOVE MEDICARE-LIMIT-CHGS-P0M3 (TWR-CRG-SUB)
                   TO MEDICARE-LIMIT-CHGS-CCT (TWR-CRG-SUB)
      *%%% EL TT# 4725 END
                 MOVE LINE-NUMBER-P0M3 (TWR-CRG-SUB)
                   TO LINE-NUMBER-CCT (TWR-CRG-SUB)
      *%%% EL TT# 10505/13172 END
           END-PERFORM

      *%%% EL TT# 10505/13172 BEGIN
           PERFORM VARYING TWR-CRG-SUB FROM 1 BY 1
            UNTIL TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR
              SET CC-NDX TO 1
              SEARCH CVRD-CHRGS-TABLE
                AT END CONTINUE
                WHEN LINE-NUMBER-AN-TWR (TWR-CRG-SUB) =
                     LINE-NUMBER-CCT (CC-NDX)
                    MOVE LINE-NUMBER-CCT (CC-NDX)
                      TO LINE-NUMBER-P0M3(TWR-CRG-SUB)
                    MOVE CVRD-CHRGS-ALL-SERVS-CCT (CC-NDX)
                      TO CVRD-CHRGS-ALL-SERVS-CP-P0M3 (TWR-CRG-SUB)
      *%%% EL TT# 4725 BEGIN
                    MOVE MEDICARE-LIMIT-CHGS-CCT (CC-NDX)
                      TO MEDICARE-LIMIT-CHGS-P0M3 (TWR-CRG-SUB)
      *%%% EL TT# 4725 END
              END-SEARCH
           END-PERFORM
      *%%% EL TT# 10505/13172 END
      *%%% EL TT# 585337 - BEGIN
           PERFORM VARYING SUB1 FROM 1 BY 1
              UNTIL SUB1 > 100
              INITIALIZE CONTRACEPTIVE-DATE (SUB1)
           END-PERFORM
      *%%% EL TT# 585337 - END
      *%%% EK TT# 15738 BEGIN
            PERFORM
               VARYING TWR-CRG-SUB FROM 1 BY 1
                 UNTIL TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR

            MOVE SH-LINE-INITIALIZE
              TO COB-PRIME-LINE (TWR-CRG-SUB)
            MOVE SH-LINE-INITIALIZE
              TO COB-SECOND-LINE (TWR-CRG-SUB)

      *%%% EL TT# 585337 - BEGIN
            MOVE FEP-SERVICE-ID-TWR (TWR-CRG-SUB)
              TO HOLD-FEP-SERVICE-ID-P0M3

            EVALUATE TRUE
              WHEN OTPAT-INSTITUTE-TYPE-CLAIM-TWR (TWR-CRG-SUB)
               AND (SERVICE-BEGIN-DATE-CENT-TWR (TWR-CRG-SUB) >=
                    JAN-01-2013)
               AND (PREFERRED-PROVIDER-TWR (TWR-CRG-SUB)
                    OR ALT-PREFERRED-PROVIDER-TWR (TWR-CRG-SUB))
               AND CONTRACEPTIVE-SERVICE-ID
                PERFORM 1020-LOAD-CONTRACEPTIVE-DATES
                   THRU 1020-EXIT
            END-EVALUATE
      *%%% EL TT# 585337 - BEGIN
           END-PERFORM
           INITIALIZE     TWR-CRG-SUB
      *%%% EK TT# 15738 END
           .
       1000-EXIT.
           EXIT.

      *%%% EL TT# 274033 - BEGIN
       1005-GET-MBR-WELL-DED-CR.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   RETRIEVE THE MEMBER WELLNESS DEDUCTIBLE CREDIT
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      ***************************************************************** FH02P2M1
      * MOVING VALUES INTO HOST VARIABLES TO SEARCH MBR_WELL_PGM_ENRL   FH02P2M1
      * WELLNESS_PGM FOR THE MEMBER WELLNESS DEDUCTIBLE CREDIT          FH02P2M1
      ***************************************************************** FH02P2M1
                                                                        FH02P2M1
           MOVE MEMBER-ID-TWR                                           FH02P2M1
             TO MEMBER-ID                  OF DCLMBR-WELL-PGM-ENRL      FH02P2M1
           MOVE '08'                                                    FH02P2M1
             TO WELLNESS-PGM-CD            OF DCLMBR-WELL-PGM-ENRL      FH02P2M1
                                                                        FH02P2M1
           MOVE CLM-BEGIN-MONTH-TWR        TO WS-DB2HOLD-MONTH          FH02P2M1
           MOVE CLM-BEGIN-DAY-TWR          TO WS-DB2HOLD-DAY            FH02P2M1
           MOVE CLM-BEGIN-YEAR4-TWR        TO WS-DB2HOLD-YEAR4          FH02P2M1
           MOVE WS-DB2HOLD-DATE                                         FH02P2M1
             TO WELL-ENRL-EFF-DT           OF DCLMBR-WELL-PGM-ENRL      FH02P2M1

           MOVE 'M'                                                     FH02P2M1
             TO WELL-PGM-LEVEL-CD          OF DCLWELLNESS-PGM           FH02P2M1
                                                                        FH02P2M1
      ***************************************************************** FH02P2M1
      * DB2 SELECTING OF MEMBER WELLNESS DEDUCTIBLE CREDIT FROM         FH02P2M1
      * THE WELLNESS TABLES.                                            FH02P2M1
      ***************************************************************** FH02P2M1
                                                                        FH02P2M1
           EXEC SQL                                                     FH02P2M1
                SELECT                                                  FH02P2M1
                  A.MEMBER_ID                                           FH02P2M1
                 ,A.WELLNESS_PGM_CD                                     FH02P2M1
                 ,A.WELL_ENRL_EFF_DT                                    FH02P2M1
                 ,A.WELL_ENRL_TERM_DT                                   FH02P2M1
                 ,B.WELL_PGM_AWARD_AMT                                  FH02P2M1
                 ,B.WELL_PGM_LEVEL_CD                                   FH02P2M1
                INTO                                                    FH02P2M1
                  :DCLMBR-WELL-PGM-ENRL.MEMBER-ID
                 ,:DCLMBR-WELL-PGM-ENRL.WELLNESS-PGM-CD
                 ,:DCLMBR-WELL-PGM-ENRL.WELL-ENRL-EFF-DT
                 ,:DCLMBR-WELL-PGM-ENRL.WELL-ENRL-TERM-DT
                 ,:DCLWELLNESS-PGM.WELL-PGM-AWARD-AMT
                 ,:DCLWELLNESS-PGM.WELL-PGM-LEVEL-CD
                FROM                                                    FH02P2M1
                  MBR_WELL_PGM_ENRL A INNER JOIN                        FH02P2M1
                  WELLNESS_PGM B                                        FH02P2M1
                  ON B.WELLNESS_PGM_CD = A.WELLNESS_PGM_CD              FH02P2M1
                WHERE                                                   FH02P2M1
                  A.MEMBER_ID = :DCLMBR-WELL-PGM-ENRL.MEMBER-ID         FH02P2M1
                  AND A.WELLNESS_PGM_CD =                               FH02P2M1
                      :DCLMBR-WELL-PGM-ENRL.WELLNESS-PGM-CD
                  AND B.WELL_PGM_LEVEL_CD =                             FH02P2M1
                      :DCLWELLNESS-PGM.WELL-PGM-LEVEL-CD
                  AND :DCLMBR-WELL-PGM-ENRL.WELL-ENRL-EFF-DT BETWEEN
                       A.WELL_ENRL_EFF_DT AND A.WELL_ENRL_TERM_DT
           END-EXEC                                                     FH02P2M1
                                                                        FH02P2M1
           MOVE SQLCODE                    TO SQL-SQLCODE               FH02P2M1
                                                                        FH02P2M1
           EVALUATE  TRUE                                               FH02P2M1
             WHEN SQL-SUCCESS                                           FH02P2M1
               MOVE WELL-PGM-AWARD-AMT     OF DCLWELLNESS-PGM           FH02P2M1
                 TO MBR-WELL-DED-CREDIT                                 FH02P2M1
             WHEN SQL-NOTFND                                            FH02P2M1
               CONTINUE                                                 FH02P2M1
             WHEN OTHER                                                 FH02P2M1
               MOVE 1005                 TO WS-V-ERROR-PARA
               SET MBR-WELL-PGM-ENRL-TBL TO TRUE
               PERFORM 1015-OTHER-DB2-ERROR                             FH02P2M1
                  THRU 1015-EXIT                                        FH02P2M1
           END-EVALUATE                                                 FH02P2M1
           .
       1005-EXIT.
           EXIT.

       1010-GET-CON-WELL-DED-CR.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   RETRIEVE THE CONTRACT WELLNESS DEDUCTIBLE CREDIT
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      ***************************************************************** FH02P2M1
      * MOVING VALUES INTO HOST VARIABLES TO SEARCH CONTRACT_WELL_PGM   FH02P2M1
      * FOR THE CONTRACT WELLNESS DEDUCTIBLE CREDIT                     FH02P2M1
      ***************************************************************** FH02P2M1
                                                                        FH02P2M1
           MOVE CONTRACT-ID-NUMBER-TWR (8:1)                            FH02P2M1
             TO PARTITION                  OF DCLCONTRACT-WELL-PGM      FH02P2M1
           MOVE CONTRACT-ID-NUMBER-TWR (2:8)                            FH02P2M1
             TO CONTRACT-ID                OF DCLCONTRACT-WELL-PGM      FH02P2M1
           MOVE '08'                                                    FH02P2M1
             TO WELLNESS-PGM-CD            OF DCLCONTRACT-WELL-PGM      FH02P2M1
                                                                        FH02P2M1
           MOVE CLM-BEGIN-MONTH-TWR        TO WS-DB2HOLD-MONTH          FH02P2M1
           MOVE CLM-BEGIN-DAY-TWR          TO WS-DB2HOLD-DAY            FH02P2M1
           MOVE CLM-BEGIN-YEAR4-TWR        TO WS-DB2HOLD-YEAR4          FH02P2M1
           MOVE WS-DB2HOLD-DATE                                         FH02P2M1
             TO CTRCT-WELL-EFF-DT  OF DCLCONTRACT-WELL-PGM              FH02P2M1

      ***************************************************************** FH02P2M1
      * DB2 SELECTING OF CONTRACT WELLNESS DEDUCTIBLE CREDIT FROM       FH02P2M1
      * THE CONTRACT_WELL_PGM TABLE.                                    FH02P2M1
      ***************************************************************** FH02P2M1
                                                                        FH02P2M1
           EXEC SQL                                                     FH02P2M1
           SELECT
             A."PARTITION"
             ,A.CONTRACT_ID
             ,A.WELLNESS_PGM_CD
             ,A.CTRCT_WELL_EFF_DT
             ,A.CTRCT_WELL_TRM_DT
             ,A.CTRCT_WELL_PGM_CNT
             ,A.CTRCT_WELL_AWARD_AMT
           INTO                                                         FH02P2M1
             :DCLCONTRACT-WELL-PGM.PARTITION
            ,:DCLCONTRACT-WELL-PGM.CONTRACT-ID
            ,:DCLCONTRACT-WELL-PGM.WELLNESS-PGM-CD
            ,:DCLCONTRACT-WELL-PGM.CTRCT-WELL-EFF-DT
            ,:DCLCONTRACT-WELL-PGM.CTRCT-WELL-TRM-DT
            ,:DCLCONTRACT-WELL-PGM.CTRCT-WELL-PGM-CNT
            ,:DCLCONTRACT-WELL-PGM.CTRCT-WELL-AWARD-AMT
           FROM
             CONTRACT_WELL_PGM A
           WHERE
             A."PARTITION" = :DCLCONTRACT-WELL-PGM.PARTITION
             AND A.CONTRACT_ID = :DCLCONTRACT-WELL-PGM.CONTRACT-ID
             AND A.WELLNESS_PGM_CD = '08'
             AND :DCLCONTRACT-WELL-PGM.CTRCT-WELL-EFF-DT BETWEEN
                 A.CTRCT_WELL_EFF_DT AND A.CTRCT_WELL_TRM_DT
           END-EXEC

           MOVE SQLCODE                    TO SQL-SQLCODE               FH02P2M1
                                                                        FH02P2M1
           EVALUATE  TRUE                                               FH02P2M1
             WHEN SQL-SUCCESS                                           FH02P2M1
               MOVE CTRCT-WELL-AWARD-AMT OF DCLCONTRACT-WELL-PGM        FH02P2M1
                 TO CON-WELL-DED-CREDIT                                 FH02P2M1
             WHEN SQL-NOTFND                                            FH02P2M1
               CONTINUE                                                 FH02P2M1
             WHEN OTHER                                                 FH02P2M1
               MOVE 1010                 TO WS-V-ERROR-PARA
               SET CONTRACT-WELL-PGM-TBL TO TRUE
               PERFORM 1015-OTHER-DB2-ERROR                             FH02P2M1
                  THRU 1015-EXIT                                        FH02P2M1
           END-EVALUATE                                                 FH02P2M1
           .
       1010-EXIT.
           EXIT.
                                                                        FH02P2M1
       1015-OTHER-DB2-ERROR.                                            FH02P2M1
      ******************************************************************FH02P2M1
      * DISPLAY ERROR MESSAGE & DEFER FOR REASON FPB/FP8                FH02P2M1
      ******************************************************************FH02P2M1
           MOVE 'DB2 ERROR HAS OCCURED'                                 FH02P2M1
             TO WS-V-MESSAGE-2                                          FH02P2M1
           SET FEP-MAF-DB2-SOFTWARE  TO TRUE                            FH02P2M1
           SET FEP-MAF-EXCPT-INFORMATIONAL TO TRUE
           SET SELECT-ROW            TO TRUE                            FH02P2M1
           MOVE SQL-SQLCODE                                             FH02P2M1
             TO WS-V-SQL-CODE                                           FH02P2M1
           PERFORM 9880-ERROR-RTN
              THRU 9880-EXIT
           MOVE 'FP8'               TO ERROR-REASON
           SET CANNOT-PROCESS-THIS-CHARGE TO TRUE
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .                                                            FH02P2M1
       1015-EXIT.                                                       FH02P2M1
           EXIT.                                                        FH02P2M1
      *%%% EL TT# 274033 - END

      *%%% EL TT# 585337 - BEGIN
       1020-LOAD-CONTRACEPTIVE-DATES.                                   FH02P2M1
      ******************************************************************FH02P2M1
      * LOAD UP TO 100 CONTRACEPTIVE DATES                              FH02P2M1
      ******************************************************************FH02P2M1
           SET LOAD-IS-NOT-COMPLETE TO TRUE
           PERFORM VARYING SUB1 FROM 1 BY 1                             FH02P2M1
             UNTIL SUB1 > 100                                           FH02P2M1
                OR LOAD-IS-COMPLETE                                     FH02P2M1
              EVALUATE TRUE                                             FH02P2M1
                WHEN CONTRACEPTIVE-DATE (SUB1) = ZEROES                 FH02P2M1
                  MOVE SERVICE-BEGIN-DATE-CENT-TWR (TWR-CRG-SUB)        FH02P2M1
                    TO CONTRACEPTIVE-DATE (SUB1)
                  SET LOAD-IS-COMPLETE TO TRUE
                WHEN CONTRACEPTIVE-DATE (SUB1) =                        FH02P2M1
                     SERVICE-BEGIN-DATE-CENT-TWR (TWR-CRG-SUB)          FH02P2M1
                  SET LOAD-IS-COMPLETE TO TRUE
                WHEN OTHER                                              FH02P2M1
                  CONTINUE
              END-EVALUATE
           END-PERFORM
           .                                                            FH02P2M1
       1020-EXIT.                                                       FH02P2M1
           EXIT.                                                        FH02P2M1
      *%%% EL TT# 585337 - END
       1100-PRIM-SEC-DETERMINATION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            MAKE DECISION ON HOW FEP WILL PAY
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           IF  APPROVED-CLAIM-TWR
           SET FH02P3MA-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
      *
                                          DUMMY-COMMAREA
                                          APPL-RETURN-AREA
                                          TRANSACTION-WORK-RECORD
                                          TWR-AUXILIARY-FIELDS
                                          P0M3-EXECUTIVE-DATA-FIELDS
                                          TOTALS-ACCUMULATIONS
                                          HOLDA-AUXILIARY-FIELDS
                                          TRANSACTION-COB-RECORD
                                          TOTAL-DEF-CHARGES
                                          PATIENT-WORK-RECORD
      *%%% EL TT# 86219/89136 - BEGIN
                                          LIFETIME-HOLD
      *%%% EL TT# 86219/89136 - END
                    ON EXCEPTION
                    MOVE 1100                 TO WS-V-ERROR-PARA
                    SET FEP-MAF-CICS-SOFTWARE TO TRUE
                    SET CALL-PGM              TO TRUE
                    PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
               END-CALL
               PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
               IF  PRIMARY-CALC
                   PERFORM 9500-CROSSFOOT-CHARGE THRU 9500-EXIT
                      VARYING TWR-CRG-SUB FROM 1 BY 1
                         UNTIL TWR-CRG-SUB >  NUMBER-OF-CHARGES-TWR
                   PERFORM 1110-WRITE-PRIMARY-SH THRU 1110-EXIT
                      VARYING TWR-CRG-SUB FROM 1 BY 1
                         UNTIL TWR-CRG-SUB > PRIMARY-NO-OF-CHARGES
                   IF  TOTAL-COB-APP-CHGS-SEC > ZERO
                       PERFORM 1120-FORMAT-SECONDARY-N4
                          THRU 1120-EXIT
                   END-IF
               END-IF
               IF  SECONDARY-CALC
                   PERFORM 9500-CROSSFOOT-CHARGE THRU 9500-EXIT
                      VARYING TWR-CRG-SUB FROM 1 BY 1
                         UNTIL TWR-CRG-SUB >  NUMBER-OF-CHARGES-TWR
                   PERFORM 1130-WRITE-SECONDARY-SH THRU 1130-EXIT
                      VARYING TWR-CRG-SUB FROM 1 BY 1
                         UNTIL TWR-CRG-SUB > SECONDARY-NO-OF-CHARGES
      *            IF  SPEC-ZERO-PAID
      *                CONTINUE
      *            ELSE
                       IF  TOTAL-COB-APP-CHGS-PRIME > ZERO
                           PERFORM 1140-FORMAT-PRIMARY-N4
                              THRU 1140-EXIT
                       END-IF
      *            END-IF
               END-IF
           ELSE
               IF  DEFERRED-CLAIM-TWR
                   PERFORM VARYING TWR-CRG-SUB FROM 1 BY 1
                      UNTIL TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR
                         IF ANY-APP-AFFECTED-CHRG-TWR (TWR-CRG-SUB-HA)
                             MOVE PENDING-STATUS
                               TO CHARGE-STATUS-TWR (TWR-CRG-SUB-HA)
                         END-IF
                   END-PERFORM
               END-IF
           END-IF
           .
       1100-EXIT.
           EXIT.

       1110-WRITE-PRIMARY-SH.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *  WRITE THE PRIMARY SUPPORTING HISTORY LINES, IF 9999 IN LINE, IT
      *  INDICATES A DUMMY RECORD, SO DO NOT WRITE THIS LINE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           IF  SUB-ID-NO-PRIME (TWR-CRG-SUB) = ALL-NINES
               GO TO 1110-EXIT
           END-IF

           MOVE PRIMARY-SH-LINE (TWR-CRG-SUB)
             TO SUPPORTING-HISTORY-WORK-RECORD

      *%%% TT390460   HIPAA 5010 BEGIN
           MOVE HIPAA-VERSION-CODE-TWR
             TO HIPAA-VERSION-CODE-N1
      *%%% TT390460   HIPAA 5010 END

           PERFORM 9280-CALL-FX85-WRITE-HIST THRU 9280-EXIT

           MOVE INIT-N1-CALC-LINE TO SH-CALCULATION-N1-RECORD
           .
       1110-EXIT.
           EXIT.
      *
       1120-FORMAT-SECONDARY-N4.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *  FORMAT AND WRITE THE N4 LINE WITH SECONDARY CALCULATIONS
      *  INITIALIZATION MUST BE DONE HERE SINCE THE N4, N1
      *  LINES REDEFINE EACH OTHER.  WE CAN'T INITIALIZE UNTIL WE
      *  KNOW EXACTLY WHICH FORMAT WE ARE GOING TO CREATE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           MOVE INIT-N4-CALC-LINE    TO SH-COB-CALCULATION-N4-RECORD
           MOVE '70'                 TO SUPP-HIST-STATUS-SHWR
           MOVE 'N4'                 TO LINE-CODE-SHBR
           MOVE SPACES               TO SEQUENCE-NUMBER-N4
           MOVE PROCESSING-CODE-TWR  TO PROCESSING-CODE-N4
           MOVE 'S'                  TO PRIME-SECOND-IND-N4
      *
      *   THE SENDING FIELDS BELOW ARE BINARY NON-INTEGER FIELDS
      *   AND FINAL RECEIVING FILEDS ARE ALPHANUMERIC.  COBOL 2
      *   WILL NOT ALLOW A DIRECT MOVE FROM BINARY TO ALPHA AS IT
      *   VIOLATES THE MOVE COMPATIBILITY RULES.
      *   MUST MOVE THE BINARY TO A NUMERIC FIRST.
      *
           MOVE TOTAL-ALLOWABLE-CHARGES
             TO HOLD-9-DIGIT-V99
           MOVE HOLD-9-DIGIT-NUMERIC
             TO TOTAL-COB-ALLOWED-CHGS-N4
           MOVE TOTAL-AMT-PD-OTHER-CARR
             TO HOLD-9-DIGIT-V99
           MOVE HOLD-9-DIGIT-NUMERIC
             TO AMT-PD-OTHER-CARR-1-AN-N4
           MOVE TOTAL-COB-AMT-PD-SECONDARY
             TO HOLD-9-DIGIT-V99
           MOVE HOLD-9-DIGIT-NUMERIC
             TO TOTAL-COB-AMT-PAID-N4
           MOVE TOTAL-ANNUAL-DEDUCT-PRIMARY
      *%%% KX TT 84175 BEGIN
             TO HOLD-6-DIGIT-V99
           MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
             TO TOTAL-COB-DEDUCTIBLE-N4
           MOVE TOTAL-ADMISS-DEDUCT-PRIMARY
      *%%% KX TT 84175 BEGIN
             TO HOLD-6-DIGIT-V99
           MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
             TO COB-ADMISSION-DEDUCT-N4
           MOVE TOTAL-COINS-AMT-PRIMARY
             TO HOLD-7-DIGIT-V99
           MOVE HOLD-7-DIGIT-NUMERIC
             TO TOTAL-COB-COINS-N4
           MOVE TOTAL-DENTAL-AMOUNT
             TO HOLD-8-DIGIT-V99
           MOVE HOLD-8-DIGIT-NUMERIC
             TO REIMBURSEMENT-AMOUNT-N4
           MOVE TOTAL-REJ-AMT-SECONDARY
             TO HOLD-8-DIGIT-V99
           MOVE HOLD-8-DIGIT-NUMERIC
             TO REJECTION-AMOUNT-N4
      *%%% TT283828   HIPAA 5010 BEGIN
           MOVE HIPAA-VERSION-CODE-TWR
             TO HIPAA-VERSION-CODE-N4
      *%%% TT283828   HIPAA 5010 END

           PERFORM 9280-CALL-FX85-WRITE-HIST THRU 9280-EXIT
           .
       1120-EXIT.
           EXIT.

       1130-WRITE-SECONDARY-SH.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *  WRITE THE SECONDARY SUPPORTING HISTORY LINES, IF 9999 IN LINE,
      *  INDICATES A DUMMY RECORD, SO DO NOT WRITE THIS LINE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           IF  SUB-ID-NO-SECOND (TWR-CRG-SUB) = ALL-NINES
               GO TO 1130-EXIT
           END-IF

           MOVE SECONDARY-SH-LINE (TWR-CRG-SUB)
             TO SUPPORTING-HISTORY-WORK-RECORD

      *%%% TT390460   HIPAA 5010 BEGIN
           MOVE HIPAA-VERSION-CODE-TWR
             TO HIPAA-VERSION-CODE-N1
      *%%% TT390460   HIPAA 5010 END

           PERFORM 9280-CALL-FX85-WRITE-HIST THRU 9280-EXIT

           MOVE INIT-N1-CALC-LINE TO SH-CALCULATION-N1-RECORD
           .
       1130-EXIT.
           EXIT.

       1140-FORMAT-PRIMARY-N4.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *  FORMAT AND WRITE THE N4 LINE WITH PRIMARY CALCULATIONS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           MOVE INIT-N4-CALC-LINE    TO SH-COB-CALCULATION-N4-RECORD.
           MOVE '70'                 TO SUPP-HIST-STATUS-SHWR.
           MOVE 'N4'                 TO LINE-CODE-SHBR
           MOVE SPACES               TO SEQUENCE-NUMBER-N4
           MOVE PROCESSING-CODE-TWR  TO PROCESSING-CODE-N4
           MOVE 'T'                  TO PRIME-SECOND-IND-N4

      *   THE SENDING FIELDS BELOW ARE BINARY NON-INTEGER FIELDS
      *   AND FINAL RECEIVING FILEDS ARE ALPHANUMERIC.  COBOL 2
      *   WILL NOT ALLOW A DIRECT MOVE FROM BINARY TO ALPHA AS IT
      *   VIOLATES THE MOVE COMPATIBILITY RULES.
      *   MUST MOVE THE BINARY TO A NUMERIC FIRST.

           MOVE TOTAL-ALLOWABLE-CHARGES
             TO HOLD-9-DIGIT-V99
           MOVE HOLD-9-DIGIT-NUMERIC
             TO TOTAL-COB-ALLOWED-CHGS-N4
           MOVE TOTAL-AMT-PD-OTHER-CARR
             TO HOLD-9-DIGIT-V99
           MOVE HOLD-9-DIGIT-NUMERIC
             TO AMT-PD-OTHER-CARR-1-AN-N4
           MOVE TOTAL-COB-AMT-PD-PRIMARY
             TO HOLD-9-DIGIT-V99
           MOVE HOLD-9-DIGIT-NUMERIC
             TO TOTAL-COB-AMT-PAID-N4

           MOVE TOTAL-ANNUAL-DEDUCT-PRIMARY
      *%%% KX TT 84175 BEGIN
             TO HOLD-6-DIGIT-V99
           MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
             TO TOTAL-COB-DEDUCTIBLE-N4
           MOVE TOTAL-ADMISS-DEDUCT-PRIMARY
      *%%% KX TT 84175 BEGIN
             TO HOLD-6-DIGIT-V99
           MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
             TO COB-ADMISSION-DEDUCT-N4
           MOVE TOTAL-COINS-AMT-PRIMARY
             TO HOLD-7-DIGIT-V99
           MOVE HOLD-7-DIGIT-NUMERIC
             TO TOTAL-COB-COINS-N4
           MOVE TOTAL-DENTAL-AMOUNT
             TO HOLD-8-DIGIT-V99
           MOVE HOLD-8-DIGIT-NUMERIC
             TO REIMBURSEMENT-AMOUNT-N4
           MOVE TOTAL-REJ-AMT-PRIMARY
             TO HOLD-8-DIGIT-V99
           MOVE HOLD-8-DIGIT-NUMERIC
             TO REJECTION-AMOUNT-N4
      *%%% TT283828   HIPAA 5010 BEGIN
           MOVE HIPAA-VERSION-CODE-TWR
             TO HIPAA-VERSION-CODE-N4
      *%%% TT283828   HIPAA 5010 END

           PERFORM 9280-CALL-FX85-WRITE-HIST THRU 9280-EXIT
           .
       1140-EXIT.
           EXIT.

      *%%% PE TT 34821 BEGIN                                            FH02P0M3
       1145-PROFESSIONAL-NPA-RELIEF.                                    FH02P0M3
      *%%% PE TT 91691
      *%%% H4 TT 1062761
               IF PHARMACY-TWR                OR
                  TELEHEALTH-VENDOR-PLAN-TWR
                  GO TO 1145-EXIT.
               INITIALIZE NON-PAR-SVNGS-ACCUM
                          NON-PAR-SVNGS-ACCUM-DISP2
               MOVE 'N' TO NON-PAR-MAX-SW
               MOVE 'N' TO FZD-OVERRIDE-SW
               MOVE 'N' TO FNW-OVERRIDE-SW
               MOVE 'N' TO DEFER-FNW-SW
      *%%% PE TT57321 R2/2006 BEGIN
               MOVE 'N' TO A2-SAVINGS-SW
      *%%% PE TT70177 OC2 2007 BEGIN
               MOVE 'N' TO OBRA93-SW
               PERFORM 1146-OBRA93-CHECK THRU
                       1146-EXIT VARYING OBRA-SUB FROM 1 BY 1
                       UNTIL OBRA-SUB > NUMBER-OF-CHARGES-TWR
                       IF OBRA93-PRICING-ON-CLM
                        GO TO 1145-EXIT
                       END-IF
      *%%% PE TT70177 OC2 2007 END
               PERFORM 1151-A2-SAVINGS-CHECK THRU
                       1151-EXIT VARYING NP-SUB FROM 1 BY 1
                       UNTIL NP-SUB > NUMBER-OF-CHARGES-TWR
                      IF (CLM-EDIT-OVERRIDE-CODE-1-TWR =
                        'BFNW' OR 'BFZD'
                       OR CLM-EDIT-OVERRIDE-CODE-2-TWR =
                        'BFNW' OR 'BFZD'
                       OR CLM-EDIT-OVERRIDE-CODE-3-TWR =
                         'BFNW' OR 'BFZD'
                       OR CLM-EDIT-OVERRIDE-CODE-4-TWR =
                         'BFNW' OR 'BFZD'
                       OR CLM-EDIT-OVERRIDE-CODE-5-TWR =
                         'BFNW' OR 'BFZD')
                       AND NO-A2-SAVINGS-ON-CLM
                       SET DEFER-THIS-CHARGE TO TRUE
                       MOVE R-FNW TO ERROR-REASON
      *%%% EL TT# 915663 - BEGIN
                       PERFORM 9970-CLAIM-ERROR-ROUTINE
      *%%% EL TT# 915663 - END
                       GO TO 1145-EXIT
                      END-IF
                     PERFORM 1150-NON-PAR-RELIEF THRU 1150-EXIT
                      VARYING NP-SUB FROM 1 BY 1
                      UNTIL NP-SUB > NUMBER-OF-CHARGES-TWR
                     IF (NON-PAR-SVNGS-ACCUM > NON-PAR-MAX OR
                        NON-PAR-SVNGS-ACCUM-DISP2 > NON-PAR-MAX)
                      AND NOT YES-FZD-OVERRIDE
                      AND NOT YES-FNW-OVERRIDE
      *%%% PE TT 715518                                                 FH02P0M3
                      AND (ADMISSION-FND OR EROOM-FND)
                       SET DEFER-THIS-CHARGE TO TRUE
                       MOVE R-FNW TO ERROR-REASON
      *%%% EL TT# 915663 - BEGIN
                       PERFORM 9970-CLAIM-ERROR-ROUTINE
      *%%% EL TT# 915663 - END
      *%%% PE TT57321 R2/2006 END                                       FH02P0M3
               ELSE
                   IF  (NON-PAR-SVNGS-ACCUM > NON-PAR-MAX
                        AND YES-FZD-OVERRIDE
                        AND ORIGINAL-D1-TWR)
                   OR  (NON-PAR-SVNGS-ACCUM-DISP2 > NON-PAR-MAX
                        AND YES-FZD-OVERRIDE
                        AND ADJUSTMENT-D2-TWR)
                       PERFORM 1156-RECALC-AMT-PAID THRU 1156-EXIT
                       VARYING NP3-SUB FROM 1 BY 1
                         UNTIL NP3-SUB > NUMBER-OF-CHARGES-TWR
                            OR NON-PAR-MAX-MET
                   ELSE
                       IF  (ORIGINAL-D1-TWR AND NON-PAR-SVNGS-ACCUM
                             < NON-PAR-MAX)
                           AND (CLM-EDIT-OVERRIDE-CODE-1-TWR = 'BFNW'
                                   OR 'BFZD'
                                OR CLM-EDIT-OVERRIDE-CODE-2-TWR = 'BFNW'
                                   OR 'BFZD'
                                OR CLM-EDIT-OVERRIDE-CODE-3-TWR = 'BFNW'
                                   OR 'BFZD'
                                OR CLM-EDIT-OVERRIDE-CODE-4-TWR = 'BFNW'
                                   OR 'BFZD'
                                OR CLM-EDIT-OVERRIDE-CODE-5-TWR = 'BFNW'
                                   OR 'BFZD')
                               PERFORM 1157-REMOVE-BFNW-OVERRIDE
                                  THRU 1157-EXIT
      *%%% PE TT 38875 BEGIN                                            FH02P0M3
                               PERFORM 1158-REMOVE-BFNW-CHARGELINE
                                 THRU 1158-EXIT VARYING NP6-SUB
                                 FROM 1 BY 1 UNTIL NP6-SUB >
                                  NUMBER-OF-CHARGES-TWR
      *%%% PE TT 38875 END                                              FH02P0M3
                       ELSE
                         IF (ADJUSTMENT-D2-TWR AND
                            NON-PAR-SVNGS-ACCUM-DISP2 < NON-PAR-MAX)
                           AND (CLM-EDIT-OVERRIDE-CODE-1-TWR = 'BFNW'
                                   OR 'BFZD'
                                OR CLM-EDIT-OVERRIDE-CODE-2-TWR = 'BFNW'
                                   OR 'BFZD'
                                OR CLM-EDIT-OVERRIDE-CODE-3-TWR = 'BFNW'
                                   OR 'BFZD'
                                OR CLM-EDIT-OVERRIDE-CODE-4-TWR = 'BFNW'
                                   OR 'BFZD'
                                OR CLM-EDIT-OVERRIDE-CODE-5-TWR = 'BFNW'
                                   OR 'BFZD')
                               PERFORM 1157-REMOVE-BFNW-OVERRIDE
                                  THRU 1157-EXIT
      *%%% PE TT 38875 BEGIN                                            FH02P0M3
                               PERFORM 1158-REMOVE-BFNW-CHARGELINE
                                  THRU 1158-EXIT VARYING NP6-SUB
                                  FROM 1 BY 1 UNTIL NP6-SUB >
                                  NUMBER-OF-CHARGES-TWR
      *%%% PE TT 38875 END                                              FH02P0M3
                         END-IF
                       END-IF
                   END-IF
               END-IF
           .
       1145-EXIT.
           EXIT.

      *%%% PE TT70177 BEGIN
       1146-OBRA93-CHECK.                                               FH02P0M3
           IF APPROVED-CHRG-TWR(OBRA-SUB)
             IF OBRA93-OFMA-OVERRIDE-TWR(OBRA-SUB) OR
                OBRA93-OFMB-OVERRIDE-TWR(OBRA-SUB) OR
                OBRA93-OFMC-OVERRIDE-TWR(OBRA-SUB)
                SET OBRA93-PRICING-ON-CLM TO TRUE
             END-IF
           END-IF.
       1146-EXIT.
           EXIT.
      *%%% PE TT70177 END

       1150-NON-PAR-RELIEF.                                             FH02P0M3
      *%%% PE TT 51162
           MOVE 'N' TO NPAR-RELIEF-SW3(NP-SUB).
           IF  FAC-TYPE-OF-BILL-TWR = SPACES
             AND CLM-BEGIN-DATE-CENT-TWR > 56613
            IF APPROVED-CHRG-TWR(NP-SUB)
      *%%% PE TT47138 R2 2005 END
             AND NON-PAR-PROVIDER-TWR(NP-SUB)
             AND NOT (PROVIDERS-OFFICE-TWR(NP-SUB) OR
                     PATIENTS-HOME-TWR(NP-SUB) OR
                     SKILLED-NURSING-FAC-TWR(NP-SUB) OR
                     NURSING-FAC-TWR(NP-SUB))
             AND (TS1-NON-PAR-TWR(NP-SUB) OR
                 TS2-NON-PAR-TWR(NP-SUB) OR
                 TS3-NON-PAR-TWR(NP-SUB) OR
                 TS4-NON-PAR-TWR(NP-SUB))
      *%%% PE TT 715518 BEGIN
                 PERFORM 1152-SET-UP-HISTORY THRU
                  1152-SET-UP-HISTORY-EXIT
                 PERFORM 1152-CALL-FX61 THRU
                  1152-CALL-FX61-EXIT UNTIL
                    NO-MATCHING-RECORD OR
                    END-OF-PATIENT-FILE
      *%%% PE TT 715518 END
                 PERFORM 1155-CALC-NON-PAR-RELIEF
                 THRU 1155-EXIT
            END-IF
           END-IF
           .                                                            FH02P0M3
       1150-EXIT.                                                       FH02P0M3
           EXIT.                                                        FH02P0M3
           .                                                            FH02P0M3
      *%%% PE TT57321 R2/2006 BEGIN                                     FH02P0M3
       1151-A2-SAVINGS-CHECK.                                           FH02P0M3
           IF APPROVED-CHRG-TWR(NP-SUB)
             IF (CLM-EDIT-OVERRIDE-CODE-1-TWR = 'BFNW' OR
                              'BFZD'
                 OR CLM-EDIT-OVERRIDE-CODE-2-TWR =
                       'BFNW' OR 'BFZD'
                 OR CLM-EDIT-OVERRIDE-CODE-3-TWR =
                       'BFNW' OR 'BFZD'
                 OR CLM-EDIT-OVERRIDE-CODE-4-TWR =
                       'BFNW' OR 'BFZD'
                 OR CLM-EDIT-OVERRIDE-CODE-5-TWR =
                       'BFNW' OR 'BFZD')
             AND (TS1-NON-PAR-TWR(NP-SUB)
                  OR TS2-NON-PAR-TWR(NP-SUB)
                  OR TS3-NON-PAR-TWR(NP-SUB)
                  OR TS4-NON-PAR-TWR(NP-SUB))
              SET A2-SAVINGS-ON-CLM TO TRUE
             END-IF
           END-IF
           .                                                            FH02P0M3
       1151-EXIT.                                                       FH02P0M3
           EXIT.                                                        FH02P0M3
           .                                                            FH02P0M3
      *%%% PE TT 715518 BEGIN                                           FH02P0M3
       1152-SET-UP-HISTORY.
           MOVE 1152 TO WS-V-ERROR-PARA
           MOVE 00 TO FX61-RESULT-CODE
           MOVE ID-NUMBER-TWR TO FX61-CLM-RETRIEVAL-DATA
           MOVE PATIENT-CODE-TWR TO FX61-PATIENT-CODE
           MOVE CLM-END-DATE-CENT-TWR TO FEP-CENTURY-DATE
           PERFORM 9700-CONVERT-FEP-CENTURY-DT
           MOVE CLM-BEGIN-YEAR-TWR TO
                              FX61-BEGIN-YEAR
           ADD 1 TO FX61-BEGIN-YEAR
           MOVE ZEROS TO FX61-ZERO-FILL
           MOVE REPORTING-PLAN-CODE-NUM-TWR TO
                               FX61-PLAN-CODE
           MOVE CLAIM-NUMBER-TWR TO FX61-CLAIM-NUMBER
           SET SEQ-RET-IGNORE-DRUG-CLAIMS TO TRUE
           .                                                            FH02P0M3
       1152-SET-UP-HISTORY-EXIT.                                        FH02P0M3
           EXIT.                                                        FH02P0M3
       1152-CALL-FX61.
           INITIALIZE TWR-BEGIN-AND-END-DATES                           FH02P0M3
      *%%% CWR CONTAINERS BEGIN
           MOVE 'FH02-CWR-CHANNEL' TO CWR-CHANNEL-NAME
           MOVE 'FH02-CWR-CONTNR' TO CWR-CONTAINER-NAME
      *    MOVE 'FH11P7M1' TO WS-S-CALL2-MODULE
      *%%% CWR CONTAINERS END
           SET FX60P0M1-MODULE       TO TRUE

           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      FX61-RESULT-CODE
                                      TYPE-FUNCTION
                                      FX61-CLM-RETRIEVAL-DATA
                                      CWR-CONTAINER-DATA
                                      FX61-PROCESS-YEAR
                                      TWR-BEGIN-AND-END-DATES
      *%%% EL CMR# 387791 - END
                ON EXCEPTION
                   MOVE 9966                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           .
      *
      *%%% KX CMR 387791 - BEGIN

           IF  VALID-RESULT-CODE
               SET ADDRESS OF CLAIM-WORK-RECORD
                           TO CWR-CONTAINER-PTR
           ELSE
               SET   PROG-MSG                    TO  TRUE
               SET   FEP-MAF-EXCPT-WARNING       TO TRUE
               SET   FEP-MAF-OTHER-SOFTWARE      TO TRUE
               MOVE  2000              TO FEP-MAF-EXCPT-MSG-ID-SUFFIX
               MOVE  SPACES            TO WS-V-ERR-MESSAGE-TEXT
      *
               EVALUATE TRUE
                   WHEN INVALID-PARM
                        MOVE INVALID-PARM-MESSAGE
                          TO WS-V-ERR-MESSAGE-TEXT
                   WHEN OTHER
                        MOVE FX61-RESULT-CODE
                          TO DATA-LAYER-RC
                        MOVE TYPE-FUNCTION
                          TO DATA-LAYER-FC
                        MOVE INVALID-RC-MESSAGE
                          TO WS-V-ERR-MESSAGE-TEXT
               END-EVALUATE
      *
               PERFORM 9880-ERROR-RTN
                  THRU 9880-EXIT
           END-IF.
           MOVE LOW-VALUES TO FX61-BEGIN-DATE-R.
           IF NO-MATCHING-RECORD OR END-OF-PATIENT-FILE OR
              ADMISSION-FND OR EROOM-FND
              GO TO 1152-CALL-FX61-EXIT.
           IF REPORTING-PLAN-CODE-NUM-TWR =
                             PLAN-CODE-CK-CWR
            AND CLAIM-NUMBER-TWR = CLAIM-NUMBER-CK-CWR
            AND PATIENT-CODE-TWR = PATIENT-CODE-CK-CWR
               GO TO 1152-CALL-FX61-EXIT.
           IF ORIGINAL-PAID-CLAIM-CLS-CWR OR
             ADJUSTED-CLAIM-CLS-CWR
             SET ADMISSION-NOT-FND TO TRUE
             SET EROOM-NOT-FND TO TRUE
             PERFORM 1152-CHECK-HIST
                THRU 1152-CHECK-HIST-EXIT
                 VARYING NP1-SUB FROM 1 BY 1
                 UNTIL NP1-SUB > NUMBER-OF-CHARGES-CLS-CWR OR
                   ADMISSION-FND OR EROOM-FND
           END-IF.
       1152-CALL-FX61-EXIT.                                             FH02P0M3
           EXIT.                                                        FH02P0M3
       1152-CHECK-HIST.
           IF INPAT-INSTI-TYPE-CLAIM-CHS-CWR(NP1-SUB)
           AND (PERF-PROV-NETWRK-STAT-CHS-CWR(NP1-SUB) = 'P1' OR 'P2')
           AND (SERVICE-BEGIN-DATE-CENT-TWR(NP-SUB) IS NOT LESS THAN
                 INCURRED-FROM-DATE-CHS-CWR(NP1-SUB))
           AND (SERVICE-END-DATE-CENT-TWR(NP-SUB) IS NOT GREATER THAN
                   DISCHARGE-TO-DATE-CHS-CWR(NP1-SUB))
                SET ADMISSION-FND TO TRUE
           ELSE
              IF OUTPT-INSTI-TYPE-CLAIM-CHS-CWR(NP1-SUB)
               AND (SERVICE-BEGIN-DATE-CENT-TWR(NP-SUB) =
                     INCURRED-FROM-DATE-CHS-CWR(NP1-SUB))
               AND (SERVICE-END-DATE-CENT-TWR(NP-SUB) =
                     DISCHARGE-TO-DATE-CHS-CWR(NP1-SUB))
               AND RC-EMERGENCY-RM-SERV-CHS-CWR(NP1-SUB)
                    SET EROOM-FND TO TRUE
              END-IF
           END-IF.
       1152-CHECK-HIST-EXIT.                                            FH02P0M3
           EXIT.                                                        FH02P0M3
      *%%% PE TT 715518 END                                             FH02P0M3
      *%%% PE TT57321 R2/2006 END                                       FH02P0M3
       1155-CALC-NON-PAR-RELIEF.
           IF ORIGINAL-D1-TWR
            IF TS1-NON-PAR-TWR(NP-SUB)
             AND SAVINGS-AMOUNT-1-CP-TWR(NP-SUB) > 0
             ADD SAVINGS-AMOUNT-1-CP-TWR(NP-SUB) TO
              NON-PAR-SVNGS-ACCUM
            ELSE
             IF TS2-NON-PAR-TWR(NP-SUB)
               AND SAVINGS-AMOUNT-2-CP-TWR(NP-SUB) > 0
               ADD SAVINGS-AMOUNT-2-CP-TWR(NP-SUB) TO
                 NON-PAR-SVNGS-ACCUM
             ELSE
              IF TS3-NON-PAR-TWR(NP-SUB)
                AND SAVINGS-AMOUNT-3-CP-TWR(NP-SUB) > 0
                 ADD SAVINGS-AMOUNT-3-CP-TWR(NP-SUB) TO
                  NON-PAR-SVNGS-ACCUM
              ELSE
                IF TS4-NON-PAR-TWR(NP-SUB)
                  AND SAVINGS-AMOUNT-4-CP-TWR(NP-SUB) > 0
                   ADD SAVINGS-AMOUNT-4-CP-TWR(NP-SUB) TO
                   NON-PAR-SVNGS-ACCUM
                END-IF
              END-IF
             END-IF
            END-IF
           END-IF
           IF ADJUSTMENT-D2-TWR
            IF TS1-NON-PAR-TWR(NP-SUB)
             AND NON-PAR-PROV-SAVINGS-TWR(NP-SUB) > 0
             ADD NON-PAR-PROV-SAVINGS-TWR(NP-SUB) TO
               NON-PAR-SVNGS-ACCUM-DISP2
            ELSE
             IF TS2-NON-PAR-TWR(NP-SUB)
              AND NON-PAR-PROV-SAVINGS-TWR(NP-SUB) > 0
              ADD NON-PAR-PROV-SAVINGS-TWR(NP-SUB) TO
               NON-PAR-SVNGS-ACCUM-DISP2
             ELSE
              IF TS3-NON-PAR-TWR(NP-SUB)
               AND NON-PAR-PROV-SAVINGS-TWR(NP-SUB) > 0
               ADD NON-PAR-PROV-SAVINGS-TWR(NP-SUB) TO
               NON-PAR-SVNGS-ACCUM-DISP2
              ELSE
               IF TS4-NON-PAR-TWR(NP-SUB)
                AND NON-PAR-PROV-SAVINGS-TWR(NP-SUB) > 0
                ADD NON-PAR-PROV-SAVINGS-TWR(NP-SUB) TO
                NON-PAR-SVNGS-ACCUM-DISP2
               END-IF
              END-IF
             END-IF
            END-IF
           END-IF
           IF (CLM-EDIT-OVERRIDE-CODE-1-TWR = 'BFZD' OR
               CLM-EDIT-OVERRIDE-CODE-2-TWR = 'BFZD' OR
               CLM-EDIT-OVERRIDE-CODE-3-TWR = 'BFZD' OR
               CLM-EDIT-OVERRIDE-CODE-4-TWR = 'BFZD' OR
               CLM-EDIT-OVERRIDE-CODE-5-TWR = 'BFZD')
               SET YES-FZD-OVERRIDE TO TRUE
           END-IF
                                                                        FH02P0M3
           IF (CLM-EDIT-OVERRIDE-CODE-1-TWR = 'BFNW' OR
               CLM-EDIT-OVERRIDE-CODE-2-TWR = 'BFNW' OR
               CLM-EDIT-OVERRIDE-CODE-3-TWR = 'BFNW' OR
               CLM-EDIT-OVERRIDE-CODE-4-TWR = 'BFNW' OR
               CLM-EDIT-OVERRIDE-CODE-5-TWR = 'BFNW')
               SET YES-FNW-OVERRIDE TO TRUE
           END-IF
           .                                                            FH02P0M3
       1155-EXIT.                                                       FH02P0M3
           EXIT.                                                        FH02P0M3
           .                                                            FH02P0M3
       1156-RECALC-AMT-PAID.
           IF TS1-NON-PAR-TWR(NP3-SUB)
             COMPUTE NPAR-AMT-REMAIN =
               NON-PAR-MAX - NON-PAR-SAV-ACCUM
             IF NPAR-AMT-REMAIN > 0
                IF SAVINGS-AMOUNT-1-CP-TWR(NP3-SUB) =
                     NPAR-AMT-REMAIN
                   SET NON-PAR-MAX-MET TO TRUE
                   MOVE ZEROES TO NON-PAR-SAV-ACCUM
                   PERFORM VARYING NP4-SUB FROM 1 BY 1 UNTIL
                     NP4-SUB > NUMBER-OF-CHARGES-TWR
                    IF NP4-SUB > NP3-SUB
                      IF NOT YES-NPAR-RELIEF(NP4-SUB)
                       IF TS1-NON-PAR-TWR(NP4-SUB)
                        ADD SAVINGS-AMOUNT-1-CP-TWR(NP4-SUB) TO
                        AMOUNT-PAID-CP-TWR(NP4-SUB)
                        MOVE AMOUNT-PAID-CP-TWR(NP4-SUB) TO
                        AMOUNT-PAID-CRG-NPAR
                        MOVE AMT-PD-CRG-NPAR-PRT TO
                           AMOUNT-PAID-TWR(NP4-SUB)
                        MOVE ZEROES TO
                         SAVINGS-AMOUNT-1-CP-TWR(NP4-SUB)
                        MOVE SPACES TO SAVINGS-AMOUNT-1-TWR(NP4-SUB)
                        SET YES-NPAR-RELIEF(NP4-SUB) TO TRUE
                        MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                        MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                       END-IF
                      END-IF
                    END-IF
                   END-PERFORM
                ELSE
                  IF SAVINGS-AMOUNT-1-CP-TWR(NP3-SUB) > NPAR-AMT-REMAIN
                    COMPUTE NP-RECALC-AMT =
                    SAVINGS-AMOUNT-1-CP-TWR(NP3-SUB) -
                      NPAR-AMT-REMAIN
                   ADD NP-RECALC-AMT TO AMOUNT-PAID-CP-TWR(NP3-SUB)
                   MOVE AMOUNT-PAID-CP-TWR(NP3-SUB) TO
                    AMOUNT-PAID-CRG-NPAR
                   MOVE AMT-PD-CRG-NPAR-PRT TO
                     AMOUNT-PAID-TWR(NP3-SUB)
                   MOVE NPAR-AMT-REMAIN TO
                              SAVINGS-AMOUNT-1-CP-TWR(NP3-SUB)
                   SET NON-PAR-MAX-MET TO TRUE
                   MOVE ZEROES TO AMT-PD-CRG-NPAR
                   MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                   SET YES-NPAR-RELIEF(NP3-SUB) TO TRUE
                   MOVE ZEROES TO NON-PAR-SAV-ACCUM
                    PERFORM VARYING NP4-SUB FROM 1 BY 1 UNTIL
                      NP4-SUB > NUMBER-OF-CHARGES-TWR
                     IF NP4-SUB > NP3-SUB
                      IF NOT YES-NPAR-RELIEF(NP4-SUB)
                       IF TS1-NON-PAR-TWR(NP4-SUB)
                        ADD SAVINGS-AMOUNT-1-CP-TWR(NP4-SUB)
                         TO AMOUNT-PAID-CP-TWR(NP4-SUB)
                        MOVE AMOUNT-PAID-CP-TWR(NP4-SUB) TO
                         AMOUNT-PAID-CRG-NPAR
                        MOVE AMT-PD-CRG-NPAR-PRT TO
                          AMOUNT-PAID-TWR(NP4-SUB)
                        MOVE ZEROES TO
                         SAVINGS-AMOUNT-1-CP-TWR(NP4-SUB)
                        MOVE SPACES TO SAVINGS-AMOUNT-1-TWR(NP4-SUB)
                        SET YES-NPAR-RELIEF(NP4-SUB) TO TRUE
                        MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                        MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                       END-IF
                      END-IF
                     END-IF
                    END-PERFORM
                   MOVE ZEROES TO NP-RECALC-AMT
                  ELSE
                    IF SAVINGS-AMOUNT-1-CP-TWR(NP3-SUB) <
                      NPAR-AMT-REMAIN
                      ADD SAVINGS-AMOUNT-1-CP-TWR(NP3-SUB) TO
                         NON-PAR-SAV-ACCUM
                    END-IF
                  END-IF
                END-IF
             END-IF
           END-IF.
           IF TS2-NON-PAR-TWR(NP3-SUB)
             COMPUTE NPAR-AMT-REMAIN =
               NON-PAR-MAX - NON-PAR-SAV-ACCUM
             IF NPAR-AMT-REMAIN > 0
                IF SAVINGS-AMOUNT-2-CP-TWR(NP3-SUB) =
                     NPAR-AMT-REMAIN
                   SET NON-PAR-MAX-MET TO TRUE
                   MOVE ZEROES TO NON-PAR-SAV-ACCUM
                   PERFORM VARYING NP4-SUB FROM 1 BY 1 UNTIL
                     NP4-SUB > NUMBER-OF-CHARGES-TWR
                    IF NP4-SUB > NP3-SUB
                     IF NOT YES-NPAR-RELIEF(NP4-SUB)
                      IF TS2-NON-PAR-TWR(NP4-SUB)
                       ADD SAVINGS-AMOUNT-2-CP-TWR(NP4-SUB) TO
                       AMOUNT-PAID-CP-TWR(NP4-SUB)
                       MOVE AMOUNT-PAID-CP-TWR(NP4-SUB) TO
                         AMOUNT-PAID-CRG-NPAR
                       MOVE AMT-PD-CRG-NPAR-PRT TO
                         AMOUNT-PAID-TWR(NP4-SUB)
                       MOVE ZEROES TO
                        SAVINGS-AMOUNT-2-CP-TWR(NP4-SUB)
                       SET YES-NPAR-RELIEF(NP4-SUB) TO TRUE
                       MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                       MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                      END-IF
                     END-IF
                    END-IF
                   END-PERFORM
                ELSE
                  IF SAVINGS-AMOUNT-2-CP-TWR(NP3-SUB) > NPAR-AMT-REMAIN
                    COMPUTE NP-RECALC-AMT =
                    SAVINGS-AMOUNT-2-CP-TWR(NP3-SUB) -
                      NPAR-AMT-REMAIN
                   ADD NP-RECALC-AMT TO AMOUNT-PAID-CP-TWR(NP3-SUB)
                   MOVE AMOUNT-PAID-CP-TWR(NP3-SUB) TO
                       AMOUNT-PAID-CRG-NPAR
                   MOVE AMT-PD-CRG-NPAR-PRT TO
                     AMOUNT-PAID-TWR(NP3-SUB)
                   MOVE NPAR-AMT-REMAIN TO
                              SAVINGS-AMOUNT-2-CP-TWR(NP3-SUB)
                   SET NON-PAR-MAX-MET TO TRUE
                   SET YES-NPAR-RELIEF(NP3-SUB) TO TRUE
                   MOVE ZEROES TO NON-PAR-SAV-ACCUM
                   MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                   MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                    PERFORM VARYING NP4-SUB FROM 1 BY 1 UNTIL
                      NP4-SUB > NUMBER-OF-CHARGES-TWR
                     IF NP4-SUB > NP3-SUB
                      IF NOT YES-NPAR-RELIEF(NP4-SUB)
                       IF TS2-NON-PAR-TWR(NP4-SUB)
                        ADD SAVINGS-AMOUNT-2-CP-TWR(NP4-SUB)
                         TO AMOUNT-PAID-CP-TWR(NP4-SUB)
                         MOVE AMOUNT-PAID-CP-TWR(NP4-SUB) TO
                           AMOUNT-PAID-CRG-NPAR
                         MOVE AMT-PD-CRG-NPAR-PRT TO
                           AMOUNT-PAID-TWR(NP4-SUB)
                         MOVE ZEROES TO
                          SAVINGS-AMOUNT-2-CP-TWR(NP4-SUB)
                         SET YES-NPAR-RELIEF(NP4-SUB) TO TRUE
                         MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                         MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                       END-IF
                      END-IF
                     END-IF
                    END-PERFORM
                   MOVE ZEROES TO NP-RECALC-AMT
                  ELSE
                    IF SAVINGS-AMOUNT-2-CP-TWR(NP3-SUB) <
                      NPAR-AMT-REMAIN
                      ADD SAVINGS-AMOUNT-2-CP-TWR(NP3-SUB) TO
                         NON-PAR-SAV-ACCUM
                    END-IF
                  END-IF
                END-IF
             END-IF
           END-IF.
           IF TS3-NON-PAR-TWR(NP3-SUB)
             COMPUTE NPAR-AMT-REMAIN =
               NON-PAR-MAX - NON-PAR-SAV-ACCUM
             IF NPAR-AMT-REMAIN > 0
                IF SAVINGS-AMOUNT-3-CP-TWR(NP3-SUB) =
                     NPAR-AMT-REMAIN
                   SET NON-PAR-MAX-MET TO TRUE
                   MOVE ZEROES TO NON-PAR-SAV-ACCUM
                   PERFORM VARYING NP4-SUB FROM 1 BY 1 UNTIL
                     NP4-SUB > NUMBER-OF-CHARGES-TWR
                    IF NP4-SUB > NP3-SUB
                     IF NOT YES-NPAR-RELIEF(NP4-SUB)
                      IF TS3-NON-PAR-TWR(NP4-SUB)
                       ADD SAVINGS-AMOUNT-3-CP-TWR(NP4-SUB) TO
                       AMOUNT-PAID-CP-TWR(NP4-SUB)
                       MOVE AMOUNT-PAID-CP-TWR(NP4-SUB) TO
                         AMOUNT-PAID-CRG-NPAR
                       MOVE AMT-PD-CRG-NPAR-PRT TO
                         AMOUNT-PAID-TWR(NP4-SUB)
                       MOVE ZEROES TO
                        SAVINGS-AMOUNT-3-CP-TWR(NP4-SUB)
                       SET YES-NPAR-RELIEF(NP4-SUB) TO TRUE
                       MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                       MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                      END-IF
                     END-IF
                    END-IF
                   END-PERFORM
                ELSE
                  IF SAVINGS-AMOUNT-3-CP-TWR(NP3-SUB) > NPAR-AMT-REMAIN
                    COMPUTE NP-RECALC-AMT =
                    SAVINGS-AMOUNT-3-CP-TWR(NP3-SUB) -
                      NPAR-AMT-REMAIN
                   ADD NP-RECALC-AMT TO AMOUNT-PAID-CP-TWR(NP3-SUB)
                   MOVE AMOUNT-PAID-CP-TWR(NP3-SUB) TO
                      AMOUNT-PAID-CRG-NPAR
                   MOVE AMT-PD-CRG-NPAR-PRT TO
                      AMOUNT-PAID-TWR(NP3-SUB)
                   MOVE NPAR-AMT-REMAIN TO
                              SAVINGS-AMOUNT-3-CP-TWR(NP3-SUB)
                   SET NON-PAR-MAX-MET TO TRUE
                   MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                   MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                   SET YES-NPAR-RELIEF(NP3-SUB) TO TRUE
                   MOVE ZEROES TO NON-PAR-SAV-ACCUM
                    PERFORM VARYING NP4-SUB FROM 1 BY 1 UNTIL
                      NP4-SUB > NUMBER-OF-CHARGES-TWR
                     IF NP4-SUB > NP3-SUB
                      IF NOT YES-NPAR-RELIEF(NP4-SUB)
                       IF TS3-NON-PAR-TWR(NP4-SUB)
                        ADD SAVINGS-AMOUNT-3-CP-TWR(NP4-SUB)
                         TO AMOUNT-PAID-CP-TWR(NP4-SUB)
                         MOVE AMOUNT-PAID-CP-TWR(NP4-SUB) TO
                           AMOUNT-PAID-CRG-NPAR
                         MOVE AMT-PD-CRG-NPAR-PRT TO
                           AMOUNT-PAID-TWR(NP4-SUB)
                         MOVE ZEROES TO
                         SAVINGS-AMOUNT-3-CP-TWR(NP4-SUB)
                        SET YES-NPAR-RELIEF(NP4-SUB) TO TRUE
                        MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                        MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                       END-IF
                      END-IF
                     END-IF
                    END-PERFORM
                   MOVE ZEROES TO NP-RECALC-AMT
                  ELSE
                    IF SAVINGS-AMOUNT-3-CP-TWR(NP3-SUB) <
                      NPAR-AMT-REMAIN
                      ADD SAVINGS-AMOUNT-3-CP-TWR(NP3-SUB) TO
                         NON-PAR-SAV-ACCUM
                    END-IF
                  END-IF
                END-IF
             END-IF
           END-IF.

           IF TS4-NON-PAR-TWR(NP3-SUB)
             COMPUTE NPAR-AMT-REMAIN =
               NON-PAR-MAX - NON-PAR-SAV-ACCUM
             IF NPAR-AMT-REMAIN > 0
                IF SAVINGS-AMOUNT-4-CP-TWR(NP3-SUB) =
                     NPAR-AMT-REMAIN
                   SET NON-PAR-MAX-MET TO TRUE
                   MOVE ZEROES TO NON-PAR-SAV-ACCUM
                   PERFORM VARYING NP4-SUB FROM 1 BY 1 UNTIL
                     NP4-SUB > NUMBER-OF-CHARGES-TWR
                    IF NP4-SUB > NP3-SUB
                     IF NOT YES-NPAR-RELIEF(NP4-SUB)
                      IF TS4-NON-PAR-TWR(NP4-SUB)
                       ADD SAVINGS-AMOUNT-4-CP-TWR(NP4-SUB) TO
                       AMOUNT-PAID-CP-TWR(NP4-SUB)
                       MOVE AMOUNT-PAID-CP-TWR(NP4-SUB) TO
                         AMOUNT-PAID-CRG-NPAR
                       MOVE AMT-PD-CRG-NPAR-PRT TO
                         AMOUNT-PAID-TWR(NP4-SUB)
                       MOVE ZEROES TO
                        SAVINGS-AMOUNT-4-CP-TWR(NP4-SUB)
                       SET YES-NPAR-RELIEF(NP4-SUB) TO TRUE
                       MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                       MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                      END-IF
                     END-IF
                    END-IF
                   END-PERFORM
                ELSE
                  IF SAVINGS-AMOUNT-4-CP-TWR(NP3-SUB) > NPAR-AMT-REMAIN
                    COMPUTE NP-RECALC-AMT =
                    SAVINGS-AMOUNT-4-CP-TWR(NP3-SUB) -
                      NPAR-AMT-REMAIN
                   ADD NP-RECALC-AMT TO AMOUNT-PAID-CP-TWR(NP3-SUB)
                   MOVE AMOUNT-PAID-CP-TWR(NP3-SUB) TO
                      AMOUNT-PAID-CRG-NPAR
                   MOVE AMT-PD-CRG-NPAR-PRT TO
                     AMOUNT-PAID-TWR(NP3-SUB)
                   MOVE NPAR-AMT-REMAIN TO
                              SAVINGS-AMOUNT-4-CP-TWR(NP3-SUB)
                   SET NON-PAR-MAX-MET TO TRUE
                   MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                   MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                   SET YES-NPAR-RELIEF(NP3-SUB) TO TRUE
                   MOVE ZEROES TO NON-PAR-SAV-ACCUM
                    PERFORM VARYING NP4-SUB FROM 1 BY 1 UNTIL
                      NP4-SUB > NUMBER-OF-CHARGES-TWR
                     IF NP4-SUB > NP3-SUB
                      IF NOT YES-NPAR-RELIEF(NP4-SUB)
                       IF TS4-NON-PAR-TWR(NP4-SUB)
                        ADD SAVINGS-AMOUNT-4-CP-TWR(NP4-SUB)
                         TO AMOUNT-PAID-CP-TWR(NP4-SUB)
                        MOVE AMOUNT-PAID-CP-TWR(NP4-SUB)
                         TO AMOUNT-PAID-CRG-NPAR
                        MOVE AMT-PD-CRG-NPAR-PRT TO
                          AMOUNT-PAID-TWR(NP4-SUB)
                        MOVE ZEROES TO
                         SAVINGS-AMOUNT-4-CP-TWR(NP4-SUB)
                        SET YES-NPAR-RELIEF(NP4-SUB)TO TRUE
                        MOVE ZEROES TO AMOUNT-PAID-CRG-NPAR
                        MOVE SPACES TO AMT-PD-CRG-NPAR-PRT
                       END-IF
                      END-IF
                     END-IF
                    END-PERFORM
                   MOVE ZEROES TO NP-RECALC-AMT
                  ELSE
                    IF SAVINGS-AMOUNT-4-CP-TWR(NP3-SUB) <
                      NPAR-AMT-REMAIN
                      ADD SAVINGS-AMOUNT-4-CP-TWR(NP3-SUB) TO
                         NON-PAR-SAV-ACCUM
                    END-IF
                  END-IF
                END-IF
             END-IF
           END-IF.
           .
       1156-EXIT.
           EXIT.
           .
       1157-REMOVE-BFNW-OVERRIDE.
           IF CLM-EDIT-OVERRIDE-CODE-1-TWR = 'BFNW' OR 'BFZD'
             MOVE SPACES TO CLM-EDIT-OVERRIDE-CODE-1-TWR
           ELSE
            IF CLM-EDIT-OVERRIDE-CODE-2-TWR = 'BFNW' OR 'BFZD'
              MOVE SPACES TO CLM-EDIT-OVERRIDE-CODE-2-TWR
            ELSE
             IF CLM-EDIT-OVERRIDE-CODE-3-TWR = 'BFNW' OR 'BFZD'
               MOVE SPACES TO CLM-EDIT-OVERRIDE-CODE-3-TWR
             ELSE
               IF CLM-EDIT-OVERRIDE-CODE-4-TWR = 'BFNW' OR 'BFZD'
                MOVE SPACES TO CLM-EDIT-OVERRIDE-CODE-4-TWR
               ELSE
                IF CLM-EDIT-OVERRIDE-CODE-5-TWR = 'BFNW' OR 'BFZD'
                  MOVE SPACES TO CLM-EDIT-OVERRIDE-CODE-5-TWR
                END-IF
               END-IF
             END-IF
            END-IF
           END-IF.
           .
       1157-EXIT.
           EXIT.
      *%%% PE TT 34821 END                                              FH02P0M3
      *
      *%%% PE TT 38875 BEGIN                                            FH02P0M3
       1158-REMOVE-BFNW-CHARGELINE.
           MOVE 'N' TO CHARGE-FNW-OVERRIDE-SW
                       CHARGE-FZD-OVERRIDE-SW.
           IF EDIT-OVERRIDE-CODE-1-TWR(NP6-SUB)= 'BFNW'
            MOVE SPACES TO EDIT-OVERRIDE-CODE-1-TWR(NP6-SUB)
            SET CHARGE-FNW-OVERRIDE TO TRUE
           ELSE
            IF EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB) = 'BFNW'
             MOVE SPACES TO EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB)
             SET CHARGE-FNW-OVERRIDE TO TRUE
            ELSE
             IF EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB) = 'BFNW'
              MOVE SPACES TO EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB)
              SET CHARGE-FNW-OVERRIDE TO TRUE
             ELSE
              IF EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB)= 'BFNW'
                MOVE SPACES TO EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB)
                SET CHARGE-FNW-OVERRIDE TO TRUE
              ELSE
               IF EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB) ='BFNW'
                MOVE SPACES TO EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB)
                 SET CHARGE-FNW-OVERRIDE TO TRUE
               END-IF
              END-IF
             END-IF
            END-IF
           END-IF.
           IF EDIT-OVERRIDE-CODE-1-TWR(NP6-SUB) = 'BFZD'
            MOVE SPACES TO EDIT-OVERRIDE-CODE-1-TWR(NP6-SUB)
            SET CHARGE-FZD-OVERRIDE TO TRUE
           ELSE
            IF EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB) = 'BFZD'
             MOVE SPACES TO EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB)
             SET CHARGE-FZD-OVERRIDE TO TRUE
            ELSE
             IF EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB) = 'BFZD'
              MOVE SPACES TO EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB)
              SET CHARGE-FZD-OVERRIDE TO TRUE
             ELSE
              IF EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB) = 'BFZD'
               MOVE SPACES TO EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB)
               SET CHARGE-FZD-OVERRIDE TO TRUE
              ELSE
               IF EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB) = 'BFZD'
                 MOVE SPACES TO EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB)
                 SET CHARGE-FZD-OVERRIDE TO TRUE
               END-IF
              END-IF
             END-IF
            END-IF
           END-IF.
           IF CHARGE-FNW-OVERRIDE OR CHARGE-FZD-OVERRIDE
             PERFORM 1159-SHIFT-OVERRIDE-CODES
             THRU 1159-EXIT
           END-IF.
       1158-EXIT.
           EXIT.
      *
       1159-SHIFT-OVERRIDE-CODES.
           IF EDIT-OVERRIDE-CODE-1-TWR(NP6-SUB) = SPACES
            AND EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB) NOT = SPACES
             MOVE EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB) TO
              EDIT-OVERRIDE-CODE-1-TWR(NP6-SUB)
             MOVE EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB) TO
              EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB)
             MOVE EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB) TO
              EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB)
             MOVE EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB) TO
              EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB)
           ELSE
            IF EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB) =  SPACES
             AND EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB) NOT = SPACES
              MOVE EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB) TO
               EDIT-OVERRIDE-CODE-2-TWR(NP6-SUB)
              MOVE EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB) TO
               EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB)
              MOVE EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB) TO
               EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB)
            ELSE
             IF EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB) = SPACES
              AND EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB) NOT = SPACES
               MOVE EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB) TO
                EDIT-OVERRIDE-CODE-3-TWR(NP6-SUB)
               MOVE EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB) TO
                EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB)
             ELSE
              IF EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB) = SPACES
               AND EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB) NOT = SPACES
                MOVE EDIT-OVERRIDE-CODE-5-TWR(NP6-SUB) TO
                 EDIT-OVERRIDE-CODE-4-TWR(NP6-SUB)
              END-IF
             END-IF
            END-IF
           END-IF.
       1159-EXIT.
           EXIT.
      *%%% PE TT38875 R2 2005 END
      *

       1200-GENERATE-REMARKS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            GENERATE EOB/INFO REMARKS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           INITIALIZE ERROR-REASON
                      ERROR-REASON-ACTION
           SET FH02P3MG-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-AUXILIARY-FIELDS
                                      P0M3-EXECUTIVE-DATA-FIELDS
                ON EXCEPTION
                   MOVE 1200                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       1200-EXIT.
           EXIT.

       1300-OPL-SAVINGS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *                 CALCULATE OPL SAVINGS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET FH02P3MJ-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TWR-CRG-SUB
                                      TRANSACTION-WORK-RECORD
                                      P0M3-EXECUTIVE-DATA-FIELDS
                ON EXCEPTION
                   MOVE 1300                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       1300-EXIT.
           EXIT.

      *%%% KJ TT 44644 BEGIN
      *
      *1400-CALC-SUB-LIABILITY.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            CALCULATE SUBSCRIBER LIABILITY
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *
      *    INITIALIZE ERROR-REASON
      *               ERROR-REASON-ACTION
      *
      *    SET FH02P3MB-MODULE       TO TRUE
      *    CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
      *                               DUMMY-COMMAREA
      *                               APPL-RETURN-AREA
      *                               CALC-BY-MED-LIMITING-CHGS-SW
      *                               FH01-OVERRIDES-AREAS
      *                               P0M3-EXECUTIVE-DATA-FIELDS
      *                               TWR-AUXILIARY-FIELDS
      *                               TRANSACTION-WORK-RECORD
      *                               FH01-EXECUTIVE-DATA-FIELDS
      *         ON EXCEPTION
      *            MOVE 1400                 TO WS-V-ERROR-PARA
      *            SET FEP-MAF-CICS-SOFTWARE TO TRUE
      *            SET CALL-PGM              TO TRUE
      *            PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
      *    END-CALL
      *    PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
      *    .
      *1400-EXIT.
      *    EXIT.
      *%%% KJ TT 44644 END

       2000-CHARGE-PROCESSING.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            CHARGE PROCESSING FOR CURR, PR-1, PR-2
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           EVALUATE TRUE
             WHEN (DISP4-1STEP-TWR
                   AND HISTORY-CHRG-REJECTED-TWR (TWR-CRG-SUB))
      ***%%% TT45391
                    GO TO 2000-EXIT
      ***%%% TT45391
             WHEN VOID-D4-TWR
               PERFORM 2010-SET-CHARGE-BENE-PERIOD THRU 2010-EXIT
               PERFORM 2020-INITIALIZE-CHARGE THRU 2020-EXIT
               SET BEGIN-CHARGE TO TRUE
               PERFORM 2100-FORMAT-F030 THRU 2100-EXIT
               PERFORM 9200-REGULAR-N1 THRU 9200-EXIT
               SET END-CHARGE TO TRUE
               PERFORM 2100-FORMAT-F030 THRU 2100-EXIT
               GO TO 2000-EXIT
             WHEN HISTORY-CHRG-APPROVED-TWR (TWR-CRG-SUB)
               PERFORM 2010-SET-CHARGE-BENE-PERIOD THRU 2010-EXIT
               PERFORM 2020-INITIALIZE-CHARGE THRU 2020-EXIT
               SET BEGIN-CHARGE TO TRUE
               PERFORM 2100-FORMAT-F030 THRU 2100-EXIT
               PERFORM 9400-HIST-AND-TIMELY-FILING-N1 THRU 9400-EXIT

               IF  PRODUCE-N4-LINES
               AND OC-CALCULATED
               AND (NO-ERRORS
                    OR REJECT-THIS-CHARGE
                    OR ANY-REJ-AFFECTED-CHRG-TWR (TWR-CRG-SUB))
                   MOVE CHARGE-LINE-TWR (TWR-CRG-SUB)
                     TO CHARGE-LINE-COB (TWR-CRG-SUB)
                   PERFORM 3200-SH-LINES-TO-TABLES
                      THRU 3200-EXIT
               END-IF

               SET END-CHARGE TO TRUE
               PERFORM 2100-FORMAT-F030 THRU 2100-EXIT
               GO TO 2000-EXIT
             WHEN ANY-REJ-AFFECTED-CHRG-TWR (TWR-CRG-SUB)
             WHEN PLAN-REJECTED-CHRG-TWR (TWR-CRG-SUB)
               ADD 1 TO TOTAL-REJECTED-CHARGES
      *%%% EL TT 18735 - BEGIN
             WHEN IS-SUBROGATION-ADJUSTMENT
             WHEN PREV-WAS-SUBROGATED
               PERFORM 2010-SET-CHARGE-BENE-PERIOD THRU 2010-EXIT
               PERFORM 2020-INITIALIZE-CHARGE THRU 2020-EXIT
               SET BEGIN-CHARGE TO TRUE
               PERFORM 2100-FORMAT-F030 THRU 2100-EXIT
               IF NO-ERRORS
               PERFORM 9400-HIST-AND-TIMELY-FILING-N1 THRU 9400-EXIT
               SET END-CHARGE TO TRUE
               PERFORM 2100-FORMAT-F030 THRU 2100-EXIT
               ELSE
                  IF DEFER-THIS-CHARGE
                     PERFORM 9300-BUILD-L1 THRU 9300-EXIT
                  END-IF
               END-IF
               GO TO 2000-EXIT
      *%%% EL TT 18735 - END
             WHEN APPROVED-CHRG-TWR (TWR-CRG-SUB)
               PERFORM 2010-SET-CHARGE-BENE-PERIOD THRU 2010-EXIT
               PERFORM 2020-INITIALIZE-CHARGE THRU 2020-EXIT
               SET BEGIN-CHARGE TO TRUE
               PERFORM 2100-FORMAT-F030 THRU 2100-EXIT
               PERFORM 2200-CIRCUMSTANCES THRU 2200-EXIT
               IF  NO-ERRORS
                   PERFORM 2300-PAYMENT-LEVEL THRU 2300-EXIT
               END-IF
               IF  NO-ERRORS
                   PERFORM 2400-PRICING THRU 2400-EXIT
               END-IF
               IF  NO-ERRORS
                   IF  OC-CALCULATED
                       PERFORM 2500-VA-DOD-IHF THRU 2500-EXIT
                   END-IF
               END-IF
               IF  NO-ERRORS
                   PERFORM 2600-DEDUCTIBLE THRU 2600-EXIT
               END-IF
               IF  NO-ERRORS
                   PERFORM 2700-COIN-COPAY THRU 2700-EXIT
               END-IF
               IF  NO-ERRORS
                   IF  OC-CALCULATED
                       PERFORM 2800-SPCL-AMT-PAYABLE THRU 2800-EXIT
                   END-IF
               END-IF

               IF  OC-CALCULATED
               AND NO-ERRORS
                   PERFORM 2055-EDIT-FKR THRU 2055-EXIT
               END-IF

      *%%% EL TT# 86219/89136 - BEGIN
               IF NO-ERRORS
                   PERFORM 2050-DOLLAR-MAX THRU 2050-EXIT
               END-IF

      *        IF NO-ERRORS
      *           IF OC-CALCULATED
      *             MOVE AMOUNT-PAYABLE TO AMOUNT-PAID
      *           ELSE
      *             MOVE AMOUNT-PAID-CP-TWR (TWR-CRG-SUB) TO AMOUNT-PAID
      *           END-IF
      *        END-IF
      *%%% EL TT# 86219/89136 - END

               IF NO-ERRORS
      *%%% EL CMR354750 BEGIN - PERFORM CROSSFOOT ON MEDICARE CLAIMS
      *                         PROBLEM LOG CLMPRB00302
                   IF NOT PRODUCE-N4-LINES
      *%%% EL CMR354750 END
                       PERFORM 9500-CROSSFOOT-CHARGE THRU 9500-EXIT
                   END-IF
                   PERFORM 2090-EOB-REMARKS THRU 2090-EXIT
                   PERFORM 9200-REGULAR-N1 THRU 9200-EXIT
                   PERFORM 9290-MOVE-EXEC-DATA-TO-TWR THRU 9290-EXIT
                   SET END-CHARGE TO TRUE
                   PERFORM 2100-FORMAT-F030 THRU 2100-EXIT
               ELSE
                   IF DEFER-THIS-CHARGE
                       PERFORM 9300-BUILD-L1 THRU 9300-EXIT
                   END-IF
               END-IF
           END-EVALUATE

           IF  PRODUCE-N4-LINES
           AND OC-CALCULATED
           AND (NO-ERRORS
                OR REJECT-THIS-CHARGE
                OR ANY-REJ-AFFECTED-CHRG-TWR (TWR-CRG-SUB))
               PERFORM 2900-COB-SECONDARY THRU 2900-EXIT
           END-IF

           IF  APPROVED-CHRG-TWR (TWR-CRG-SUB)
               IF ((ORIGINAL-D1-TWR OR ADJUSTMENT-D2-TWR)
                    AND (PROCESS-CODE-TWR = 'I' OR 'J'))
      *%%% KX TT 49146 - BEGIN
      *        OR (INTERIM-BILL-D6-TWR
      *            AND (PROCESS-CODE-TWR = 'E' OR 'I'))
      *%%% KX TT 49146 - END
                   CONTINUE
               ELSE
                   SET  PERF-PROV-UPDATE-COPAY             TO TRUE
                   PERFORM 2999-PERF-PROV-COPAY-TABLE THRU 2999-EXIT
               END-IF
           END-IF
           .
       2000-EXIT.
           EXIT.

       2010-SET-CHARGE-BENE-PERIOD.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            SET UP THE BENEFIT PERIOD
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *
           IF  FIRST-CHARGE-THRU
      *
      *----------------------------------------------------------------
      *--- SET UP 'YEAR' BENEFIT PERIOD - LAST BYTE OF YEAR / OPTION
      *----------------------------------------------------------------
      *
               MOVE CLM-BEGIN-YEAR-NUM-TWR
                 TO BENEFIT-PRD-YEAR-F030
                    OTH-BENEFIT-PRD-YEAR-F030
      *
      *----------------------------------------------------------------
      *--- SET UP 'PROCESS' BENEFIT PERIOD - PROCESS-PERIOD / OPTION
      *        0 = CURR PERIOD
      *        1 = PR-1 PERIOD
      *        2 = PR-2 PERIOD
      *----------------------------------------------------------------
      *
               MOVE PROCESS-PERIOD TO BENE-PERIOD-YEAR
                                         OTH-BENE-PERIOD-YEAR
      *
      *-----------------------------------------------------------------
      *  ADD  ENROLLMENT  OPTION  TO  BOTH:
      *       1)  YEAR  BENEFIT-PERIOD
      *       2)  PROCESS  BENEFIT-PERIOD
      *-----------------------------------------------------------------
      *
               IF STD-OPTION-CONTRACT-TWR
                  MOVE 1 TO BENE-PERIOD-OPTION
                            BENEFIT-PRD-OPTION-F030
                  MOVE 4 TO OTH-BENE-PERIOD-OPTION
                            OTH-BENEFIT-PRD-OPTION-F030
               END-IF
      *
      *%%% KX TT 84175 BEGIN
               IF BASIC-OPT-NCO-CONTRACT-TWR
      *%%% KX TT 84175 END
                  MOVE 4 TO BENE-PERIOD-OPTION
                            BENEFIT-PRD-OPTION-F030
                  MOVE 1 TO OTH-BENE-PERIOD-OPTION
                            OTH-BENEFIT-PRD-OPTION-F030
               END-IF
      *
      *%%% KX TT 84175 BEGIN
               IF BASIC-OPT-CO-CONTRACT-TWR
                  MOVE 5 TO BENE-PERIOD-OPTION
                            BENEFIT-PRD-OPTION-F030
                  MOVE 0 TO OTH-BENE-PERIOD-OPTION
                            OTH-BENEFIT-PRD-OPTION-F030
               END-IF
      *%%% PE TT 1171411 BEGIN
               IF BFCS-OPTION-CONTRACT-TWR
                  MOVE 6 TO BENE-PERIOD-OPTION
                            BENEFIT-PRD-OPTION-F030
                  MOVE 1 TO OTH-BENE-PERIOD-OPTION
                            OTH-BENEFIT-PRD-OPTION-F030
               END-IF
      *
      *%%% PE TT 1171411 END
      *%%% KX TT 84175 END
            END-IF
           .
       2010-EXIT.
           EXIT.

       2020-INITIALIZE-CHARGE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            INITIALIZATION PER CHARGE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           INITIALIZE   DEDUCT-AMOUNT
                        DEDUCT-ROUNDED
                        AMT-USED-TO-DEDUCT
                        FAM-DEDUCT-AMOUNT
                        FAM-DEDUCT-ROUNDED
                        FAM-AMT-USED-TO-DEDUCT
                        COINSURANCE-AMOUNT
                        COINS-PERCENT
                        AMOUNT-PAYABLE-PERCENT
                        AMOUNT-PAYABLE
                        DME-MAX-PAYABLE
                        AMOUNT-PAYABLE-SECONDARY
                        COB-ALLOWABLE-CHARGES
                        ALLOWABLE-COINS-AMOUNT
                        AMOUNT-PAID
                        MEDICARE-PHANTOM-SAVINGS
                        FAM-DEDUCT-REMAINING
                        DEDUCTIBLE-REMAINING
                        DEDUCTIBLE-REMAINING
      *%%% EL TT# 802259/802262 - BEGIN
                        CAT-MAX-REMAINING
                        MBR-CAT-MAX-REMAINING
                        PPO-MAX-REMAINING
                        MBR-PPO-MAX-REMAINING
                        TOT-PPO-MAX-REMAINING
                        MBR-CAT-APPL-PR-TO-CRG
                        MBR-PPO-APPL-PR-TO-CRG
                        MBR-CAT-ACCUM-AFT-CRG
                        MBR-PPO-ACCUM-AFT-CRG
      *%%% EL TT# 802259/802262 - END
                        TOT-MAX-REMAINING
                        DEDUCT-REMNG-PR-TO-CRG
                        FAM-DEDUCT-REMNG-PR-TO-CRG
                        DAYS-REMNG-PR-TO-CRG
                        VISITS-REMNG-PR-TO-CRG
                        CAT-REMNG-PR-TO-CRG
                        PPO-REMNG-PR-TO-CRG
                        PPO-APPL-PR-TO-CRG
                        CAT-APPL-PR-TO-CRG
                        LIFETIME-REMNG-PR-TO-CRG
                        MI-LIFETIME-REMNG-PR-TO-CRG
                        SPEC-1-LIFE-REMNG-PR-TO-CRG
                        SPEC-2-LIFE-REMNG-PR-TO-CRG
                        DEDUCT-ACCUM-AFT-CRG
                        FAM-DEDUCT-ACCUM-AFT-CRG
                        DAYS-ACCUM-AFT-CRG
                        VISITS-ACCUM-AFT-CRG
                        CAT-ACCUM-AFT-CRG
                        PPO-ACCUM-AFT-CRG
                        LIFETIME-ACCUM-AFT-CRG
                        MI-LIFETIME-ACCUM-AFT-CRG
                        SPEC-1-LIFE-ACCUM-AFT-CRG
                        SPEC-2-LIFE-ACCUM-AFT-CRG
      *
           MOVE 1.00 TO ONE-HUNDRED-PERCENT
      *
           INITIALIZE    ERROR-REASON
                         ERROR-REASON-ACTION
                         HOLD-WILL-EXCEED-REASON
                         OVERRIDE-RESULTS
                         SUPP-HISTORY-WRITTEN-SW
                         CHARGE-UPDATED-PATIENT-SW
                         CHARGE-UPDATED-FAMILY-SW
                         VISITS-IND
                         DAYS-IND
                         CHIRO-VISITS-IND
                         SPEC-LIFE-IND1
                         SPEC-LIFE-IND2
                         DEDUCT-IND
                         FAM-DEDUCT-IND
                         COINS-IND
                         STOP-LOSS-DFR-SW
                         PRIMARY-LIFE-SWITCH
                         DEFER-FP8-SW
                         POS-COB-CHARGE
                         CODE-609-CNTR
                         CODE-610-CNTR
                         CODE-630-CNTR
                         CODE-633-CNTR
                         CODE-637-CNTR
                         CODE-OTH-CNTR
                         CODE-EFM-CNTR
                         CHECK-FLD
                         BENEFIT-GROUP
      * %%% KX TT01480
                         EDIT-SUPP-HIST-INFO
      * %%% KX TT01480
      *%%% EL TT# 184100 - BEGIN
                         VISITS-IND2
                         VISITS2-ACCUM-AFT-CRG
      *%%% EL TT# 184100 - END
      *
           SET PRIMARY-CALC TO TRUE
           SET NO-VAMED-CHARGE TO TRUE
           MOVE LIT-N TO PRIMARY-LIFE-SWITCH
                         CALC-BY-MED-LIMITING-CHGS-SW

      *%%% EL TT 18735 - BEGIN
           IF  (IS-SUBROGATION-ADJUSTMENT
                OR PREV-WAS-SUBROGATED)
           AND APPROVED-CHRG-TWR (TWR-CRG-SUB)
               PERFORM 2030-SUBROGATION-ADJUSTMENT THRU 2030-EXIT
           END-IF
      *%%% EL TT 18735 - END
           .
       2020-EXIT.
           EXIT.

      *%%% EL TT 18735 - BEGIN
       2030-SUBROGATION-ADJUSTMENT.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   MOVE CURRENT CHARGE STATUS, APOC IND/AMT, PREVIOUS AMOUNT
      *     PAID, AND EDIT OVERRIDES TO HOLD FIELDS
      *   OVERLAY CURRENT LINE WITH HISTORY LINE
      *   MOVE HOLD FIELDS TO CORRESPONDING FIELDS ON CURRENT CHARGE
      *   DEFER 'FNM' IF SUBROGATION AMOUNT > SUM OF PREVIOUS AMOUNT
      *     PAID AND PREVIOUS SUBROGATION SAVINGS
      *   ADJUST AMOUNT PAID & UPDATE/CREATE SUBROGATION SAVINGS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           INITIALIZE HOLD-APOC-IND
                      HOLD-APOC-AMT-CP
                      PREV-SUBROGATION-SAVINGS
      *%%% PE TT84291
                      HOLD-CHARGE-COMMENTS
                      HOLD-EOB-REMARKS
                      HOLD-INFO-REMARKS
           MOVE '000000000' TO HOLD-APOC-AMT-AN

           MOVE CHARGE-STATUS-TWR (TWR-CRG-SUB)
             TO HOLD-CHARGE-STATUS
           EVALUATE TRUE
             WHEN APOC1-SUBROGATION-TWR (TWR-CRG-SUB)
               MOVE AMT-PAID-OTHER-CARR-IND-1-TWR (TWR-CRG-SUB)
                 TO HOLD-APOC-IND
               MOVE AMT-PAID-OTHER-CARR-AMT-1-TWR (TWR-CRG-SUB)
                 TO HOLD-APOC-AMT-AN
               MOVE AMT-PAID-OTHER-CARR-1-CP-TWR (TWR-CRG-SUB)
                 TO HOLD-APOC-AMT-CP
             WHEN APOC2-SUBROGATION-TWR (TWR-CRG-SUB)
               MOVE AMT-PAID-OTHER-CARR-IND-2-TWR (TWR-CRG-SUB)
                 TO HOLD-APOC-IND
               MOVE AMT-PAID-OTHER-CARR-AMT-2-TWR (TWR-CRG-SUB)
                 TO HOLD-APOC-AMT-AN
               MOVE AMT-PAID-OTHER-CARR-2-CP-TWR (TWR-CRG-SUB)
                 TO HOLD-APOC-AMT-CP
           END-EVALUATE
           MOVE CHRG-PREV-AMOUNT-PAID-TWR (TWR-CRG-SUB)
             TO HOLD-PREV-AMT-PAID-AN
           MOVE CHRG-PREV-AMOUNT-PAID-CP-TWR (TWR-CRG-SUB)
             TO HOLD-PREV-AMT-PAID-CP
           MOVE EDIT-OVERRIDE-CODES-TWR (TWR-CRG-SUB)
             TO HOLD-EDIT-OVERRIDE-CODES
           MOVE ADJUSTMENT-REASON-TWR (TWR-CRG-SUB)
             TO HOLD-ADJUSTMENT-REASON
      *%%% PE TT84291 BEGIN
           MOVE CHARGE-COMMENTS-TWR (TWR-CRG-SUB)
             TO HOLD-CHARGE-COMMENTS
      *%%% PE TT84291 END
      *%%% PE TT681825 BEGIN
           MOVE EOB-REMARK-CODES-TWR (TWR-CRG-SUB)
             TO HOLD-EOB-REMARKS
           MOVE INFO-REMARK-CODES-TWR (TWR-CRG-SUB)
             TO HOLD-INFO-REMARKS
      *%%% PE TT681825 END

           PERFORM VARYING CHRG-SUB FROM 1 BY 1
             UNTIL CHRG-SUB > NUMBER-OF-CHARGES-D-3
               IF LINE-NUMBER-AN-TWR (TWR-CRG-SUB) =
                  LINE-NUMBER-AN-D-3 (CHRG-SUB)
                  EVALUATE TRUE
                    WHEN TS1-SUBROGATION-D-3 (CHRG-SUB)
                      MOVE SAVINGS-AMOUNT-1-CP-D-3 (CHRG-SUB)
                        TO PREV-SUBROGATION-SAVINGS
                    WHEN TS2-SUBROGATION-D-3 (CHRG-SUB)
                      MOVE SAVINGS-AMOUNT-2-CP-D-3 (CHRG-SUB)
                        TO PREV-SUBROGATION-SAVINGS
                    WHEN TS3-SUBROGATION-D-3 (CHRG-SUB)
                      MOVE SAVINGS-AMOUNT-3-CP-D-3 (CHRG-SUB)
                        TO PREV-SUBROGATION-SAVINGS
                    WHEN TS4-SUBROGATION-D-3 (CHRG-SUB)
                      MOVE SAVINGS-AMOUNT-4-CP-D-3 (CHRG-SUB)
                        TO PREV-SUBROGATION-SAVINGS
                  END-EVALUATE
                  MOVE CHARGE-LINE-D-3 (CHRG-SUB)
                    TO CHARGE-LINE-TWR (TWR-CRG-SUB)
               END-IF
           END-PERFORM

           MOVE HOLD-CHARGE-STATUS
             TO CHARGE-STATUS-TWR (TWR-CRG-SUB)
           IF  HOLD-APOC-IND = 'SU'
               EVALUATE TRUE
                 WHEN APOC1-SUBROGATION-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-IND
                     TO AMT-PAID-OTHER-CARR-IND-1-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-AN
                     TO AMT-PAID-OTHER-CARR-AMT-1-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-CP
                     TO AMT-PAID-OTHER-CARR-1-CP-TWR (TWR-CRG-SUB)
                 WHEN APOC2-SUBROGATION-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-IND
                     TO AMT-PAID-OTHER-CARR-IND-2-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-AN
                     TO AMT-PAID-OTHER-CARR-AMT-2-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-CP
                     TO AMT-PAID-OTHER-CARR-2-CP-TWR (TWR-CRG-SUB)
                 WHEN AMT-PAID-OTHER-CARR-IND-1-TWR (TWR-CRG-SUB) =
                      SPACES
                   MOVE HOLD-APOC-IND
                     TO AMT-PAID-OTHER-CARR-IND-1-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-AN
                     TO AMT-PAID-OTHER-CARR-AMT-1-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-CP
                     TO AMT-PAID-OTHER-CARR-1-CP-TWR (TWR-CRG-SUB)
                 WHEN OTHER
                   MOVE HOLD-APOC-IND
                     TO AMT-PAID-OTHER-CARR-IND-2-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-AN
                     TO AMT-PAID-OTHER-CARR-AMT-2-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-CP
                     TO AMT-PAID-OTHER-CARR-2-CP-TWR (TWR-CRG-SUB)
               END-EVALUATE
           ELSE
               EVALUATE TRUE
                 WHEN APOC1-SUBROGATION-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-IND
                     TO AMT-PAID-OTHER-CARR-IND-1-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-AN
                     TO AMT-PAID-OTHER-CARR-AMT-1-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-CP
                     TO AMT-PAID-OTHER-CARR-1-CP-TWR (TWR-CRG-SUB)
                 WHEN APOC2-SUBROGATION-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-IND
                     TO AMT-PAID-OTHER-CARR-IND-2-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-AN
                     TO AMT-PAID-OTHER-CARR-AMT-2-TWR (TWR-CRG-SUB)
                   MOVE HOLD-APOC-AMT-CP
                     TO AMT-PAID-OTHER-CARR-2-CP-TWR (TWR-CRG-SUB)
               END-EVALUATE
           END-IF
           MOVE HOLD-PREV-AMT-PAID-AN
             TO CHRG-PREV-AMOUNT-PAID-TWR (TWR-CRG-SUB)
           MOVE HOLD-PREV-AMT-PAID-CP
             TO CHRG-PREV-AMOUNT-PAID-CP-TWR (TWR-CRG-SUB)
           MOVE HOLD-EDIT-OVERRIDE-CODES
             TO EDIT-OVERRIDE-CODES-TWR (TWR-CRG-SUB)
           MOVE HOLD-ADJUSTMENT-REASON
             TO ADJUSTMENT-REASON-TWR (TWR-CRG-SUB)
      *%%% PE TT84291 BEGIN
           MOVE HOLD-CHARGE-COMMENTS TO
              CHARGE-COMMENTS-TWR (TWR-CRG-SUB)
      *%%% PE TT84291 END
      *%%% PE TT681825 BEGIN
           MOVE HOLD-EOB-REMARKS TO
              EOB-REMARK-CODES-TWR (TWR-CRG-SUB)
           MOVE HOLD-INFO-REMARKS TO
              INFO-REMARK-CODES-TWR (TWR-CRG-SUB)
      *%%% PE TT681825 END
           IF HOLD-APOC-AMT-CP >
              (HOLD-PREV-AMT-PAID-CP +
               PREV-SUBROGATION-SAVINGS)
              COMPUTE REDUCTION-AMOUNT           =
                  HOLD-APOC-AMT-CP -
                  (HOLD-PREV-AMT-PAID-CP +
                   PREV-SUBROGATION-SAVINGS)
              END-COMPUTE
              MOVE R-FNM TO ERROR-REASON
              SET DEFER-THIS-CHARGE TO TRUE
              PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           ELSE
      *** ADJUST AMOUNT PAID & UPDATE/CREATE SUBROGATION SAVINGS
              COMPUTE ADJUST-AMOUNT-WS = PREV-SUBROGATION-SAVINGS
                 - HOLD-APOC-AMT-CP
              END-COMPUTE
              COMPUTE AMOUNT-PAYABLE = HOLD-PREV-AMT-PAID-CP
                 + ADJUST-AMOUNT-WS
              END-COMPUTE
              MOVE AMOUNT-PAYABLE
                TO AMOUNT-PAID-CP-TWR (TWR-CRG-SUB)
                   HOLD-9-DIGIT-V99
              MOVE HOLD-9-DIGIT-NUMERIC
                TO AMOUNT-PAID-TWR (TWR-CRG-SUB)
              MOVE '7 '                   TO COMMON-SAVE-IND
              MOVE HOLD-APOC-AMT-CP       TO SAVINGS-AMOUNT-WS
              PERFORM 5110-SEARCH-AMOUNTS THRU 5110-EXIT
           END-IF
           .
       2030-EXIT.
           EXIT.
      *%%% EL TT 18735 - END

       2050-DOLLAR-MAX.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *                    CALL LIFETIME MAXIMUM
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET FH02P3MI-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TWR-CRG-SUB
                                      TWR-AUXILIARY-FIELDS
                                      F030-COMMON-NAMES
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      BENEFIT-GROUP
                                      TRANSACTION-WORK-RECORD
                ON EXCEPTION
                   MOVE 2050                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       2050-EXIT.
           EXIT.

       2055-EDIT-FKR.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *                      FKR EDIT LOGIC
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           IF  TOB-SNF-INPATIENT-TWR
           AND INPT-CLM-OTPT-BNFT-SW-TWR NOT = 'Y'
               EVALUATE TRUE
                 WHEN MEDICARE-PART-A-TWR (TWR-CRG-SUB)
                 WHEN MEDICARE-A-DEDUCT-TWR (TWR-CRG-SUB)
                 WHEN MED-MULTI-LINE-PRICING-TWR (TWR-CRG-SUB)
      *%%% P7 TT# 983486 START
                   PERFORM 2070-ACCESS-MED-MAX-AMTS
                      THRU 2070-EXIT
      *%%% P7 TT# 983486 END
                   PERFORM 2060-CALCULATE-SNF-MAX
                      THRU 2060-EXIT
               END-EVALUATE
           END-IF
           .
       2055-EXIT.
           EXIT.

       2060-CALCULATE-SNF-MAX.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *        CALCULATE THE SKILLED NURSING FACILITY MAXIMUM
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           INITIALIZE HOLD-FKR-SAVINGS
                      DIFF-SAVINGS1-SW
                      DIFF-SAVINGS2-SW
                      DIFF-SAVINGS3-SW
                      DIFF-SAVINGS4-SW
           IF TS1-DIFF-LOWER-TWR (TWR-CRG-SUB)
           OR TS1-DIFF-HIGHER-TWR (TWR-CRG-SUB)
           OR TS1-SUPP-PROV-DIFF-TWR (TWR-CRG-SUB)
               SET YES-DIFF-SAVINGS1 TO TRUE
           END-IF
           IF TS2-DIFF-LOWER-TWR (TWR-CRG-SUB) OR
              TS2-DIFF-HIGHER-TWR (TWR-CRG-SUB) OR
              TS2-SUPP-PROV-DIFF-TWR (TWR-CRG-SUB)
               SET YES-DIFF-SAVINGS2 TO TRUE
           END-IF
           IF TS3-DIFF-LOWER-TWR (TWR-CRG-SUB) OR
              TS3-DIFF-HIGHER-TWR (TWR-CRG-SUB) OR
              TS3-SUPP-PROV-DIFF-TWR (TWR-CRG-SUB)
               SET YES-DIFF-SAVINGS3 TO TRUE
           END-IF
           IF TS4-DIFF-LOWER-TWR (TWR-CRG-SUB) OR
              TS4-DIFF-HIGHER-TWR (TWR-CRG-SUB) OR
              TS4-SUPP-PROV-DIFF-TWR (TWR-CRG-SUB)
               SET YES-DIFF-SAVINGS4 TO TRUE
           END-IF
           IF YES-DIFF-SAVINGS1
              ADD SAVINGS-AMOUNT-1-CP-TWR (TWR-CRG-SUB)
               TO HOLD-FKR-SAVINGS
           END-IF
           IF YES-DIFF-SAVINGS2
              ADD SAVINGS-AMOUNT-2-CP-TWR (TWR-CRG-SUB)
               TO HOLD-FKR-SAVINGS
           END-IF
           IF YES-DIFF-SAVINGS3
              ADD SAVINGS-AMOUNT-3-CP-TWR (TWR-CRG-SUB)
               TO HOLD-FKR-SAVINGS
           END-IF
           IF YES-DIFF-SAVINGS4
              ADD SAVINGS-AMOUNT-4-CP-TWR (TWR-CRG-SUB)
               TO HOLD-FKR-SAVINGS
           END-IF

      *%%% EL TT# 100638 - BEGIN
      *%%% EL TT# 7539 BEGIN
           COMPUTE ECF-SNF-CURR-CHRG-PAID =
                   (OTH-CARR-MED-ALLWD-AMT-CP-TWR (TWR-CRG-SUB) -
                    AMT-PAID-OTHER-CARR-1-CP-TWR (TWR-CRG-SUB) -
                    AMT-PAID-OTHER-CARR-2-CP-TWR (TWR-CRG-SUB) -
                    HOLD-FKR-SAVINGS)
           END-COMPUTE

           COMPUTE ECF-TOTAL-CLAIM-AMOUNT =
                  ECF-SNF-HIST-TOTAL-PAID +
                  ECF-SNF-CURR-TOTAL-PAID
           END-COMPUTE
      *%%% EL TT# 7539 END

           IF  ECF-SNF-CURR-CHRG-PAID > 0
               EVALUATE TRUE
                 WHEN ECF-TOTAL-CLAIM-AMOUNT = ECF-MAX-ALLOWABLE
                   MOVE R-FKR TO ERROR-REASON
                   SET REJECT-THIS-CHARGE TO TRUE
                   PERFORM 9900-ERROR-ROUTINE
                      THRU 9900-EXIT
                 WHEN OTHER
                   COMPUTE ECF-TOTAL-CLAIM-AMOUNT =
                           ECF-TOTAL-CLAIM-AMOUNT +
                           ECF-SNF-CURR-CHRG-PAID
                   END-COMPUTE
                   IF  ECF-TOTAL-CLAIM-AMOUNT > ECF-MAX-ALLOWABLE
                       COMPUTE PARTIAL-REJECT-AMOUNT-TWR (TWR-CRG-SUB) =
                               ECF-TOTAL-CLAIM-AMOUNT    -
                               ECF-MAX-ALLOWABLE
                       END-COMPUTE
                       COMPUTE ECF-SNF-CURR-CHRG-PAID    =
                               ECF-SNF-CURR-CHRG-PAID    -
                               PARTIAL-REJECT-AMOUNT-TWR (TWR-CRG-SUB)
                       END-COMPUTE
                       COMPUTE AMOUNT-PAYABLE            =
                               AMOUNT-PAYABLE            -
                               PARTIAL-REJECT-AMOUNT-TWR (TWR-CRG-SUB)
                       END-COMPUTE
                       MOVE R-FKR
                         TO PART-REJECT-REASON-TWR-AF (TWR-CRG-SUB)
                   END-IF

                   COMPUTE ECF-SNF-CURR-TOTAL-PAID =
                           ECF-SNF-CURR-TOTAL-PAID +
                           ECF-SNF-CURR-CHRG-PAID
                   END-COMPUTE
               END-EVALUATE
           END-IF
      *%%% EL TT# 100638 - END
           .
       2060-EXIT.
           EXIT.

      *%%% EL TT# 7539 BEGIN
       2065-RECALC-SNF-CURR-PAID.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            RE-CALCULATE THE SNF CURRENT TOTAL PAID
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           COMPUTE ECF-SNF-CURR-TOTAL-PAID =
                   ECF-SNF-CURR-TOTAL-PAID -
                   (OTH-CARR-MED-ALLWD-AMT-CP-TWR (TWR-CRG-SUB) -
                    AMT-PAID-OTHER-CARR-1-CP-TWR (TWR-CRG-SUB) -
                    AMT-PAID-OTHER-CARR-2-CP-TWR (TWR-CRG-SUB) -
                    HOLD-FKR-SAVINGS)
           END-COMPUTE
           .
       2065-EXIT.
           EXIT.
      *%%% EL TT# 7539 END
      *%%% P7 TT# 983486 START
       2070-ACCESS-MED-MAX-AMTS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   RETRIEVE THE ECF MAX ALLOWABLE AMOUNT
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      ******************************************************************
      * MOVING VALUES INTO HOST VARIABLES TO SEARCH MEDICARE_MAX_AMT
      * FOR THE ECF MAX ALLOWABLE AMOUNT FOR THE GIVEN YEAR.
      ******************************************************************

           MOVE DATE-PROCESSED-CENT-TWR TO FEP-CENTURY-DATE.
           PERFORM 9700-CONVERT-FEP-CENTURY-DT THRU 9700-EXIT.
           MOVE MMDDCCYY-MM   TO MED-MAX-SYS-EFF-DT-MM.
           MOVE MMDDCCYY-DD   TO MED-MAX-SYS-EFF-DT-DD.
           MOVE MMDDCCYY-CCYY TO MED-MAX-SYS-EFF-DT-CCYY.

           MOVE MED-MAX-SYS-EFF-DT TO SYSTEM-EFF-DT OF
                            DCLMEDICARE-MAX-AMT.

      *%%% PE TT# 1043099 BEGIN
           IF (INPAT-INSTITUTE-TYPE-CLAIM-TWR (TWR-CRG-SUB) OR
                OTPAT-INSTITUTE-TYPE-CLAIM-TWR(TWR-CRG-SUB))
               MOVE STATEMENT-END-MONTH-TWR TO
                 MED-MAX-EFF-DT-MM
               MOVE STATEMENT-END-DAY-TWR TO
                 MED-MAX-EFF-DT-DD
               MOVE STATEMENT-END-YEAR4-TWR TO
                 MED-MAX-EFF-DT-CCYY
           ELSE
             MOVE SERVICE-BEGIN-MONTH-TWR (TWR-CRG-SUB)
                  TO MED-MAX-EFF-DT-MM
             MOVE SERVICE-BEGIN-DAY-TWR (TWR-CRG-SUB)
                  TO MED-MAX-EFF-DT-DD
             MOVE SERVICE-BEGIN-YEAR4-TWR (TWR-CRG-SUB)
                  TO MED-MAX-EFF-DT-CCYY
           END-IF.
      *%%% PE TT# 1043099 END
           MOVE MED-MAX-EFF-DT TO MDCR-MAX-EFF-DT OF
                            DCLMEDICARE-MAX-AMT.

      ******************************************************************
      * DB2 SELECTING MDCR_MAX_AMT FROM THE MEDICARE_MAX_AMT TABLE.
      ******************************************************************

           EXEC SQL
                SELECT
                  A.MDCR_MAX_AMT
                INTO
                  :DCLMEDICARE-MAX-AMT.MDCR-MAX-AMT
                FROM
                  MEDICARE_MAX_AMT A
                WHERE
                  MDCR_MAX_TYPE_CD = 'MED-A-MAX-ECFSNF'
                  AND :DCLMEDICARE-MAX-AMT.MDCR-MAX-EFF-DT
                      BETWEEN MDCR_MAX_EFF_DT AND MDCR_MAX_TRM_DT
                  AND :DCLMEDICARE-MAX-AMT.SYSTEM-EFF-DT
                      BETWEEN SYSTEM_EFF_DT AND SYSTEM_TRM_DT
           END-EXEC

           MOVE SQLCODE                  TO SQL-SQLCODE

           EVALUATE  TRUE
             WHEN SQL-SUCCESS
               MOVE MDCR-MAX-AMT OF DCLMEDICARE-MAX-AMT
                 TO ECF-MAX-ALLOWABLE
             WHEN SQL-NOTFND
               CONTINUE
             WHEN OTHER
               PERFORM 2075-MEDMAX-ERR-ROUTINE
                  THRU 2075-EXIT
           END-EVALUATE
           .
       2070-EXIT.
           EXIT.

       2075-MEDMAX-ERR-ROUTINE.
           MOVE SPACES TO WS-V-MESSAGE-2.
           SET MABPAA-UNKNOWN-SQL-MSG TO TRUE.
           MOVE MGMT-ALERT-MED-MAX TO WS-V-MESSAGE-2.
           MOVE 2070 TO WS-V-ERROR-PARA.
           SET SELECT-ROW TO TRUE
           SET FEP-MAF-EXCPT-WARNING TO TRUE.
           SET FEP-MAF-DB2-SOFTWARE TO TRUE.
           MOVE SQL-SQLCODE TO WS-V-SQL-CODE.
           PERFORM 9880-ERROR-RTN THRU 9880-EXIT.

       2075-EXIT.
           EXIT.
      *%%% P7 TT# 983486 END

       2090-EOB-REMARKS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *             MOVE EOB REMARKS TO CHARGE LINE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           IF  BG-CLAIM-ACTION-ATTACH-EOB
               MOVE 'E'              TO HOLD-REMARK-CODE (1:1)
               MOVE BG-SVC-REMARK-CD TO HOLD-REMARK-CODE (2:3)
               PERFORM 2099-ATTACH-REMARK THRU 2099-EXIT
           END-IF
           .
       2090-EXIT.
           EXIT.

       2099-ATTACH-REMARK.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *             MOVE EOB REMARK TO CHARGE LINE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           EVALUATE TRUE
              WHEN EOB-REMARK-CODE-1-TWR (TWR-CRG-SUB) =
                   HOLD-REMARK-CODE
              WHEN EOB-REMARK-CODE-2-TWR (TWR-CRG-SUB) =
                   HOLD-REMARK-CODE
              WHEN EOB-REMARK-CODE-3-TWR (TWR-CRG-SUB) =
                   HOLD-REMARK-CODE
              WHEN EOB-REMARK-CODE-4-TWR (TWR-CRG-SUB) =
                   HOLD-REMARK-CODE
                   GO TO 2099-EXIT
           END-EVALUATE

           EVALUATE TRUE
              WHEN EOB-REMARK-CODE-1-TWR (TWR-CRG-SUB) = '    '
                 MOVE HOLD-REMARK-CODE
                   TO EOB-REMARK-CODE-1-TWR (TWR-CRG-SUB)
              WHEN EOB-REMARK-CODE-2-TWR (TWR-CRG-SUB) = '    '
                 MOVE HOLD-REMARK-CODE
                   TO EOB-REMARK-CODE-2-TWR (TWR-CRG-SUB)
              WHEN EOB-REMARK-CODE-3-TWR (TWR-CRG-SUB) = '    '
                 MOVE HOLD-REMARK-CODE
                   TO EOB-REMARK-CODE-3-TWR (TWR-CRG-SUB)
              WHEN EOB-REMARK-CODE-4-TWR (TWR-CRG-SUB) = '    '
                 MOVE HOLD-REMARK-CODE
                   TO EOB-REMARK-CODE-4-TWR (TWR-CRG-SUB)
           END-EVALUATE
           .
       2099-EXIT.
           EXIT.

       2100-FORMAT-F030.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *             FORMAT THE F030 FROM PATIENT/FAMILY WORK RECS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET FH02P3M1-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      F030-PROCESS-SW
                                      FIRST-CHARGE-SWITCH
                                      TWR-CRG-SUB
                                      LIFETIME-HOLD
                                      F030-COMMON-NAMES
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      FAMILY-WORK-RECORD
                                      PATIENT-WORK-RECORD
                                      TWR-AUXILIARY-FIELDS
                                      TRANSACTION-WORK-RECORD
                                      FH01-EXECUTIVE-DATA-FIELDS
      * TT 48053
                                      F00050-TABLE
                                      CA-F00050-TABLE
                                      MHSA-TREAT-PLAN-ARRAY
      * TT 48053
                ON EXCEPTION
                   MOVE 2100                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT

      *%%% EL TT# 802259/802262 - BEGIN
           IF BEGIN-CHARGE
              MOVE FAMILY-CAT-ACCUM-F030
                TO CAT-APPL-PR-TO-CRG
              MOVE FAMILY-PPO-ACCUM-F030
                TO PPO-APPL-PR-TO-CRG
              MOVE MEMBER-CAT-ACCUM-F030
                TO MBR-CAT-APPL-PR-TO-CRG
              MOVE MEMBER-PPO-CAT-ACCUM-F030
                TO MBR-PPO-APPL-PR-TO-CRG
           END-IF
      *%%% EL TT# 802259/802262 - END
           .
       2100-EXIT.
           EXIT.
      *
       2200-CIRCUMSTANCES.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *             FIND BEST MATCHING CIRCUMSTANCE FRO THE SERVICE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           IF  NO-BA-TABLES-PROCESSING (TWR-CRG-SUB)
               GO TO 2200-EXIT
           END-IF

           SET FH02P3M2-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-CRG-SUB
                                      PATIENT-WORK-RECORD
                                      FH01-EXECUTIVE-DATA-FIELDS
                                      TWR-AUXILIARY-FIELDS
                                      BENEFIT-GROUP
                                      COVERED-SERVICE-GROUP
                                      F030-COMMON-NAMES
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      EDIT-SUPP-HIST-INFO
      * TT 48053
                                      CA-F00050-TABLE
      * TT 48053
                ON EXCEPTION
                   MOVE 2200                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL

           MOVE BG-SERVICE-ACCUM-ID
              TO HOLD-BG-SERVICE-ACCUM-ID-BEN

      **% PE SRTS 1363045
           IF PLAN-APPROVED AND NOT BG-ALL-ACCUMS-BEN
              IF  DEFER-THIS-CHARGE
              OR  REJECT-THIS-CHARGE
                  INITIALIZE ERROR-REASON
                             ERROR-REASON-ACTION
                  SET NO-BA-TABLES-PROCESSING (TWR-CRG-SUB) TO TRUE
              END-IF
           END-IF

           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       2200-EXIT.
           EXIT.
      *
       2300-PAYMENT-LEVEL.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            GET THE PAYMENT LEVEL INFORMATION
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET FH02P3M3-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-CRG-SUB
                                      F030-COMMON-NAMES
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      BENEFIT-GROUP
                                      COVERED-SERVICE-GROUP
                                      BENEFIT-ADMN-PAY-LVL-TABLE
                ON EXCEPTION
                   MOVE 2300                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       2300-EXIT.
           EXIT.

       2400-PRICING.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *         CALCULATE SAVINGS & ALLOWABLE CHARGE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           SET FH02P3M4-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-CRG-SUB
                                      COVERED-SERVICE-GROUP
                                      BENEFIT-ADMN-PAY-LVL-TABLE
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      PERF-PROVIDER-COPAY-TABLE
                                      F030-COMMON-NAMES
      *%%% EL TT# 380793 - BEGIN
                                      PATIENT-WORK-RECORD
      *%%% EL TT# 380793 - END
                                      TRANSACTION-PRI-RECORD
                ON EXCEPTION
                   MOVE 2400                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL

           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       2400-EXIT.
           EXIT.

       2500-VA-DOD-IHF.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            PERFORM VA/DOD/IHF PROCESSING
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET FH02P3M5-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-AUXILIARY-FIELDS
                                      TWR-CRG-SUB
                                      FH01-EXECUTIVE-DATA-FIELDS
                                      F030-COMMON-NAMES
                                      P0M3-EXECUTIVE-DATA-FIELDS
                ON EXCEPTION
                   MOVE 2500                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       2500-EXIT.
           EXIT.

       2600-DEDUCTIBLE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            CALCULATE DEDUCTIBLE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET DCTB-COINS-UPDATE-ACCUMULATORS TO TRUE
           SET FH02P3M6-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-AUXILIARY-FIELDS
                                      TWR-CRG-SUB
                                      COVERED-SERVICE-GROUP
                                      BENEFIT-ADMN-PAY-LVL-TABLE
                                      F030-COMMON-NAMES
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      PATIENT-WORK-RECORD
                ON EXCEPTION
                   MOVE 2600                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       2600-EXIT.
           EXIT.

       2700-COIN-COPAY.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            CALCULATE COINSURANCE OR COPAY
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET DCTB-COINS-UPDATE-ACCUMULATORS TO TRUE
           SET FH02P3M7-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-AUXILIARY-FIELDS
                                      TWR-CRG-SUB
                                      COVERED-SERVICE-GROUP
                                      BENEFIT-ADMN-PAY-LVL-TABLE
                                      F030-COMMON-NAMES
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      PERF-PROVIDER-COPAY-TABLE
                                      PATIENT-WORK-RECORD
                ON EXCEPTION
                   MOVE 2700                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT

           COMPUTE AMOUNT-PAYABLE
              = CHRG-ALLOWABLE-CHARGES-CP-TWR (TWR-CRG-SUB)
              - DEDUCT-AMOUNT
              - COINSURANCE-AMOUNT
           END-COMPUTE
           .
       2700-EXIT.
           EXIT.

       2800-SPCL-AMT-PAYABLE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            SPECIAL AMT PAYABLE CALCS - PHARMACY & POS COB
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET FH02P3M8-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-CRG-SUB
                                      P0M3-EXECUTIVE-DATA-FIELDS
      *%%% EL CMR 373029 BEGIN
                                      TRANSACTION-DISP-3-RECORD
      *%%% EL CMR 373029 END
                ON EXCEPTION
                   MOVE 2800                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       2800-EXIT.
           EXIT.

       2900-COB-SECONDARY.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   CALC SECONDARY BENEFIT - HOLD PRIM & SECVERSIONS OF CHRG
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           INITIALIZE ERROR-REASON
                      ERROR-REASON-ACTION

           SET FH02P3M9-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-AUXILIARY-FIELDS
                                      PATIENT-WORK-RECORD
                                      TWR-CRG-SUB
                                      BENEFIT-ADMN-PAY-LVL-TABLE
                                      FH01-EXECUTIVE-DATA-FIELDS
                                      FH01-OVERRIDES-AREAS
      *%%% EL TT# 86219/89136 - BEGIN
                                      LIFETIME-HOLD
      *%%% EL TT# 86219/89136 - END
                                      F030-COMMON-NAMES
                                      SUPPORTING-HISTORY-WORK-RECORD
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      TOTALS-ACCUMULATIONS
                                      PRIMARY-SUPPORTING-HIST-TAB
                                      SECOND-SUP-HIST-HOLD
                                      HOLDA-AUXILIARY-FIELDS
                                      TRANSACTION-COB-RECORD
                                      BENEFIT-GROUP
                ON EXCEPTION
                   MOVE 2900                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT

      *-----------------------------------------------------------------
      *  ADD A COUNTER TO KEEP TRACK OF THE NUMBER OF APPROVED LINES
      *  WITH COB IN ORDER TO AVOID GENERATING AN N4 LINE IF NO COB
      *  LINES ARE APPROVED.
      *-----------------------------------------------------------------
      *
           EVALUATE TRUE
              WHEN (TS1-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
                    OR TS1-NEG-COB-APPLICABLE-TWR (TWR-CRG-SUB)
                    OR (TS1-MED-PREPAID-TWR (TWR-CRG-SUB)
                        AND DENTAL-CARE-TWR (TWR-CRG-SUB))
      *%%% PE TT 407750
                    OR (APOC1-TRAD-MEDICARE-PART-D-TWR (TWR-CRG-SUB)
      *%%% TT 344326  KJ BEGIN
                        AND (RETAIL-DRUG-PROGRAM-TWR
                              OR SPECIALTY-DRUG-TWR)
                        AND TS1-MEDICARE-OV65-TWR (TWR-CRG-SUB))
                    OR (APOC1-TRAD-MEDICARE-PART-D-TWR (TWR-CRG-SUB)
                        AND (RETAIL-DRUG-PROGRAM-TWR
                              OR SPECIALTY-DRUG-TWR)
                        AND TS1-MEDICARE-UN65-TWR (TWR-CRG-SUB)))
              WHEN (TS2-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
                    OR TS2-NEG-COB-APPLICABLE-TWR (TWR-CRG-SUB)
                    OR (TS2-MED-PREPAID-TWR (TWR-CRG-SUB)
                        AND DENTAL-CARE-TWR (TWR-CRG-SUB))
      *%%% PE TT 407750
                    OR (APOC1-TRAD-MEDICARE-PART-D-TWR (TWR-CRG-SUB)
                        AND (RETAIL-DRUG-PROGRAM-TWR
                              OR SPECIALTY-DRUG-TWR)
                        AND TS2-MEDICARE-OV65-TWR (TWR-CRG-SUB))
                    OR (APOC1-TRAD-MEDICARE-PART-D-TWR (TWR-CRG-SUB)
                        AND (RETAIL-DRUG-PROGRAM-TWR
                              OR SPECIALTY-DRUG-TWR)
                        AND TS2-MEDICARE-UN65-TWR (TWR-CRG-SUB)))
              WHEN (TS3-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
                    OR TS3-NEG-COB-APPLICABLE-TWR (TWR-CRG-SUB)
                    OR (TS3-MED-PREPAID-TWR (TWR-CRG-SUB)
                        AND DENTAL-CARE-TWR (TWR-CRG-SUB))
      *%%% PE TT 407750
                    OR (APOC1-TRAD-MEDICARE-PART-D-TWR (TWR-CRG-SUB)
                        AND (RETAIL-DRUG-PROGRAM-TWR
                              OR SPECIALTY-DRUG-TWR)
                        AND TS3-MEDICARE-OV65-TWR (TWR-CRG-SUB))
                    OR (APOC1-TRAD-MEDICARE-PART-D-TWR (TWR-CRG-SUB)
                        AND (RETAIL-DRUG-PROGRAM-TWR
                              OR SPECIALTY-DRUG-TWR)
                        AND TS3-MEDICARE-UN65-TWR (TWR-CRG-SUB)))
              WHEN (TS4-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
                    OR TS4-NEG-COB-APPLICABLE-TWR (TWR-CRG-SUB)
                    OR (TS4-MED-PREPAID-TWR (TWR-CRG-SUB)
                        AND DENTAL-CARE-TWR (TWR-CRG-SUB))
      *%%% PE TT 407750
                    OR (APOC1-TRAD-MEDICARE-PART-D-TWR (TWR-CRG-SUB)
                        AND (RETAIL-DRUG-PROGRAM-TWR
                              OR SPECIALTY-DRUG-TWR)
                        AND TS4-MEDICARE-OV65-TWR (TWR-CRG-SUB))
                    OR (APOC1-TRAD-MEDICARE-PART-D-TWR (TWR-CRG-SUB)
                        AND (RETAIL-DRUG-PROGRAM-TWR
                              OR SPECIALTY-DRUG-TWR)
      *%%% TT 344326  KJ END
                        AND TS4-MEDICARE-UN65-TWR (TWR-CRG-SUB)))
                 IF  ANY-APP-AFFECTED-CHRG-TWR (TWR-CRG-SUB)
                     ADD +01 TO TOTAL-COB-APP-CHGS-PRIME
                 END-IF
           END-EVALUATE
           .
       2900-EXIT.
           EXIT.

       2999-PERF-PROV-COPAY-TABLE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            BUILD PERF-PROVIDER-COPAY-TABLE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           SET FH02P3MH-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      TRANSACTION-WORK-RECORD
                                      TWR-CRG-SUB
                                      FH01-EXECUTIVE-DATA-FIELDS
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      PERF-PROVIDER-COPAY-TABLE
                                      BENEFIT-ADMN-PAY-LVL-TABLE
                ON EXCEPTION
                   MOVE 2999                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           .
       2999-EXIT.
           EXIT.

       3200-SH-LINES-TO-TABLES.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *  MOVE PRIMARY SUPPORTING HISTORY LINE TO BOTH THE PRIMARY
      *  AND SECONDARY TABLE.  SECONDARY LINES WILL GET OVERLAYED IN
      *  FH02P3MA IF WE PAY AS SECONDARY.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *
            MOVE   SORTWORD-SHWR
              TO   PRIMARY-SHWR-REC (TWR-CRG-SUB)
                   SECONDARY-SHWR-REC (TWR-CRG-SUB)
      *
            MOVE   LINE-CODE-SHBR
              TO   LINE-CODE-PRIME (TWR-CRG-SUB)
                   LINE-CODE-SECOND (TWR-CRG-SUB)
            MOVE   CONTRACT-ID-NUMBER-SHBR
              TO   SUB-ID-NO-PRIME (TWR-CRG-SUB)
                   SUB-ID-NO-SECOND (TWR-CRG-SUB)
            MOVE   REPORTING-PLAN-CODE-SHBR
              TO   PLAN-CODE-PRIME (TWR-CRG-SUB)
                   PLAN-CODE-SECOND (TWR-CRG-SUB)
            MOVE   CLAIM-NUMBER-SHBR
              TO   CLAIM-NO-PRIME (TWR-CRG-SUB)
                   CLAIM-NO-SECOND (TWR-CRG-SUB)
            MOVE   TRANSACTION-ID-SHBR
              TO   TRANSACTION-ID-PRIME    (TWR-CRG-SUB)
                   TRANSACTION-ID-SECOND   (TWR-CRG-SUB)
            MOVE   AFFECTING-TS-SHBR
              TO   AFFECTING-TS-PRIME      (TWR-CRG-SUB)
                   AFFECTING-TS-SECOND     (TWR-CRG-SUB)
            MOVE   PROCESSING-DT-SHBR
              TO   PROCESSING-DT-SECOND    (TWR-CRG-SUB)
                   PROCESSING-DT-PRIME     (TWR-CRG-SUB)
            MOVE   OC-BATCH-ID-SHBR
              TO   OC-BATCH-ID-PRIME       (TWR-CRG-SUB)
                   OC-BATCH-ID-SECOND      (TWR-CRG-SUB).
      *
      *-----------------------------------------------------------------
      *  IF THE PRIMARY MET LIFE MAX WE NEED TO DUMMY OUT THE PRIMARY
      *  SUPPORTING HISTORY LINE BUT NOT THE SECONDARY ONE.
      *  WE CHECK FOR REJECT STATUS SO WE WILL NOT DUMMY A PARTIAL
      *  REJECTED LINE WHICH HAS AN APPROVED STATUS.
      *-----------------------------------------------------------------
      *
            IF PRIMARY-LIFE-MET
                AND REJECT-THIS-CHARGE
                MOVE SUPPORTING-HISTORY-DATA-SHBR TO
                     COB-SECOND-LINE (TWR-CRG-SUB)
                     COB-PRIME-LINE (TWR-CRG-SUB)
                MOVE '999999999'   TO SUB-ID-NO-PRIME (TWR-CRG-SUB)
                GO TO 3200-EXIT.
      *
      *-----------------------------------------------------------------
      *  NEED TO PRODUCE A DUMMY SUPPORTING HISTORY LINE FOR REJECTED
      *  LINES AND DISP-6 HISTORY LINES, OTHERWISE NOT ALL LINES WILL BE
      *  WRITTEN AT END OF CLAIM
      *-----------------------------------------------------------------
      *
            IF  PLAN-REJECTED-CHRG-COB (TWR-CRG-SUB)
            OR  ANY-REJ-AFFECTED-CHRG-COB (TWR-CRG-SUB)
            OR  HISTORY-CHRG-REJECTED-COB (TWR-CRG-SUB)
      *%%% KX TT 49146 - BEGIN
      *     OR  (DISPOSITION-6-TWR AND
      *             CHRG-NOT-SENT-BY-PLAN-HCL)
      *%%% KX TT 49146 - END
                MOVE '999999999'   TO  SUB-ID-NO-PRIME (TWR-CRG-SUB)
                                       SUB-ID-NO-SECOND (TWR-CRG-SUB)
                GO TO 3200-EXIT
            END-IF

            MOVE   SUPPORTING-HISTORY-DATA-SHBR
              TO   COB-PRIME-LINE (TWR-CRG-SUB)
                   COB-SECOND-LINE (TWR-CRG-SUB)
           .
       3200-EXIT.
           EXIT.

       4000-TIMELY-FILING.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *     MAIN CONTROL ROUTINE FOR TIMELY FILING CLAIMS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

            IF  ANY-REJ-AFFECTED-CHRG-TWR (TWR-CRG-SUB)
            OR  PLAN-REJECTED-CHRG-TWR (TWR-CRG-SUB)
                ADD 1 TO TOTAL-REJECTED-CHARGES
            END-IF

      *%%% TT 49146 - BEGIN
      *    IF  DISPOSITION-6-TWR AND
      *        CHRG-NOT-SENT-BY-PLAN-TWR (TWR-CRG-SUB)
      *        GO TO 4000-EXIT
      *    END-IF
      *%%% TT 49146 - END
      *
      *----------------------------------------------------------------
      *    THE CHARGE MUST BE QUALIFIED OR APPROVED TO GENERATE
      *    SUPPORTING HISTORY LINES AND/OR UPDATE LIFETIME MAXIMUMS.
      *   NOTE:  THE CHARGE CANNOT BE DEFERRED AT THIS POINT.
      *----------------------------------------------------------------
      *
           IF  NOT (APPROVED-CHRG-TWR (TWR-CRG-SUB)
           OR  HISTORY-CHRG-APPROVED-TWR (TWR-CRG-SUB))
               GO TO 4000-EXIT
           END-IF
      *
      *-----------------------------------------------------------------
      *   INITIALIZE THE FIELDS NEEDED FOR THE CHARGE LINE.
      *-----------------------------------------------------------------
      *
           PERFORM 2020-INITIALIZE-CHARGE THRU 2020-EXIT

      *----------------------------------------------------------------
      * DISP 4'S SHOULD ONLY WRITE SUPP HIST.
      *----------------------------------------------------------------

            IF  DISP4-1STEP-TWR
            OR  HISTORY-CHRG-APPROVED-TWR (TWR-CRG-SUB)
                CONTINUE
            ELSE

      *------------------------------------------------------------
      *  NON-HISTORY CHARGES AUTOMATICALLY GET EITHER A 'P' OR A
      *  'Y' IN THE DEDUCTIBLE AND COINSURANCE CODES.  WE THEN
      *  NEED TO FILL IN THE CODES ON THE TWR AS WELL AS THE N1
      *  LINE.
      *------------------------------------------------------------

               IF DEDUCTIBLE-AMOUNT-CP-TWR (TWR-CRG-SUB) > ZERO
                   MOVE 'Y' TO DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
               ELSE
                   MOVE 'P' TO DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
               END-IF

               IF COINSURANCE-AMOUNT-CP-TWR (TWR-CRG-SUB) > ZERO
                   MOVE 'Y' TO COINSURANCE-CODE-TWR (TWR-CRG-SUB)
               ELSE
                   MOVE 'P' TO COINSURANCE-CODE-TWR (TWR-CRG-SUB)
               END-IF
           END-IF

      *----------------------------------------------------------------
      *  APPROVED CLAIMS GENERATE "N1" LINES
      *----------------------------------------------------------------

           PERFORM 9400-HIST-AND-TIMELY-FILING-N1 THRU 9400-EXIT
           .
       4000-EXIT.
           EXIT.

       5000-FINALIZATION.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *    FINALIZATION OF CLAIM BEFORE RETURN TO CALLING MODULE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *-----------------------------------------------------------------
      *   NOW THAT ALL THE CHARGES HAVE BEEN PROCESSED WE NEED TO GO
      *   BACK THRU THE CHRGS FOR MULTI-LINE CLAIMS THAT HAD
      *   TYPE SAVINGS C, F, OR G ON ONE/SOME OF THE CHARGE LINES
      *   OR OVERRIDE FNM WAS ON ONE/SOME OF THE CHARGE LINES AND IT
      *   WAS DETERMINED THAT THE SUB LIABILITY COULD NOT BE CALCULATED.
      *   THE SUB LIABILITY THAT WAS CALCULATED ON THE OTHER CHARGES
      *   NEEDS TO BE WIPED OUT.
      *-----------------------------------------------------------------
      *
            IF CANNOT-CALC-SUB-LIAB
               MOVE '0' TO SUB-LIABILITY-IND-TWR-AF
               PERFORM VARYING TWR-CRG-SUB FROM 1 BY 1
                  UNTIL TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR
                  MOVE SPACES
                    TO CHRG-SUB-LIABILITY-AMT-AN-TWR (TWR-CRG-SUB)
               END-PERFORM
            END-IF
      *
      *
      *-----------------------------------------------------------------
      * REJECT THE CLAIM IF ALL INCOMING DISP6 LINES ARE REJECTED OR
      * ALL LINES ARE REJECTED
      *-----------------------------------------------------------------
      *
      *%%% KX TT 49146 - BEGIN
      *    IF  (DISPOSITION-6-TWR     AND
      *         TOTAL-REJ-DISP6-CHARGES = NUMBER-OF-CHARGES-SUB-TWR)
      *    OR  (TOTAL-REJECTED-CHARGES >= NUMBER-OF-CHARGES-TWR)
           IF  (TOTAL-REJECTED-CHARGES >= NUMBER-OF-CHARGES-TWR)
      *%%% KX TT 49146 - END
               PERFORM VARYING TWR-CRG-SUB FROM 1 BY 1
                 UNTIL TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR
                   PERFORM VARYING ORG-CRG-SUB FROM 1 BY 1
                     UNTIL ORG-CRG-SUB > NUMBER-OF-CHARGES-ORG
                       IF LINE-NUMBER-ORG (ORG-CRG-SUB) =
                          LINE-NUMBER-TWR (TWR-CRG-SUB)
                          MOVE CHRG-RESPONSE-REASON-1-TWR (TWR-CRG-SUB)
                            TO CHRG-RESPONSE-REASON-1-ORG (ORG-CRG-SUB)
                          MOVE CHARGE-STATUS-TWR (TWR-CRG-SUB)
                            TO CHARGE-STATUS-ORG (ORG-CRG-SUB)
                       END-IF
                   END-PERFORM
               END-PERFORM
      *
               MOVE TRANSACTION-ORG-RECORD
                 TO TRANSACTION-WORK-RECORD
                    (1:LENGTH OF TRANSACTION-ORG-RECORD)
               MOVE '30' TO CLAIM-STATUS-TWR
               MOVE ' ' TO CLAIM-SUPPORT-HIST-SW-TWR
               MOVE SPACES TO CLAIM-RESPONSE-REASONS-TWR
           END-IF
      *
           IF APPROVED-CLAIM-TWR
              PERFORM VARYING TWR-CRG-SUB FROM 1 BY 1 UNTIL
                      TWR-CRG-SUB > NUMBER-OF-CHARGES-TWR
                    IF AMOUNT-PAID-CP-TWR(TWR-CRG-SUB) IS NEGATIVE
                      MOVE LINE-NUMBER-TWR(TWR-CRG-SUB) TO LINE-NUMBER
                      MOVE YES TO DEFER-FP8-SW
                    END-IF
      *%%% EL TT# 14791 BEGIN
                    PERFORM 5100-SHIFT-SAVINGS THRU 5100-EXIT
      *%%% EL TT# 14791 END
              END-PERFORM
           END-IF
           IF  YES-DEFER-FP8
               MOVE R-FP8 TO ERROR-REASON
               SET CANNOT-PROCESS-THIS-CHARGE TO TRUE
               SET   PROG-MSG                    TO  TRUE
               MOVE  5000            TO WS-V-ERROR-PARA
               SET   FEP-MAF-OTHER-SOFTWARE      TO TRUE
               MOVE  2000           TO FEP-MAF-EXCPT-MSG-ID-SUFFIX
               MOVE  SPACES         TO WS-V-ERR-MESSAGE-TEXT
               MOVE  NEG-AMT-PAID-MSG
                                    TO WS-V-ERR-MESSAGE-TEXT
               SET FEP-MAF-EXCPT-INFORMATIONAL TO TRUE
               PERFORM 9880-ERROR-RTN THRU 9880-EXIT
               PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
           END-IF

           PERFORM 8000-CHECK-FOR-COB-REJ
              THRU 8000-EXIT
              VARYING TWR-CRG-SUB      FROM 1 BY 1
                UNTIL TWR-CRG-SUB      >  NUMBER-OF-CHARGES-TWR

           IF  PROCESS-PERIOD-NOT-ON-FILE
               CONTINUE
           ELSE
               PERFORM 5880-UPDATE-BENEFIT-PERIODS
                  THRU 5880-EXIT
           END-IF
           .
       5000-EXIT.
           EXIT.

      *%%% EL TT# 14791 BEGIN
       5100-SHIFT-SAVINGS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      * MOVE THE FOUR SAVINGS CODES AND SAVINGS AMOUNTS TO HOLD FIELDS
      * BLANK OUT THE SAVINGS CODES AND SAVINGS AMOUNTS ON THE CHARGE
      * MOVE HOLD SAVINGS CODES AND HOLD SAVINGS AMOUNTS BACK TO THE
      * CHARGE IF THE HOLD SAVINGS AMOUNT IS GREATER THAN ZERO.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           MOVE TYPE-SAVINGS-IND-1-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-IND-1
           MOVE SAVINGS-AMOUNT-1-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-AMT-1
           MOVE SAVINGS-AMOUNT-1-CP-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-AMT-1-CP
           MOVE SPACES
             TO TYPE-SAVINGS-IND-1-TWR (TWR-CRG-SUB)
                SAVINGS-AMOUNT-1-TWR (TWR-CRG-SUB)
           MOVE ZEROES
             TO SAVINGS-AMOUNT-1-CP-TWR (TWR-CRG-SUB)

           MOVE TYPE-SAVINGS-IND-2-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-IND-2
           MOVE SAVINGS-AMOUNT-2-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-AMT-2
           MOVE SAVINGS-AMOUNT-2-CP-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-AMT-2-CP
           MOVE SPACES
             TO TYPE-SAVINGS-IND-2-TWR (TWR-CRG-SUB)
                SAVINGS-AMOUNT-2-TWR (TWR-CRG-SUB)
           MOVE ZEROES
             TO SAVINGS-AMOUNT-2-CP-TWR (TWR-CRG-SUB)

           MOVE TYPE-SAVINGS-IND-3-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-IND-3
           MOVE SAVINGS-AMOUNT-3-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-AMT-3
           MOVE SAVINGS-AMOUNT-3-CP-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-AMT-3-CP
           MOVE SPACES
             TO TYPE-SAVINGS-IND-3-TWR (TWR-CRG-SUB)
                SAVINGS-AMOUNT-3-TWR (TWR-CRG-SUB)
           MOVE ZEROES
             TO SAVINGS-AMOUNT-3-CP-TWR (TWR-CRG-SUB)

           MOVE TYPE-SAVINGS-IND-4-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-IND-4
           MOVE SAVINGS-AMOUNT-4-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-AMT-4
           MOVE SAVINGS-AMOUNT-4-CP-TWR (TWR-CRG-SUB)
             TO HOLD-SAVINGS-AMT-4-CP
           MOVE SPACES
             TO TYPE-SAVINGS-IND-4-TWR (TWR-CRG-SUB)
                SAVINGS-AMOUNT-4-TWR (TWR-CRG-SUB)
           MOVE ZEROES
             TO SAVINGS-AMOUNT-4-CP-TWR (TWR-CRG-SUB)

           IF  HOLD-SAVINGS-AMT-1-CP   NOT =  ZEROES
               MOVE HOLD-SAVINGS-IND-1     TO COMMON-SAVE-IND
               MOVE HOLD-SAVINGS-AMT-1-CP  TO SAVINGS-AMOUNT-WS
               PERFORM 5110-SEARCH-AMOUNTS THRU 5110-EXIT
           END-IF
           IF  HOLD-SAVINGS-AMT-2-CP   NOT =  ZEROES
               MOVE HOLD-SAVINGS-IND-2     TO COMMON-SAVE-IND
               MOVE HOLD-SAVINGS-AMT-2-CP  TO SAVINGS-AMOUNT-WS
               PERFORM 5110-SEARCH-AMOUNTS THRU 5110-EXIT
           END-IF
           IF  HOLD-SAVINGS-AMT-3-CP   NOT =  ZEROES
               MOVE HOLD-SAVINGS-IND-3     TO COMMON-SAVE-IND
               MOVE HOLD-SAVINGS-AMT-3-CP  TO SAVINGS-AMOUNT-WS
               PERFORM 5110-SEARCH-AMOUNTS THRU 5110-EXIT
           END-IF
           IF  HOLD-SAVINGS-AMT-4-CP   NOT =  ZEROES
               MOVE HOLD-SAVINGS-IND-4     TO COMMON-SAVE-IND
               MOVE HOLD-SAVINGS-AMT-4-CP  TO SAVINGS-AMOUNT-WS
               PERFORM 5110-SEARCH-AMOUNTS THRU 5110-EXIT
           END-IF
           .
       5100-EXIT.
           EXIT.

       5110-SEARCH-AMOUNTS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      * MOVE THE SAVINGS CODE AND SAVINGS AMOUNT TO THE FIRST
      * AVAILABLE SLOT ON THE CHARGE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           EVALUATE TRUE
      *%%% EL TT 18735 - BEGIN
             WHEN TYPE-SAVINGS-IND-1-TWR (TWR-CRG-SUB) = COMMON-SAVE-IND
               MOVE SAVINGS-AMOUNT-WS
                 TO SAVINGS-AMOUNT-1-CP-TWR (TWR-CRG-SUB)
                    HOLD-9-DIGIT-V99
               MOVE HOLD-9-DIGIT-NUMERIC
                 TO SAVINGS-AMOUNT-1-TWR (TWR-CRG-SUB)
             WHEN TYPE-SAVINGS-IND-2-TWR (TWR-CRG-SUB) = COMMON-SAVE-IND
               MOVE SAVINGS-AMOUNT-WS
                 TO SAVINGS-AMOUNT-2-CP-TWR (TWR-CRG-SUB)
                    HOLD-9-DIGIT-V99
               MOVE HOLD-9-DIGIT-NUMERIC
                 TO SAVINGS-AMOUNT-2-TWR (TWR-CRG-SUB)
             WHEN TYPE-SAVINGS-IND-3-TWR (TWR-CRG-SUB) = COMMON-SAVE-IND
               MOVE SAVINGS-AMOUNT-WS
                 TO SAVINGS-AMOUNT-3-CP-TWR (TWR-CRG-SUB)
                    HOLD-9-DIGIT-V99
               MOVE HOLD-9-DIGIT-NUMERIC
                 TO SAVINGS-AMOUNT-3-TWR (TWR-CRG-SUB)
             WHEN TYPE-SAVINGS-IND-4-TWR (TWR-CRG-SUB) = COMMON-SAVE-IND
               MOVE SAVINGS-AMOUNT-WS
                 TO SAVINGS-AMOUNT-4-CP-TWR (TWR-CRG-SUB)
                    HOLD-9-DIGIT-V99
               MOVE HOLD-9-DIGIT-NUMERIC
                 TO SAVINGS-AMOUNT-4-TWR (TWR-CRG-SUB)
      *%%% EL TT 18735 - END
             WHEN TYPE-SAVINGS-IND-1-TWR (TWR-CRG-SUB) = SPACES
               MOVE SAVINGS-AMOUNT-WS
                 TO SAVINGS-AMOUNT-1-CP-TWR (TWR-CRG-SUB)
                    HOLD-9-DIGIT-V99
               MOVE HOLD-9-DIGIT-NUMERIC
                 TO SAVINGS-AMOUNT-1-TWR (TWR-CRG-SUB)
               MOVE COMMON-SAVE-IND
                 TO TYPE-SAVINGS-IND-1-TWR (TWR-CRG-SUB)
             WHEN TYPE-SAVINGS-IND-2-TWR (TWR-CRG-SUB) = SPACES
               MOVE SAVINGS-AMOUNT-WS
                 TO SAVINGS-AMOUNT-2-CP-TWR (TWR-CRG-SUB)
                    HOLD-9-DIGIT-V99
               MOVE HOLD-9-DIGIT-NUMERIC
                 TO SAVINGS-AMOUNT-2-TWR (TWR-CRG-SUB)
               MOVE COMMON-SAVE-IND
                 TO TYPE-SAVINGS-IND-2-TWR (TWR-CRG-SUB)
             WHEN TYPE-SAVINGS-IND-3-TWR (TWR-CRG-SUB) = SPACES
               MOVE SAVINGS-AMOUNT-WS
                 TO SAVINGS-AMOUNT-3-CP-TWR (TWR-CRG-SUB)
                    HOLD-9-DIGIT-V99
               MOVE HOLD-9-DIGIT-NUMERIC
                 TO SAVINGS-AMOUNT-3-TWR (TWR-CRG-SUB)
               MOVE COMMON-SAVE-IND
                 TO TYPE-SAVINGS-IND-3-TWR (TWR-CRG-SUB)
             WHEN TYPE-SAVINGS-IND-4-TWR (TWR-CRG-SUB) = SPACES
               MOVE SAVINGS-AMOUNT-WS
                 TO SAVINGS-AMOUNT-4-CP-TWR (TWR-CRG-SUB)
                    HOLD-9-DIGIT-V99
               MOVE HOLD-9-DIGIT-NUMERIC
                 TO SAVINGS-AMOUNT-4-TWR (TWR-CRG-SUB)
               MOVE COMMON-SAVE-IND
                 TO TYPE-SAVINGS-IND-4-TWR (TWR-CRG-SUB)
           END-EVALUATE
           .
       5110-EXIT.
           EXIT.
      *%%% EL TT# 14791 END

       5880-UPDATE-BENEFIT-PERIODS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      * UPDATE THE BENEFIT PERIOD IN THE FAMILY AND PATIENT WORK
      * RECORDS SO THAT IF ANY UPDATE TAKES PLACE THE CORRECT
      * BENEFIT PERIOD WILL BE ON FILE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           EVALUATE TRUE
               WHEN CURR-BSC-PERIOD
                   MOVE BENEFIT-PRD-F030
                     TO FWR-CB-BENEFIT-PERIOD
                        PWR-CB-BENEFIT-PERIOD
               WHEN PR-1-BSC-PERIOD
                   MOVE BENEFIT-PRD-F030
      *%%% EL TT# 1913 BEGIN
                     TO FWR-P1B-BENEFIT-PERIOD
                        PWR-P1B-BENEFIT-PERIOD
      *%%% EL TT# 1913 END
               WHEN PR-2-BSC-PERIOD
                   MOVE BENEFIT-PRD-F030
      *%%% EL TT# 13576 BEGIN
                     TO FWR-P2B-BENEFIT-PERIOD
                        PWR-P2B-BENEFIT-PERIOD
      *%%% EL TT# 13576 END
               WHEN CURR-STD-PERIOD
                   MOVE BENEFIT-PRD-F030
                     TO FWR-CS-BENEFIT-PERIOD
                        PWR-CS-BENEFIT-PERIOD
               WHEN PR-1-STD-PERIOD
                   MOVE BENEFIT-PRD-F030
                     TO FWR-P1S-BENEFIT-PERIOD
                        PWR-P1S-BENEFIT-PERIOD
               WHEN PR-2-STD-PERIOD
                   MOVE BENEFIT-PRD-F030
                     TO FWR-P2S-BENEFIT-PERIOD
                        PWR-P2S-BENEFIT-PERIOD
      *%%% KX TT 84175 BEGIN
      *        WHEN CURR-BCO-PERIOD
      *            MOVE BENEFIT-PRD-F030
      *              TO FWR-CBCO-BENEFIT-PERIOD
      *                 PWR-CBCO-BENEFIT-PERIOD
      *        WHEN PR-1-BCO-PERIOD
      *            MOVE BENEFIT-PRD-F030
      *              TO FWR-P1BCO-BENEFIT-PERIOD
      *                 PWR-P1BCO-BENEFIT-PERIOD
      *        WHEN PR-2-BCO-PERIOD
      *            MOVE BENEFIT-PRD-F030
      *              TO FWR-P2BCO-BENEFIT-PERIOD
      *                 PWR-P2BCO-BENEFIT-PERIOD
      *%%% KX TT 84175 END
      *%%% PE TT 1171411 BEGIN
               WHEN CURR-BFCS-PERIOD
                   MOVE BENEFIT-PRD-F030
                     TO FWR-CP-BENEFIT-PERIOD
                        PWR-CP-BENEFIT-PERIOD
               WHEN PR-1-BFCS-PERIOD
                   MOVE BENEFIT-PRD-F030
                     TO FWR-P1P-BENEFIT-PERIOD
                        PWR-P1P-BENEFIT-PERIOD
               WHEN PR-2-BFCS-PERIOD
                   MOVE BENEFIT-PRD-F030
                     TO FWR-P2P-BENEFIT-PERIOD
                        PWR-P2P-BENEFIT-PERIOD
      *%%% PE TT# 1171411 END
           END-EVALUATE

      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   TEST IF OPTION CHANGE APPLICABLE OR A BENEFIT SEGMENT EXISTS
      *   OR IF ANY PATIENTS UNDER THE OTHER OPTION HAVE MET ANY
      *   DEDUCTIBLE, IF SO UPDATE OTHER OPTION.
      *-----------------------------------------------------------------
      *   EFFECTIVE 1/1/92 - CHECK FAMILY DEDUCTIBLE AMOUNT
      *   EFFECTIVE 1/1/93 - CHECK DRUG DEDUCTIBLE AMOUNT
      *   EFFECTIVE 1/1/94 - CHECK DRUG DEDUCT FOR CURR AND PRIOR-1
      *     ALSO THREE BENEFIT PERIODS WILL NEED TO CHECK FAMILY DEDUCT,
      *     WILL NOT NEED TO CHECK THE NUMBER-PATS MET ANY MORE.
      *   EFFECTIVE 1/1/95 - CHECK DRUG DEDUCT FOR ALL 3 BENEFIT PERIODS
      *-----------------------------------------------------------------
      *
           IF  OPTION-CHANGE-DURING-YEAR-TWR
           OR  OTH-BENEFIT-PERIOD-F030    >  ZERO
           OR  OTH-FAM-DEDUCT-ACCUM-F030  >  ZERO
               EVALUATE TRUE
                 WHEN OTH-CURR-BSC-PERIOD
                   MOVE OTH-BENEFIT-PRD-F030
                     TO FWR-CB-BENEFIT-PERIOD
                        PWR-CB-BENEFIT-PERIOD
                 WHEN OTH-PR-1-BSC-PERIOD
                   MOVE OTH-BENEFIT-PRD-F030
      *%%% EL TT# 1913 BEGIN
                     TO FWR-P1B-BENEFIT-PERIOD
                        PWR-P1B-BENEFIT-PERIOD
      *%%% EL TT# 1913 END
                 WHEN OTH-PR-2-BSC-PERIOD
                   MOVE OTH-BENEFIT-PRD-F030
      *%%% EL TT# 13576 BEGIN
                     TO FWR-P2B-BENEFIT-PERIOD
                        PWR-P2B-BENEFIT-PERIOD
      *%%% EL TT# 13576 END
                 WHEN OTH-CURR-STD-PERIOD
                   MOVE OTH-BENEFIT-PRD-F030
                     TO FWR-CS-BENEFIT-PERIOD
                        PWR-CS-BENEFIT-PERIOD
                 WHEN OTH-PR-1-STD-PERIOD
                   MOVE OTH-BENEFIT-PRD-F030
                     TO FWR-P1S-BENEFIT-PERIOD
                        PWR-P1S-BENEFIT-PERIOD
                 WHEN OTH-PR-2-STD-PERIOD
                   MOVE OTH-BENEFIT-PRD-F030
                     TO FWR-P2S-BENEFIT-PERIOD
                        PWR-P2S-BENEFIT-PERIOD
               END-EVALUATE
           END-IF
           .
       5880-EXIT.
           EXIT.

       8000-CHECK-FOR-COB-REJ.
      *-----------------------------------------------------------------
      *  CHECK FOR COB REJECTION ON THE CHARGE LINES.  IF FOUND, SET
      *  SWITCH TO BE USED FOR EDIT REASON 'FNU'.
      *  WE CHECK FOR AMOUNT PAID OTEHR CARRIER INDICATOR TO SET THE
      *  COB CHARGE LINE TO TRUE. WE ALLOW TWO OTHER CARRIERS AT THIS
      *  POINT
      *-----------------------------------------------------------------

           EVALUATE  TRUE
             WHEN ANY-REJ-AFFECTED-CHRG-TWR        (TWR-CRG-SUB)
               EVALUATE  TRUE
                 WHEN APOC1-TRAD-MEDICARE-PART-A-TWR (TWR-CRG-SUB)
                 WHEN APOC1-TRAD-MEDICARE-PART-B-TWR (TWR-CRG-SUB)
                 WHEN APOC1-MEDICARE-MANAGE-CARE-TWR (TWR-CRG-SUB)
                 WHEN APOC1-OTHR-BCBS-TWR (TWR-CRG-SUB)
                 WHEN APOC1-OTHR-COMMERCIAL-CARR-TWR (TWR-CRG-SUB)
                 WHEN APOC1-NO-FAULT-TWR (TWR-CRG-SUB)
                 WHEN APOC2-TRAD-MEDICARE-PART-A-TWR (TWR-CRG-SUB)
                 WHEN APOC2-TRAD-MEDICARE-PART-B-TWR (TWR-CRG-SUB)
                 WHEN APOC2-MEDICARE-MANAGE-CARE-TWR (TWR-CRG-SUB)
                 WHEN APOC2-OTHR-BCBS-TWR (TWR-CRG-SUB)
                 WHEN APOC2-OTHR-COMMERCIAL-CARR-TWR (TWR-CRG-SUB)
                 WHEN APOC2-NO-FAULT-TWR (TWR-CRG-SUB)
                   SET  COB-CHG-LINE-REJECT                TO TRUE
               END-EVALUATE
           END-EVALUATE.

           PERFORM 8100-CHECK-FOR-DEFER-FNU
              THRU 8100-EXIT.

       8000-EXIT.
           EXIT.


       8100-CHECK-FOR-DEFER-FNU.
      *-----------------------------------------------------------------
      *   IF A COB OC CALC PRORATED CLAIM CONTAINS AT LEAST ONE
      *   INTERNAL REJECTED CHARGE LINE - ALL OTHER COB APPROVED LINES
      *   SHOULD BE DEFERRED FOR 'FNU'.
      *     (OC-CALC ARE THE ONLY TYPE TRANS THAT WILL HAVE THE
      *        CLAIM-PRORATION-SW TURNED ON)
      *-----------------------------------------------------------------

           EVALUATE  TRUE  ALSO TRUE
             WHEN CLAIM-PRORATION-SW-TWR       =  'Y'
             ALSO COB-CHG-LINE-REJECT
               PERFORM 8110-CHECK-FOR-DEFER-FNU-CHRG
                  THRU 8110-EXIT
                  VARYING TWR-CRG-SUB  FROM 1 BY 1
                    UNTIL TWR-CRG-SUB  >  NUMBER-OF-CHARGES-TWR
           END-EVALUATE.

       8100-EXIT.
           EXIT.


       8110-CHECK-FOR-DEFER-FNU-CHRG.
      *-----------------------------------------------------------------
      *  IN ORDER FOR THIS LOOP TO BE PROCESSED, FOUR THINGS MUST BE
      *  TRUE:    (#1 COB, #2 OC-CALC, #3 PRORATED, #4 CLAIM MUST
      *              CONTAIN AT LEAST 1 INTERNAL REJECTED COB CHARGE)
      *  DID NOT MOVE THE TWR TO THE HCL, BECAUSE DEFERRALS ARE BUILT
      *  FROM THE TWR.
      *  ZAPPED THE DED AMT/CODE, COIN AMT/CODE, SAVINGS AMOUNTS AND
      *  THE AMT PAID ON THE APPROVED LINES, BECAUSE NOW THAT THE
      *  CHARGE LINES WILL DEFER FOR 'FNU', WE DO NOT WANT TO SEND THESE
      *  VALUES BACK TO THE PLAN.
      *-----------------------------------------------------------------

           EVALUATE  TRUE
             WHEN ANY-APP-AFFECTED-CHRG-TWR    (TWR-CRG-SUB)
             WHEN PENDING-APPROVAL-TWR         (TWR-CRG-SUB)
               EVALUATE  TRUE
                 WHEN TS1-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
                 WHEN TS1-NEG-COB-APPLICABLE-TWR   (TWR-CRG-SUB)
                 WHEN TS2-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
                 WHEN TS2-NEG-COB-APPLICABLE-TWR   (TWR-CRG-SUB)
                 WHEN TS3-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
                 WHEN TS3-NEG-COB-APPLICABLE-TWR   (TWR-CRG-SUB)
                 WHEN TS4-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
                 WHEN TS4-NEG-COB-APPLICABLE-TWR   (TWR-CRG-SUB)
                   MOVE 'FNU'          TO ERROR-REASON
                   MOVE DEFER          TO ERROR-REASON-ACTION
                   PERFORM 8111-DEFER-CHARGES
                      THRU 8111-EXIT
                   PERFORM 8112-INIT-PAYMENT-FIELDS
                      THRU 8112-EXIT
                   PERFORM 8113-INIT-AND-RESET-SAVINGS
                      THRU 8113-EXIT
               END-EVALUATE
           END-EVALUATE.

       8110-EXIT.
           EXIT.


       8111-DEFER-CHARGES.

           MOVE '50'           TO CLAIM-STATUS-TWR
                                  CHARGE-STATUS-TWR    (TWR-CRG-SUB).

           ADD +01             TO TOTAL-DEF-CHARGES.

           EVALUATE  TRUE
             WHEN CHRG-RESPONSE-REASON-1-TWR   (TWR-CRG-SUB) =  SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-1-TWR (TWR-CRG-SUB)
             WHEN CHRG-RESPONSE-REASON-2-TWR   (TWR-CRG-SUB) =  SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-2-TWR (TWR-CRG-SUB)
             WHEN CHRG-RESPONSE-REASON-3-TWR   (TWR-CRG-SUB) =  SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-3-TWR (TWR-CRG-SUB)
             WHEN CHRG-RESPONSE-REASON-4-TWR   (TWR-CRG-SUB) =  SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-4-TWR (TWR-CRG-SUB)
             WHEN CHRG-RESPONSE-REASON-5-TWR   (TWR-CRG-SUB) =  SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-5-TWR (TWR-CRG-SUB)
             WHEN OTHER
               MOVE 'M'
                 TO CHRG-OVERFLOW-REASON-SW-TWR    (TWR-CRG-SUB)
           END-EVALUATE.

       8111-EXIT.
           EXIT.


       8112-INIT-PAYMENT-FIELDS.

           MOVE SPACE      TO DEDUCTIBLE-CODE-TWR        (TWR-CRG-SUB)
                              COINSURANCE-CODE-TWR       (TWR-CRG-SUB).

           MOVE ZEROES     TO DEDUCTIBLE-AMOUNT-TWR      (TWR-CRG-SUB)
                              DEDUCTIBLE-AMOUNT-CP-TWR   (TWR-CRG-SUB)
                              COINSURANCE-AMOUNT-TWR     (TWR-CRG-SUB)
                              COINSURANCE-AMOUNT-CP-TWR  (TWR-CRG-SUB)
                              AMOUNT-PAID-TWR            (TWR-CRG-SUB)
                              AMOUNT-PAID-CP-TWR         (TWR-CRG-SUB).

       8112-EXIT.
           EXIT.


       8113-INIT-AND-RESET-SAVINGS.

           EVALUATE  TRUE
             WHEN TS1-NEG-NO-FAULT-TWR         (TWR-CRG-SUB)
               SET  TS1-NO-FAULT-TWR           (TWR-CRG-SUB)   TO TRUE
             WHEN TS2-NEG-NO-FAULT-TWR         (TWR-CRG-SUB)
               SET  TS2-NO-FAULT-TWR           (TWR-CRG-SUB)   TO TRUE
             WHEN TS3-NEG-NO-FAULT-TWR         (TWR-CRG-SUB)
               SET  TS3-NO-FAULT-TWR           (TWR-CRG-SUB)   TO TRUE
             WHEN TS4-NEG-NO-FAULT-TWR         (TWR-CRG-SUB)
               SET  TS4-NO-FAULT-TWR           (TWR-CRG-SUB)   TO TRUE
           END-EVALUATE.

           EVALUATE  TRUE
             WHEN TS1-NEG-OTH-CARR-LIAB-TWR    (TWR-CRG-SUB)
               SET  TS1-OTH-CAR-LIABLE-TWR     (TWR-CRG-SUB)   TO TRUE
             WHEN TS2-NEG-OTH-CARR-LIAB-TWR    (TWR-CRG-SUB)
               SET  TS2-OTH-CAR-LIABLE-TWR     (TWR-CRG-SUB)   TO TRUE
             WHEN TS3-NEG-OTH-CARR-LIAB-TWR    (TWR-CRG-SUB)
               SET  TS3-OTH-CAR-LIABLE-TWR     (TWR-CRG-SUB)   TO TRUE
             WHEN TS4-NEG-OTH-CARR-LIAB-TWR    (TWR-CRG-SUB)
               SET  TS4-OTH-CAR-LIABLE-TWR     (TWR-CRG-SUB)   TO TRUE
           END-EVALUATE.

           EVALUATE  TRUE
             WHEN TS1-NEG-DUAL-MEMBER-TWR      (TWR-CRG-SUB)
               SET  TS1-DUAL-MEMBER-TWR        (TWR-CRG-SUB)   TO TRUE
             WHEN TS2-NEG-DUAL-MEMBER-TWR      (TWR-CRG-SUB)
               SET  TS2-DUAL-MEMBER-TWR        (TWR-CRG-SUB)   TO TRUE
             WHEN TS3-NEG-DUAL-MEMBER-TWR      (TWR-CRG-SUB)
               SET  TS3-DUAL-MEMBER-TWR        (TWR-CRG-SUB)   TO TRUE
             WHEN TS4-NEG-DUAL-MEMBER-TWR      (TWR-CRG-SUB)
               SET  TS4-DUAL-MEMBER-TWR        (TWR-CRG-SUB)   TO TRUE
           END-EVALUATE.

           EVALUATE  TRUE
             WHEN TS1-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
               MOVE ZEROS TO SAVINGS-AMOUNT-1-CP-TWR   (TWR-CRG-SUB)
               MOVE SPACES TO SAVINGS-AMOUNT-1-TWR     (TWR-CRG-SUB)
             WHEN TS2-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
               MOVE ZEROS  TO SAVINGS-AMOUNT-2-CP-TWR  (TWR-CRG-SUB)
               MOVE SPACES TO SAVINGS-AMOUNT-2-TWR     (TWR-CRG-SUB)
             WHEN TS3-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
               MOVE ZEROS  TO SAVINGS-AMOUNT-3-CP-TWR  (TWR-CRG-SUB)
               MOVE SPACES TO SAVINGS-AMOUNT-3-TWR     (TWR-CRG-SUB)
             WHEN TS4-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
               MOVE ZEROS  TO SAVINGS-AMOUNT-4-CP-TWR  (TWR-CRG-SUB)
               MOVE SPACES TO SAVINGS-AMOUNT-4-TWR     (TWR-CRG-SUB)
           END-EVALUATE.

           EVALUATE  TRUE
             WHEN TS1-SUBROGATION-TWR          (TWR-CRG-SUB)
               MOVE ZEROS TO SAVINGS-AMOUNT-1-CP-TWR   (TWR-CRG-SUB)
               MOVE SPACES TO SAVINGS-AMOUNT-1-TWR     (TWR-CRG-SUB)
             WHEN TS2-SUBROGATION-TWR          (TWR-CRG-SUB)
               MOVE ZEROS  TO SAVINGS-AMOUNT-2-CP-TWR  (TWR-CRG-SUB)
               MOVE SPACES TO SAVINGS-AMOUNT-2-TWR     (TWR-CRG-SUB)
             WHEN TS3-SUBROGATION-TWR          (TWR-CRG-SUB)
               MOVE ZEROS  TO SAVINGS-AMOUNT-3-CP-TWR  (TWR-CRG-SUB)
               MOVE SPACES TO SAVINGS-AMOUNT-3-TWR     (TWR-CRG-SUB)
             WHEN TS4-SUBROGATION-TWR          (TWR-CRG-SUB)
               MOVE ZEROS  TO SAVINGS-AMOUNT-4-CP-TWR  (TWR-CRG-SUB)
               MOVE SPACES TO SAVINGS-AMOUNT-4-TWR     (TWR-CRG-SUB)
           END-EVALUATE.

       8113-EXIT.
           EXIT.

       9200-REGULAR-N1.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            PRODUCE THE N1 SUPPORTING HISTORY RECORD
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           PERFORM 9210-SET-UP-N1-COMMON-DATA THRU 9210-EXIT

           PERFORM 9220-N1-DAYS-VISITS THRU 9220-EXIT
      *
      *-----------------------------------------------------------------
      *  THIS PERFORM WILL:
      *  1)  MOVE THE COINSURANCE AMOUNT IN OUR WORK FIELD TO THE HCL
      *  2)  DETERMINE IF COPAY WAS USED, AND IF SO CONVERTS THE CODES
      *  IT SEEMS THIS COULD ALSO BE MOVED TO THE CALCULATING MODULES.
      *-----------------------------------------------------------------
      *
           IF  COINS-IND  =  SPACE
               IF  VOID-D4-TWR
                   MOVE COINSURANCE-CODE-TWR (TWR-CRG-SUB)
                     TO COINSURANCE-CODE-N1
               END-IF
           ELSE
               PERFORM 9230-MOVE-COINS-INDICATORS-N1
                  THRU 9230-EXIT
           END-IF

           PERFORM 9240-MOVE-CAT-N1 THRU 9240-EXIT

           PERFORM 9250-MOVE-DEDUCT-N1 THRU 9250-EXIT

           PERFORM 9260-MOVE-LIFE-ACCUM-N1 THRU 9260-EXIT

      *%%% EL TT# 22179 - BEGIN
           IF  PRODUCE-N4-LINES                                         FH02P0M3
               IF  DISP1-1STEP-OC-CALC-TWR
               OR  DISP2-1STEP-OC-CALC-TWR
      *%%% KX TT 49146 - BEGIN
      *        OR  DISP6-1STEP-OC-CALC-TWR                              FH02P0M3
      *%%% KX TT 49146 - END
      *%%% EL TT# 22179 - END
                   GO TO 9200-EXIT
               ELSE
                   PERFORM 9270-OVERLAY-CODES
                      THRU 9270-EXIT
               END-IF
           END-IF

           PERFORM 9280-CALL-FX85-WRITE-HIST THRU 9280-EXIT
           .
       9200-EXIT.
           EXIT.

       9210-SET-UP-N1-COMMON-DATA.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            FORMAT THE COMMON DATA FOR THE N1 LINE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *
      *------------------------------------------------------------
      *  FORMAT AND PRINT N1 LINES FOR APPROVED CHARGE LINES
      *  INITIALIZATION MUST BE DONE HERE INSTEAD OF IN THE CHARGE BY
      *  CHARGE PROCESS BECAUSE THE L1, N1 AND N4 ALL REDEFINE EACH
      *  OTHER AND THE INTIALIZATION CAN ONLY TAKE PLACE ONCE WE HAVE
      *  DECIDED WHICH FORMAT WE ARE GOING TO USE.
      *------------------------------------------------------------
      *
           MOVE SH-INITIAL-CALC-N1-LINE TO SH-CALCULATION-N1-RECORD
           ADD 01 TO HOLD-PROCESS-SEQ
           MOVE HOLD-PROCESS-SEQ TO SEQUENCE-NUMBER-N1
           MOVE CHARGE-STATUS-TWR (TWR-CRG-SUB)
             TO SUPP-HIST-STATUS-SHWR
           MOVE 'N1' TO LINE-CODE-SHBR
           MOVE PROCESSING-CODE-TWR TO PROCESSING-CODE-N1
           MOVE LINE-NUMBER-AN-TWR (TWR-CRG-SUB) TO LINE-NUMBER-N1
           MOVE CONT-HLDR-MIDDLE-INIT-TWR
             TO CONT-HLDR-MIDDLE-INITIAL-N1
           MOVE CONT-HLDR-LAST-NAME-TWR TO CONT-HLDR-LAST-NAME-N1
           MOVE CONT-HLDR-FIRST-NAME-TWR TO CONT-HLDR-FIRST-NAME-N1
           MOVE ENROLLMENT-CODE-TWR TO BENEFIT-ENROLL-CODE-N1
           MOVE ENROLL-OPTION10D-CD-TWR
             TO ENROLL-OPTION10D-CD-N1
           MOVE CLM-BEGIN-YEAR4-TWR   TO BENEFIT-YEAR-N1
      *
           MOVE ALT-PROV-NETWORK-STATUS-TWR (TWR-CRG-SUB)
             TO ALT-PROV-NETWORK-STATUS-N1
      *%%% TT283828   HIPAA 5010 BEGIN
           MOVE HIPAA-VERSION-CODE-TWR
             TO HIPAA-VERSION-CODE-N1
      *%%% TT283828   HIPAA 5010 END
           .
       9210-EXIT.
           EXIT.

       9220-N1-DAYS-VISITS.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *         SET THE DAYS AND VISITS INFO FOR THE N1 LINE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           IF  DAYS-IND = SPACE
               CONTINUE
           ELSE
               MOVE DAYS-IND TO DAYS-IND-N1
               MOVE DAYS-ACCUM-AFT-CRG   TO HOLD-3-DIGIT-NUMERIC
               MOVE HOLD-3-DIGIT-NUMERIC TO DAYS-ACCUM-N1
           END-IF
      *
           IF VISITS-IND = SPACE
               CONTINUE
           ELSE
               MOVE VISITS-IND TO VISITS-IND-N1
               MOVE VISITS-ACCUM-AFT-CRG TO HOLD-3-DIGIT-NUMERIC
               MOVE HOLD-3-DIGIT-NUMERIC TO VISITS-ACCUM-N1
           END-IF

           IF CHIRO-VISITS-IND = SPACE
               CONTINUE
           ELSE
               MOVE CHIRO-VISITS-IND TO CHIRO-VISITS-IND-N1
               MOVE CHIRO-CARE-DAY-ACCUM-F030
                 TO CHIRO-VISITS-ACCUM-NUM-N1
           END-IF
      *%%% EL TT# 184100 - BEGIN
           IF VISITS-IND2 = SPACE
               CONTINUE
           ELSE
               MOVE VISITS-IND2 TO VISITS-IND-2-N1
               MOVE VISITS2-ACCUM-AFT-CRG TO HOLD-3-DIGIT-NUMERIC
               MOVE HOLD-3-DIGIT-NUMERIC TO VISITS-ACCUM-2-N1
           END-IF
      *%%% EL TT# 184100 - END
           .
       9220-EXIT.
           EXIT.

       9230-MOVE-COINS-INDICATORS-N1.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *          MOVE THE COINSURANCE IND'S FOR THE N1 LINE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *
      *----------------------------------------------------------
      *  NOTE ON NON-TIMELY FILING, PLAN CALC/PLAN APP, TYPE 1/2:
      *  DUE TO
      *  THE POSSIBILITY OF DISCOUNTS, WIPE OUT % ON N1 PLAN CALC
      *  CLAIMS.  THE EXCEPTIONS ARE:
      *      A. NON-MEMBER HOSPITAL CLAIMS (CLASS PROV 3,4,E).
      *      B. CLAIMS WITH MI DIAGNOSIS CODES
      *         ( 290-319, V40, V61, V62, V673 V710 ).
      *-----------------------------------------------------------------
      *
      *    CMR 377054
           MOVE FAC-PRIN-DIAG-CODE-TWR TO HOLD-DIAGNOSIS-CODE-FAC
                                          HOLD-DIAGNOSIS-CODE-TEMPX
           PERFORM 9255-CALL-FV01P3M0 THRU 9255-CALL-FV01P3M0-EXIT
           MOVE DX-DIAG-TEMPX TO DX-DIAG-FAC
           IF  (INPAT-INSTITUTE-TYPE-CLAIM-HCL
                OR OTPAT-INSTITUTE-TYPE-CLAIM-HCL)
           AND (PLAN-CALC-OC-VER-TWR
                OR PLAN-APPR-NO-OC-VER-TWR)
               IF  NON-PAR-PROVIDER-TWR (TWR-CRG-SUB)
               OR  MI-DIAG-CODE-FAC
               OR  MI-4-DIAG-CODE-FAC
               OR  MI-DIAG-CODE-5-FAC
                   CONTINUE
               ELSE
                    MOVE ZERO TO COINS-PERCENT
               END-IF
           END-IF
      *
           IF  BA-COPAY-AMT > 0
             IF COINS-NOT-APPLICABLE
             OR BA-COINS-MEDICARE-WAIVED
      *%%% EL TT# 1171411 - BEGIN
             OR BA-COPAY-PER-ACCRUED-PERIOD
      *%%% EL TT# 1171411 - END
                CONTINUE
             ELSE
               MOVE  BA-COPAY-AMT
                 TO  COPAY-AMOUNT-NUM-N1
             END-IF
           END-IF

           IF  BA-COINS-PCT > 0
               MOVE COINS-PERCENT
                 TO HOLD-2-DIGIT-V99
               MOVE HOLD-2-DIGIT-NUMERIC
                 TO COINSURANCE-PERCENT-N1
           END-IF
      *
           MOVE COINS-IND TO COINSURANCE-CODE-N1
           .
       9230-EXIT.
           EXIT.

       9240-MOVE-CAT-N1.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *         FORMAT THE CATASTROPHIC INFO FOR THE N1 LINE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *
      *-----------------------------------------------------------------
      *  WE COULD USE THE SWITCHES INSTEAD OF THE WORKING FIELD.
      *-----------------------------------------------------------------
      *PLAN CALC AND PLAN APPROVED CLAIMS LEAVE THE CAT-ACCUM-AFT-CRG
      *FIELD BLANK WHEN ALL CHARGES GO TOWARDS THE DEDUCTIBLE.
      *PPR 124678
      *REQUESTS THAT, IF THE CHARGE WOULD HAVE, IF PAID, UPDATED THE
      *CATASTROPHIC MAX ( MI OR REG ), THEN WE SHOULD PLACE ANY ACCUMING
      *AMOUNT FROM THE CONTRACT CONTROL FILE (F00030) INTO THE
      *CAT-ACCUM-AFT-CRG FIELD.  THIS MONEY WILL THEN APPEAR ON THE
      *N1 LINE.
      *REQUESTS THAT WE SHOULD PLACE ANY ACCUMULATING ANNUAL DEDUCTIBLE
      * AND CATASTROPHIC MAX'S (REG, MI, PPO) ON THE N1 LINE REQARDLESS
      * OF WHETHER OR NOT THEY ARE APPLICABLE FOR A PARTICULAR CHARGE.
      *-----------------------------------------------------------------
      *
           MOVE FAC-PRIN-DIAG-CODE-TWR TO HOLD-DIAGNOSIS-CODE-FAC
                                          HOLD-DIAGNOSIS-CODE-TEMPX
           PERFORM 9255-CALL-FV01P3M0 THRU 9255-CALL-FV01P3M0-EXIT
           MOVE DX-DIAG-TEMPX TO DX-DIAG-FAC
           MOVE DIAGNOSIS-CODE-1-TWR (TWR-CRG-SUB)
             TO HOLD-DIAGNOSIS-CODE-PRO
                HOLD-DIAGNOSIS-CODE-TEMPX
           PERFORM 9255-CALL-FV01P3M0 THRU 9255-CALL-FV01P3M0-EXIT
           MOVE DX-DIAG-TEMPX TO DX-DIAG-PRO
           IF  CAT-ACCUM-AFT-CRG  >  ZERO
               MOVE CAT-ACCUM-AFT-CRG
                 TO HOLD-7-DIGIT-NUMERIC
               MOVE HOLD-7-DIGIT-NUMERIC
                 TO STOP-LOSS-ACCUM-NUM-N1
           ELSE
               IF  FAMILY-CAT-ACCUM-F030 > 0
                   MOVE FAMILY-CAT-ACCUM-F030
                     TO CAT-ACCUM-AFT-CRG
                   MOVE CAT-ACCUM-AFT-CRG
                     TO HOLD-7-DIGIT-NUMERIC
                   MOVE HOLD-7-DIGIT-NUMERIC
                     TO STOP-LOSS-ACCUM-NUM-N1
               ELSE
                       IF  BA-COPAY-AMT > ZERO
                           EVALUATE TRUE ALSO TRUE
      *  CMR 377054
                             WHEN (INPAT-INSTITUTE-TYPE-CLAIM-HCL
                                   OR OTPAT-INSTITUTE-TYPE-CLAIM-HCL)
                             ALSO (MI-DIAG-CODE-FAC
                                   OR MI-4-DIAG-CODE-FAC
                                   OR MI-DIAG-CODE-5-FAC)
                             WHEN TOB-PROFESSIONAL-CLAIM-TWR
                             ALSO (MI-DIAG-CODE-PRO
                                  OR MI-4-DIAG-CODE-PRO
                                  OR MI-DIAG-CODE-5-PRO)
                                  MOVE COINSURANCE-AMOUNT
                                    TO HOLD-7-DIGIT-V99
                                  MOVE HOLD-7-DIGIT-V99
                                    TO STOP-LOSS-ACCUM-NUM-N1
                           END-EVALUATE
                   END-IF
               END-IF
           END-IF

           IF  PPO-ACCUM-AFT-CRG  >  ZERO
               MOVE PPO-ACCUM-AFT-CRG
                 TO HOLD-7-DIGIT-NUMERIC
               MOVE HOLD-7-DIGIT-NUMERIC
                 TO PPO-STOP-LOSS-ACCUM-NUM-N1
           ELSE
               IF  FAMILY-PPO-ACCUM-F030 > 0
                   MOVE FAMILY-PPO-ACCUM-F030
                     TO PPO-ACCUM-AFT-CRG
                   MOVE PPO-ACCUM-AFT-CRG
                     TO HOLD-7-DIGIT-NUMERIC
                   MOVE HOLD-7-DIGIT-NUMERIC
                     TO PPO-STOP-LOSS-ACCUM-NUM-N1
               END-IF
           END-IF
      *%%% EL TT# 802259/802262 - BEGIN
           IF  MBR-CAT-ACCUM-AFT-CRG  >  ZERO
               MOVE MBR-CAT-ACCUM-AFT-CRG
                 TO HOLD-7-DIGIT-NUMERIC
               MOVE HOLD-7-DIGIT-NUMERIC
                 TO MBR-STOP-LOSS-ACCUM-NUM-N1
           ELSE
               IF  MEMBER-CAT-ACCUM-F030 > 0
                   MOVE MEMBER-CAT-ACCUM-F030
                     TO MBR-CAT-ACCUM-AFT-CRG
                   MOVE MBR-CAT-ACCUM-AFT-CRG
                     TO HOLD-7-DIGIT-NUMERIC
                   MOVE HOLD-7-DIGIT-NUMERIC
                     TO MBR-STOP-LOSS-ACCUM-NUM-N1
               END-IF
           END-IF

           IF  MBR-PPO-ACCUM-AFT-CRG  >  ZERO
               MOVE MBR-PPO-ACCUM-AFT-CRG
                 TO HOLD-7-DIGIT-NUMERIC
               MOVE HOLD-7-DIGIT-NUMERIC
                 TO MBR-PPO-STOP-LOSS-ACCUM-NUM-N1
           ELSE
               IF  MEMBER-PPO-CAT-ACCUM-F030 > 0
                   MOVE MEMBER-PPO-CAT-ACCUM-F030
                     TO PPO-ACCUM-AFT-CRG
                   MOVE PPO-ACCUM-AFT-CRG
                     TO HOLD-7-DIGIT-NUMERIC
                   MOVE HOLD-7-DIGIT-NUMERIC
                     TO MBR-PPO-STOP-LOSS-ACCUM-NUM-N1
               END-IF
           END-IF
      *%%% EL TT# 802259/802262 - END
           .
       9240-EXIT.
           EXIT.

       9250-MOVE-DEDUCT-N1.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *          FORMAT THE DEDUCTIBLE INFO FOR THE N1 LINE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *
      *FOR PCS IF DEDUCT CODE IS P THAT MEANS THAT THIS IS A TIMELY
      * FILING CHARGE AND THE DEDUCT IS BEING WAIVED.
      *
           IF  DEDUCT-IND  =  SPACE
               IF  VOID-D4-TWR
                   MOVE DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
                     TO DEDUCTIBLE-CODE-N1
               END-IF
           ELSE
      *%%% TT 344326  KJ BEGIN
               IF  (RETAIL-DRUG-PROGRAM-TWR
                      OR SPECIALTY-DRUG-TWR)
      *%%% TT 344326  KJ END
               AND DEDUCT-IND =  'P'
                   CONTINUE
               ELSE
                   MOVE DEDUCT-IND TO DEDUCTIBLE-CODE-N1
      *                               DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
                   MOVE DEDUCT-ACCUM-AFT-CRG
      *%%% KX TT 84175 BEGIN
                     TO HOLD-6-DIGIT-V99
      *%%% KX TT 84175 END
                   IF REPORTING-PLAN-CODE-TWR = ('082' OR '405'         )
      *%%% PE TT 78472
                                           OR '905')                    )
                   AND BA-DCTB-PRESCRIPTION-DRUG
                   AND BA-DCTB-CURR-OPT-MBR-AMT > ZERO
      *%%% KX TT 84175 BEGIN
                       MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
                         TO DRUG-DEDUCTIBLE-ACCUM-N1
                   ELSE
      *%%% EK TT# 6431 BEGIN
      *%%% KX TT 84175 BEGIN
                       MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
                         TO DEDUCTIBLE-ACCUM-N1
      *%%% EK TT# 6431 END
                   END-IF
                   MOVE FAM-DEDUCT-IND
                     TO FAMILY-DEDUCT-INDICATOR-N1
                   MOVE FAM-DEDUCT-ACCUM-AFT-CRG
      *%%% KX TT 84175 BEGIN
                     TO HOLD-6-DIGIT-V99
      *%%% KX TT 84175 END
                   IF REPORTING-PLAN-CODE-TWR = ('082' OR '405'         )
      *%%% PE TT 78472
                                        OR '905')                       )
                   AND BA-DCTB-PRESCRIPTION-DRUG
                   AND BA-DCTB-CURR-OPT-MBR-AMT > ZERO
      *%%% KX TT 84175 BEGIN
                       MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
                         TO FAM-DRUG-DEDUCT-APPLIED-N1
                   ELSE
      *%%% KX TT 84175 BEGIN
                       MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
                         TO FAMILY-DEDUCT-APPLIED-N1
                   END-IF
               END-IF
           END-IF
      *
      *-----------------------------------------------------------------
      * MOVE OUT THE DEDUCTIBLE AMOUNT FROM THE F030 FIELDS IF ITS NOT
      * APPLICABLE.
      *-----------------------------------------------------------------
      *
           IF  DEDUCT-ACCUM-AFT-CRG  =  ZERO
               MOVE  F030-TOTAL-DEDUCT-ACCUM
      *%%% KX TT 84175 BEGIN
                 TO  HOLD-6-DIGIT-V99
      *%%% KX TT 84175 END
      *%%% PE TT 78472
               IF REPORTING-PLAN-CODE-TWR  = ('082' OR '405' OR '905')
               AND  BA-DCTB-PRESCRIPTION-DRUG
               AND  BA-DCTB-CURR-OPT-MBR-AMT  >  ZERO
      *%%% KX TT 84175 BEGIN
                   MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
                     TO DRUG-DEDUCTIBLE-ACCUM-N1
               ELSE
      *%%% KX TT 84175 BEGIN
                   MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
                     TO DEDUCTIBLE-ACCUM-N1
               END-IF
               MOVE F030-TOTAL-FAM-DED-ACCUM
      *%%% KX TT 84175 BEGIN
                 TO HOLD-6-DIGIT-V99
      *%%% KX TT 84175 END
      *%%% PE TT 78472
               IF REPORTING-PLAN-CODE-TWR  = ('082' OR '405' OR '905')
               AND  BA-DCTB-PRESCRIPTION-DRUG
               AND  BA-DCTB-CURR-OPT-MBR-AMT  >  ZERO
      *%%% KX TT 84175 BEGIN
                   MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
                     TO FAM-DRUG-DEDUCT-APPLIED-N1
               ELSE
      *%%% KX TT 84175 BEGIN
                   MOVE HOLD-6-DIGIT-NUMERIC
      *%%% KX TT 84175 END
                     TO FAMILY-DEDUCT-APPLIED-N1
               END-IF
           END-IF
      *%%% KX TT 84175 BEGIN
           IF BASIC-OPT-CO-CONTRACT-TWR
              EVALUATE TRUE
                  WHEN SINGLE-BASIC-OPTION-TWR
                       MOVE SPACES TO FAMILY-DEDUCT-INDICATOR-N1
                                      FAMILY-DEDUCT-APPLIED-N1
                  WHEN FAMILY-BASIC-OPTION-TWR
                       MOVE SPACES TO DEDUCTIBLE-CODE-N1
                                      DEDUCTIBLE-ACCUM-N1
              END-EVALUATE
           END-IF
           MOVE BA-DCTB-CURR-OPT-MBR-AMT
             TO HOLD-9-DIGIT-V99
           MOVE DEDUCTIBLE-ACCUM-N1
             TO HOLD-6-DIGIT-AN
           IF HOLD-6-DIGIT-V99 > HOLD-9-DIGIT-V99
              MOVE HOLD-9-DIGIT-AN (4:6)
                TO DEDUCTIBLE-ACCUM-N1
           END-IF
           MOVE BA-DCTB-CURR-OPT-FAM-AMT
             TO HOLD-9-DIGIT-V99
           MOVE FAMILY-DEDUCT-APPLIED-N1
             TO HOLD-6-DIGIT-AN
           IF HOLD-6-DIGIT-V99 > HOLD-9-DIGIT-V99
              MOVE HOLD-9-DIGIT-AN (4:6)
                TO FAMILY-DEDUCT-APPLIED-N1
           END-IF
      *%%% KX TT 84175 END
           .
       9250-EXIT.
           EXIT.

       9255-CALL-FV01P3M0.                                              FH02P3MG
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-FH02P3MG
      *          ****  GET 88 LEVEL FOR GIVEN DX CODE  ****             FH02P3MG
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-FH02P3MG
           MOVE 'FH02'                                                  FH02P3MG
             TO CALLING-MESSAGE-ID-TEMPX
           MOVE CONTRACT-ID-NUMBER-TWR
             TO CONTRACT-ID-NUMBER-TEMPX
           MOVE REPORTING-PLAN-CODE-TWR
             TO REPORTING-PLAN-CODE-TEMPX
           MOVE CLAIM-NUMBER-TWR
             TO CLAIM-NUMBER-TEMPX
           MOVE LINE-NUMBER-HCL
             TO LINE-NUMBER-TEMPX
      *%%% V5 R4 2013 CHANGE ESU START
      *%%%ICD-10 DUAL CODE KJ BEGIN
      *    MOVE SPACES TO SERVICE-BEGIN-DATE-TEMPX
           MOVE SERVICE-BEGIN-DATE-HCL
                 TO SERVICE-BEGIN-DATE-TEMPX
      *%%% V5 R4 2013 CHANGE ESU END
           MOVE ICD-VERSION-IND-TWR TO ICD-VERSION-IND-ESU-TEMPX
      *%%% ICD-10 DUAL CODE KJ END
           SET  FV01P3M0-MODULE        TO    TRUE
           CALL WS-S-CALL2-MODULE  USING DFHEIBLK
                                      DFHCOMMAREA
                                      DX-ESU-PASS-PARAMS-TEMPX
      *%%% V5 R4 2013 CHANGE ESU END
                                      HOLD-DIAGNOSIS-CODE-TEMPX
                                      DX-DIAG-TEMPX
           END-CALL
           IF RETURN-CODE-TEMPX NOT = 0
              MOVE  4000                   TO WS-V-ERROR-PARA
              SET   CALL-PGM               TO TRUE
              SET   FEP-MAF-OTHER-SOFTWARE TO TRUE
              MOVE  SPACES                 TO WS-V-ERR-MESSAGE-TEXT
              MOVE 'FV01P3M0 DX CODE TBL READ FAILED'
                                           TO WS-V-ERR-MESSAGE-TEXT
              PERFORM 9880-ERROR-RTN THRU 9880-EXIT
           END-IF
           .                                                            FH02P3MG
       9255-CALL-FV01P3M0-EXIT.                                         FH02P3MG
           EXIT.                                                        FH02P3MG
                                                                        FH02P3MG
       9260-MOVE-LIFE-ACCUM-N1.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            FORMAT THE LIFETIME INFO FOR THE N1 LINE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *
      *-----------------------------------------------------------------
      * ADDED 1-1-86 CHECKS FOR SPECIAL LIFETIME 1 AND 2.  MAY BE EITHER
      * TRANSPLANT OR HOME HOSPICE MAXIMUM IN THE FIRST FIELD.  THE
      * SECOND FIELD SHOULD ONLY BE FILLED IN WHEN COB IS INVOLVED,
      * SINCE IT IS BELIEVED THAT WE CANNOT RECEIVE MORE THAN ONE OF
      * THESE SPECIAL MAXIMUMS PER CHARGE.  AT THIS TIME, NONE OF THESE
      * SHOULD HAVE THE UNLIMITED-MAX; HOWEVER, CODE WAS ADDED IN CASE
      * THESE ARE ADDED IN THE FUTURE.
      *-----------------------------------------------------------------
      *
           IF  LIFETIME-ACCUM-AFT-CRG > ZERO
               MOVE LIFETIME-ACCUM-AFT-CRG
                 TO HOLD-7-DIGIT-NUMERIC
               MOVE HOLD-7-DIGIT-NUMERIC
                 TO LIFETIME-MAX-ACCUM-N1
           END-IF
      *
           IF  MI-LIFETIME-ACCUM-AFT-CRG > ZERO
               MOVE MI-LIFETIME-ACCUM-AFT-CRG
                 TO HOLD-6-DIGIT-NUMERIC
               MOVE HOLD-6-DIGIT-NUMERIC
                 TO MENTAL-ILL-MAX-ACCUM-N1
           END-IF
      *
      *-----------------------------------------------------------------
      * IF WE HAVE A DENTAL CLAIM WHICH WAS PAID BY A FEE SCHEDULE,
      * WE WILL MOVE THE FEE SCHEDULE AMOUNT INTO THE N1 LINE.  I'M NOT
      * SURE WHETHER THE LITERAL IS ALREADY SET, SO I LEFT THE CODE IN
      * HERE, BUT IT IS PROBABLY BETTER SET IN THE DENTAL CODE.
      * A CURIOUS THING I FOUND IS THAT OUR FEE SCHEDULE FOR DENTAL IS
      * 8 POSITIONS, BUT OUR SPECIAL LIFETIME FIELD ON THE ANSWER LINE
      * WHICH WE USE TO GIVE THE PLANS THE DENTAL FEE SCHEDULE IS ONLY
      * 7 POSITIONS.  AS A RESULT, WE HAVE TO MOVE THE DIFFERENTIAL
      * AMOUNT, (FEE SCHEDULE), TO A 7 POSITION NUMERIC FIELD, THEREBY
      * TRUNCATING THE LEFT-MOST BYTE OF DATA.  THEN, WE CAN MOVE THAT
      * 7 POSITION FIELD TO THE ALPHANUMERIC OUTPUT FIELD.  SINCE THE
      * INTERMEDIATE FIELD WE ARE USING, (SPEC-1-LIFE-ACCUM-AFT-CRG),
      * IS DEFINED WITHOUT CENTS, AND DENTAL FEE SCHEDULE INCLUDES THE
      * CENTS, WE HAVE REDEFINED THE SPECIAL LIFETIME WORK FIELD FOR
      * THE DENTAL AMOUNT.
      * JANET 9-20-88
      *-----------------------------------------------------------------
      *
      *%%% TT 86616 KJ BEGIN
           IF  (((TOTAL-FEE-SCHEDULE-AMOUNT-TWR (TWR-CRG-SUB) > 0
              OR ( PROCEDURE-CODE-1-TWR (TWR-CRG-SUB) = 'D9221  '
              AND BENEFIT-OVERRIDE-CODE-TWR (TWR-CRG-SUB) = 'AFSY'))
      *%%% TT 86616 KJ END
                 AND MAC-SCHEDULE-IND-TWR (TWR-CRG-SUB) = ' ')
                OR ((MAC-SCHEDULE-IND-TWR (TWR-CRG-SUB) = '1'
                     OR '2' OR '3' OR '4' OR '5')
                     AND DENTAL-CARE-TWR (TWR-CRG-SUB)))
           AND STD-OPTION-CONTRACT-TWR
               MOVE LIT-7 TO SPEC-1-MAX-IND-N1
               MOVE PRICING-ALLOWANCE-TWR (TWR-CRG-SUB)
                 TO ALLOWABLE-DENTAL-AMOUNT-N1
               MOVE SPEC-1-LIFE-ACCUM-AFT-CRG
                 TO HOLD-7-DIGIT-NUMERIC
               MOVE HOLD-7-DIGIT-NUMERIC
                 TO SPEC-1-MAX-AMT-N1
           ELSE
               IF  SPEC-1-LIFE-ACCUM-AFT-CRG  >  ZERO
                   MOVE SPEC-1-LIFE-ACCUM-AFT-CRG
                     TO HOLD-7-DIGIT-NUMERIC
                   MOVE HOLD-7-DIGIT-NUMERIC
                     TO SPEC-1-MAX-AMT-N1
                   MOVE SPEC-LIFE-IND1 TO SPEC-1-MAX-IND-N1
                   IF  SPEC-2-LIFE-ACCUM-AFT-CRG > ZERO
                       MOVE SPEC-2-LIFE-ACCUM-AFT-CRG
                         TO HOLD-7-DIGIT-NUMERIC
                       MOVE HOLD-7-DIGIT-NUMERIC
                         TO SPEC-2-MAX-AMT-N1
                       MOVE SPEC-LIFE-IND2 TO SPEC-2-MAX-IND-N1
                   END-IF
               END-IF
           END-IF
      *%%% EL TT# 1171411 - BEGIN
           IF BA-COPAY-PER-ACCRUED-PERIOD
               MOVE LIT-S TO SPEC-1-MAX-IND-N1
               MOVE COINSURANCE-AMOUNT
                 TO HOLD-7-DIGIT-NUMERIC
               MOVE HOLD-7-DIGIT-NUMERIC
                 TO SPEC-1-MAX-AMT-N1
           END-IF
      *%%% EL TT# 1171411 - END
           .
       9260-EXIT.
           EXIT.

       9270-OVERLAY-CODES.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *        OVERLAY CODES FOR NO-OC-CALC COB INVOLVED CLAIMS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *----------------------------------------------------------------
      * DETERMINE IF THE PARTICULAR CHARGE LINE HAS COB INVOLVEMENT-
      * IF SO, WE WANT TO OVERLAY THE DEDUCT & COINS CODES FOR
      * SECONDARY PAYMENT.  IF  NOT, WE DO NOT WANT OVERLAY THE CODES.
      *----------------------------------------------------------------
      *
           IF  TS1-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
           OR  TS2-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
           OR  TS3-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
           OR  TS4-COB-PRIM-SEC-PROCESS-TWR (TWR-CRG-SUB)
           OR  TS1-NEG-COB-APPLICABLE-TWR (TWR-CRG-SUB)
           OR  TS2-NEG-COB-APPLICABLE-TWR (TWR-CRG-SUB)
           OR  TS3-NEG-COB-APPLICABLE-TWR (TWR-CRG-SUB)
           OR  TS4-NEG-COB-APPLICABLE-TWR (TWR-CRG-SUB)
               EVALUATE TRUE
                   WHEN BA-DCTB-CALENDAR-YEAR
                       PERFORM 9273-DEDUCT-OVERLAY THRU 9273-EXIT
                   WHEN BA-DCTB-PER-ADMISSION
                       PERFORM 9276-ADM-DEDUCT-OVERLAY THRU 9276-EXIT
               END-EVALUATE

               PERFORM 9279-COINS-OVERLAY THRU 9279-EXIT
           END-IF
           .
       9270-EXIT.
           EXIT.

       9273-DEDUCT-OVERLAY.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *     OVERLAY DED CODES FOR NO-OC-CALC COB INVOLVED CLAIMS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

            IF  NO-DEDUCT-APPLIED-TWR-AF (TWR-CRG-SUB)
            AND NO-DRUG-DED-TWR-AF (TWR-CRG-SUB)
                GO TO 9273-EXIT
            END-IF
      *
            IF  DEDUCT-IND = ('A' OR 'F' OR 'M' OR 'P' OR 'O' OR '2')
                GO TO 9273-EXIT
            END-IF
      *
            IF  NON-OPEN-SEASON-CHG-TWR
                IF  DEDUCT-IND  =  (LIT-E  OR  LIT-F)
      *             MOVE  LIT-L  TO  DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
                    MOVE  LIT-L  TO  DEDUCT-IND
                                     DEDUCTIBLE-CODE-N1
                ELSE
      *             MOVE LIT-S TO DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
                    MOVE LIT-S TO DEDUCT-IND
                                  DEDUCTIBLE-CODE-N1
                END-IF
            ELSE
      *         MOVE LIT-U TO DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
                MOVE LIT-U TO DEDUCT-IND
                              DEDUCTIBLE-CODE-N1
            END-IF
           .
       9273-EXIT.
           EXIT.

       9276-ADM-DEDUCT-OVERLAY.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   OVERLAY ADM DED CODES FOR NO-OC-CALC COB INVOLVED CLAIMS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

            IF  DEDUCT-IND = ('A' OR 'D' OR 'K' OR 'P' OR 'O' OR '4')
                GO TO 9276-EXIT
            END-IF
      *
            IF  DEDUCT-UPDTD-REG-CATAS-TWR-AF (TWR-CRG-SUB)
      *         MOVE LIT-X TO DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
                MOVE LIT-X TO DEDUCT-IND
                              DEDUCTIBLE-CODE-N1
            END-IF
      *
            IF  DEDUCT-UPDTD-MI-CATAS-TWR-AF (TWR-CRG-SUB)
      *         MOVE LIT-1 TO DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
                MOVE LIT-1 TO DEDUCT-IND
                              DEDUCTIBLE-CODE-N1
            END-IF
           .
       9276-EXIT.
           EXIT.

       9279-COINS-OVERLAY.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *    OVERLAY COINS CODES FOR NO-OC-CALC COB INVOLVED CLAIMS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

            EVALUATE COINS-IND
                WHEN 'A'
                WHEN 'B'
                WHEN 'K'
                WHEN 'P'
                WHEN 'F'
                WHEN 'R'
                WHEN 'T'
                WHEN 'W'
                WHEN '5'
                WHEN '8'
      *             MOVE LIT-S TO COINSURANCE-CODE-TWR (TWR-CRG-SUB)
                    MOVE LIT-S TO COINS-IND
                                  COINSURANCE-CODE-N1
      *
                WHEN 'C'
                WHEN 'D'
      *             MOVE LIT-E TO COINSURANCE-CODE-TWR (TWR-CRG-SUB)
                    MOVE LIT-E TO COINS-IND
                                  COINSURANCE-CODE-N1
      *
                WHEN 'L'
                WHEN 'M'
                WHEN 'G'
                WHEN 'H'
      *             MOVE LIT-N TO COINSURANCE-CODE-TWR (TWR-CRG-SUB)
                    MOVE LIT-N TO COINS-IND
                                  COINSURANCE-CODE-N1
      *
                WHEN '1'
                WHEN '2'
      *             MOVE LIT-6 TO COINSURANCE-CODE-TWR (TWR-CRG-SUB)
                    MOVE LIT-6 TO COINS-IND
                                  COINSURANCE-CODE-N1
      *
                WHEN '3'
                WHEN '4'
      *             MOVE LIT-7 TO COINSURANCE-CODE-TWR (TWR-CRG-SUB)
                    MOVE LIT-7 TO COINS-IND
                                  COINSURANCE-CODE-N1
           END-EVALUATE
           .
       9279-EXIT.
           EXIT.

       9280-CALL-FX85-WRITE-HIST.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *         WRITE THE N1 SUPPORTING HISTORY RECORD
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-


           IF  CONTRACT-ID-NUMBER-SHWR = LOW-VALUES
               MOVE ZEROES TO CONTRACT-ID-NUMBER-SHWR
           END-IF
      *SRG TT#175671 BEGIN
           PERFORM 9281-CALL-EOB-RTN THRU 9281-EXIT
      *SRG TT#175671 END

           MOVE SUPPORTING-HISTORY-WORK-RECORD TO N1-SUPPHIST-RECORD

            INITIALIZE FV01P2M0-IN-PARMS

            MOVE APPL-TYPE-CD
              TO FV01P2M0-CLM-TYPE-CD

            SET FV01P2M0-SUPP-HISTORY TO TRUE

            MOVE N1-SUPPHIST-RECORD
              TO FV01P2M0-SUPP-HIST-REC

      *%%% KX ADR CLAIMS ENHANCEMENT CHANGES BEGIN
            MOVE 'Y'
              TO FV01P2M0-OC-GEN-RSP-IND
      *%%% KX ADR CLAIMS ENHANCEMENT CHANGES END

            SET FV01P2M0-MODULE       TO TRUE
            CALL WS-S-CALL2-MODULE USING
                                   DFHEIBLK
                                   DFHCOMMAREA
                                   FV01P2M0-IN-PARMS
                                   FV01P2M0-OUT-PARMS
             ON EXCEPTION
                MOVE 9280 TO WS-V-ERROR-PARA
                SET FEP-MAF-CICS-SOFTWARE TO TRUE
                SET CALL-PGM              TO TRUE
                PERFORM 9880-ERROR-RTN THRU 9880-EXIT

           END-CALL

           IF FV01P2M0-FAIL
              MOVE 9280 TO WS-V-ERROR-PARA
              SET FEP-MAF-DB2-SOFTWARE  TO TRUE
              SET CLM-RESP-HIST-CBK-TBL TO TRUE
              SET INSERT-ROW            TO TRUE
              MOVE FV01P2M0-SQLCODE
                TO WS-V-SQL-CODE
              SET FEP-MAF-EXCPT-WARNING TO TRUE
              PERFORM 9880-ERROR-RTN THRU 9880-EXIT
           ELSE
              ADD 1 TO APPL-SUPPHIST-CNT
           END-IF
           .
       9280-EXIT.
           EXIT.

      *SRG TT#175671 BEGIN
       9281-CALL-EOB-RTN.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      * GET THE LATEST EOB-PRINT-FLAG FROM DATA BASE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *
           EVALUATE TRUE
      *%%% EL TT# 349648 - BEGIN
              WHEN DATE-TERMINATION-TWR > SPACES
      *%%% EL TT# 589436 - BEGIN
              WHEN DATE-PROCESSED-CENT-TWR -
                   CLM-BEGIN-DATE-CENT-TWR > 729
      *%%% EL TT# 589436 - END
      *%%% EL TT# 349648 - END
      *
      *CHECK HIPAA-PRIVACY-SW
      *
              WHEN CONFIDENTIAL-COMM-ADDRESS-TWR
      *
      *CHECK DIRECTION-OF-PAYMENT
      *THIS CHECK IS MOVED TO FH02P4M6 FROM HERE AS PART OF TT#CO237027
      *       WHEN PAY-THE-SUB-TWR
      *
      *CHECK EOB-REMARK-CODES
      *
              WHEN EOB-REMARK-CODE-1-TWR (TWR-CRG-SUB) (2:3) =
                   ('018' OR '304' OR '305')
              WHEN EOB-REMARK-CODE-2-TWR (TWR-CRG-SUB) (2:3) =
                   ('018' OR '304' OR '305')
              WHEN EOB-REMARK-CODE-3-TWR (TWR-CRG-SUB) (2:3) =
                   ('018' OR '304' OR '305')
              WHEN EOB-REMARK-CODE-4-TWR (TWR-CRG-SUB) (2:3) =
                   ('018' OR '304' OR '305')
              SET PRINT-THE-EOB-TWR TO TRUE
              SET PRINT-THE-EOB-N1  TO TRUE
              WHEN OTHER
                 IF CONTRACT-ID-NUMBER-TWR = FV02P1M0-CONTRACT-ID
      ***
      ***THIS MEANS WE ARE WORKING WITH THE SAME TWR
      ***IN THIS CASE WE JUST MOVE THE INDICATOR FROM TWR TO N1-LINE
      ***
                   MOVE FV02P1M0-EOB-PRINT-FLAG
                     TO EOB-PRINT-INDICATOR-TWR
                        EOB-PRINT-INDICATOR-N1
                 ELSE
      ***
      ***THIS MEANS WE ARE PROCESSING FIRST TIME OR NEW CLAIM
      ***
                   MOVE CONTRACT-ID-NUMBER-TWR TO FV02P1M0-CONTRACT-ID
                   SET FV02P1M0-MODULE     TO TRUE
                   CALL WS-S-CALL2-MODULE   USING
                                            FV02P1M0-IN-PARMS
                                            FV02P1M0-OUT-PARMS
                     ON EXCEPTION
                        MOVE 9281                 TO WS-V-ERROR-PARA
                        SET FEP-MAF-CICS-SOFTWARE TO TRUE
                        SET CALL-PGM              TO TRUE
                        PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
                   END-CALL

                    IF FV01P2M0-FAIL
                       MOVE 9281 TO WS-V-ERROR-PARA
                       SET FEP-MAF-DB2-SOFTWARE   TO TRUE
                       SET EOB-DELIVERY-EVENT-TBL TO TRUE
                       SET SELECT-ROW             TO TRUE
                       MOVE FV02P1M0-SQLCODE
                         TO WS-V-SQL-CODE
                       SET FEP-MAF-EXCPT-WARNING TO TRUE
                       PERFORM 9880-ERROR-RTN THRU 9880-EXIT
                    ELSE
                       MOVE FV02P1M0-EOB-PRINT-FLAG
                         TO EOB-PRINT-INDICATOR-TWR
                            EOB-PRINT-INDICATOR-N1
                    END-IF
                 END-IF
              END-EVALUATE

      *
           .
       9281-EXIT.
           EXIT.
      *SRG TT#175671 END

       9290-MOVE-EXEC-DATA-TO-TWR.

           MOVE DEDUCT-IND TO DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
           MOVE COINS-IND TO COINSURANCE-CODE-TWR (TWR-CRG-SUB)
           IF  PROCESS-PERIOD-NOT-ON-FILE
           OR  PLAN-APPROVED
               CONTINUE
           ELSE
               MOVE DEDUCT-AMOUNT
                 TO DEDUCTIBLE-AMOUNT-CP-TWR (TWR-CRG-SUB)
                    HOLD-6-DIGIT-V99
               MOVE HOLD-6-DIGIT-NUMERIC
                 TO DEDUCTIBLE-AMOUNT-TWR (TWR-CRG-SUB)
               MOVE COINSURANCE-AMOUNT
                 TO COINSURANCE-AMOUNT-CP-TWR (TWR-CRG-SUB)
                    HOLD-8-DIGIT-V99
               MOVE HOLD-8-DIGIT-NUMERIC
                 TO COINSURANCE-AMOUNT-TWR (TWR-CRG-SUB)
               MOVE AMOUNT-PAID TO AMOUNT-PAID-CRG
                                   AMOUNT-PAID-CP-TWR (TWR-CRG-SUB)
               MOVE AMT-PD-CRG-PRT TO AMOUNT-PAID-TWR (TWR-CRG-SUB)
           END-IF
           .
       9290-EXIT.
           EXIT.

       9300-BUILD-L1.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            PRODUCE THE L1 SUPPORTING HISTORY RECORD
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           ADD 01 TO HOLD-PROCESS-SEQ
           SET FH02P0ML-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      APPL-RETURN-AREA
                                      HOLD-PROCESS-SEQ
                                      TRANSACTION-WORK-RECORD
                                      TWR-CRG-SUB
                                      P0M3-EXECUTIVE-DATA-FIELDS
                                      BENEFIT-ADMN-PAY-LVL-TABLE
                                      FH01-EXECUTIVE-DATA-FIELDS
                ON EXCEPTION
                   MOVE 9300                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL

      ***TT 26538
              GO TO 0000-GOBACK
      ***TT 26538
           .
       9300-EXIT.
           EXIT.

       9400-HIST-AND-TIMELY-FILING-N1.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   FORMAT AND PRINT N1 LINES FOR HISTORY & TIMELY FILING
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           PERFORM 9210-SET-UP-N1-COMMON-DATA THRU 9210-EXIT

           PERFORM 9420-N1-DAYS-VISITS THRU 9420-EXIT

           PERFORM 9430-MOVE-DEDUCT-N1 THRU 9430-EXIT

           PERFORM 9440-MOVE-COIN-N1 THRU 9440-EXIT

           IF  PRODUCE-N4-LINES
               IF  DISP1-1STEP-OC-CALC-TWR
               OR  DISP2-1STEP-OC-CALC-TWR
      *%%% KX TT 49146 - BEGIN
      *        OR  DISP6-1STEP-OC-CALC-TWR                              FH02P0M3
      *%%% KX TT 49146 - END
                   GO TO 9400-EXIT
               END-IF
           END-IF

           PERFORM 9280-CALL-FX85-WRITE-HIST THRU 9280-EXIT
           .
       9400-EXIT.
           EXIT.

       9420-N1-DAYS-VISITS.
      *%%% EL TT# 51261 - BEGIN
           MOVE SERVICE-ACCUM-ID-TWR (TWR-CRG-SUB)
             TO HOLD-BG-SERVICE-ACCUM-ID-BEN
      *%%% EL TT# 51261 - END

           IF  BG-NURSE-VISIT-1YR-BEN
           OR  OUTPT-VISITS-UPDATED-TWR-AF (TWR-CRG-SUB)
               MOVE 'N' TO VISITS-IND-N1
               MOVE VISITS-ACCUM-F030 TO VISITS-ACCUM-N1
           END-IF

           IF  BG-OCCUPATION-SPEECH-1YR-BEN
               MOVE 'T' TO VISITS-IND-N1
               MOVE THERAPY-VISITS-ACCUM-F030 TO VISITS-ACCUM-N1
           END-IF

           IF  BG-PHYSICAL-THERAPY-1YR-BEN
               MOVE 'P' TO VISITS-IND-N1
               MOVE PHYS-THERAPY-VISITS-ACCUM-F030 TO VISITS-ACCUM-N1
           END-IF

           IF  BG-OUTPAT-MENTAL-COND-1YR-BEN
           OR  MI-VISITS-UPDATED-TWR-AF (TWR-CRG-SUB)
               MOVE 'M' TO VISITS-IND-N1
               MOVE MI-VISITS-ACCUM-F030 TO VISITS-ACCUM-N1
           END-IF

           IF  BG-INPAT-MENTAL-COND-1YR-BEN
           OR  MI-DAYS-UPDATED-TWR-AF (TWR-CRG-SUB)
               MOVE 'M' TO DAYS-IND-N1
               MOVE MI-DAYS-ACCUM-F030 TO DAYS-ACCUM-N1
           END-IF


           IF  PROF-MI-DAYS-UPDTD-TWR-AF (TWR-CRG-SUB)
               MOVE 'M' TO DAYS-IND-N1
               MOVE MI-PROF-DAYS-ACCUM-F030 TO DAYS-ACCUM-N1
           END-IF

      *%%% P7 TT 1059469 BEGIN
           IF  BG-SKLED-NURSE-FACIL-1YR-BEN
               MOVE 'P' TO DAYS-IND-N1
               MOVE SKILL-NRS-NO-MEDA-ACCUM-F030
                 TO DAYS-ACCUM-N1
           END-IF
      *%%% P7 TT 1059469 END

           IF  BG-POS-CHIRO-DAYS-1YR-BEN
               MOVE 'Y' TO CHIRO-VISITS-IND-N1
               MOVE CHIRO-CARE-DAY-ACCUM-F030
                 TO CHIRO-VISITS-ACCUM-NUM-N1
           END-IF

      *%%% PE TT 47776 BEGIN
           IF  BG-NUTRITIONAL-CNS-BEN
               MOVE 'U' TO VISITS-IND-N1
               MOVE NUTRITIONL-CNS-VSTS-ACCUM-F030
                TO VISITS-ACCUM-N1
           END-IF
      *%%% PE TT 47776 END

      *%%% PE TT 49933 BEGIN
           IF  BG-ACUPUNCTURE-BEN
               MOVE 'A' TO VISITS-IND-N1
               MOVE ACCUPUNCTURE-VISITS-ACCUM-F030
                TO VISITS-ACCUM-N1
           END-IF
      *%%% PE TT 49933 END
      *%%% PE TT 274020 BEGIN
           IF  BG-MHSA-MATERNITY-BEN
               MOVE 'Q' TO VISITS-IND-N1
               MOVE MHSA-MATERNITY-ACCUM-F030
                TO VISITS-ACCUM-N1
           END-IF
      *%%% PE TT 274020 END
           .
       9420-EXIT.
           EXIT.

       9430-MOVE-DEDUCT-N1.
           MOVE DEDUCTIBLE-CODE-TWR (TWR-CRG-SUB)
             TO DEDUCTIBLE-CODE-N1
      * IF THE DEDUCTIBLE CODE INDICATES THAT AN ANNUAL DEDUCTIBLE WAS
      * INVOLVED:
      *
      *                                                                 FH02P0M3
      *    IF  DEDUCTIBLE-CODE-N1 = 'M' OR 'G' OR 'H' OR                FH02P0M3
      *                             'E' OR 'F' OR '2' OR '3'            FH02P0M3
      *%%% KX TT 84175 BEGIN
               MOVE DEDUCT-ACCUM-F030 TO HOLD-6-DIGIT-V99
               MOVE HOLD-6-DIGIT-NUMERIC  TO DEDUCTIBLE-ACCUM-N1
               MOVE FAM-DEDUCT-ACCUM-F030 TO HOLD-6-DIGIT-V99
               MOVE HOLD-6-DIGIT-NUMERIC  TO FAMILY-DEDUCT-APPLIED-N1
      *%%% KX TT 84175 END
               IF  DEDUCTIBLE-CODE-N1 =  '2' OR '3'
                   MOVE  'M'  TO  FAMILY-DEDUCT-INDICATOR-N1
               ELSE
                   IF  DEDUCTIBLE-CODE-N1 = ('M' OR 'G' OR 'H')
                   AND (FAM-DEDUCT-ACCUM-F030 > ZERO)
                       MOVE 'A' TO FAMILY-DEDUCT-INDICATOR-N1
                   END-IF
               END-IF

      *    IF  DEDUCT-UPDTD-REG-CATAS-TWR-AF (TWR-CRG-SUB)              FH02P0M3
               MOVE FAMILY-CAT-ACCUM-F030 TO CAT-ACCUM-AFT-CRG
               MOVE CAT-ACCUM-AFT-CRG     TO STOP-LOSS-ACCUM-NUM-N1

           .
       9430-EXIT.
           EXIT.

       9440-MOVE-COIN-N1.
           MOVE COINSURANCE-CODE-TWR (TWR-CRG-SUB)
             TO COINSURANCE-CODE-N1

      *    IF  COINS-UPDTD-REG-CATAS-TWR-AF (TWR-CRG-SUB)               FH02P0M3
               MOVE FAMILY-CAT-ACCUM-F030 TO CAT-ACCUM-AFT-CRG
               MOVE CAT-ACCUM-AFT-CRG     TO STOP-LOSS-ACCUM-NUM-N1

           .
       9440-EXIT.
           EXIT.


       9500-CROSSFOOT-CHARGE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *                   CROSSFOOT THE CHARGE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           EVALUATE  TRUE
      *%%% TT 344326  KJ BEGIN
             WHEN (RETAIL-DRUG-PROGRAM-TWR
                   OR SPECIALTY-DRUG-TWR)
             AND PREFERRED-PROVIDER-TWR (TWR-CRG-SUB)
      ***%%%TT407939 COMMENT OUT POS FIELDS
      *****  WHEN RETAIL-DRUG-PROGRAM-TWR
      *****  ALSO POS-LEVEL-OF-BEN-TWR (TWR-CRG-SUB)
      ***%%%TT407939 COMMENT OUT POS FIELDS
               MOVE EDIT-OVERRIDE-CODES-TWR (TWR-CRG-SUB)
                 TO EVAL-EDIT-CODES
             WHEN OTHER
               MOVE SPACES TO EVAL-EDIT-CODES
           END-EVALUATE

           EVALUATE TRUE
      *%%% EL TT# 9451 BEGIN
             WHEN (RETAIL-DRUG-PROGRAM-TWR
                   OR SPECIALTY-DRUG-TWR)
      *%%% TT 344326  KJ END
              AND AMT-PAID-OTHER-CARR-IND-1-TWR (TWR-CRG-SUB) = 'MC'
      *%%% EL TT# 9451 END
             WHEN PRICING-METHOD-1-TWR  (TWR-CRG-SUB) = 'I'
             WHEN TOTAL-FEE-SCHEDULE-AMOUNT-TWR (TWR-CRG-SUB) > 0
             WHEN EOB-REMARK-CODE-1-TWR (TWR-CRG-SUB) (1:1) = 'T'
             WHEN EOB-REMARK-CODE-2-TWR (TWR-CRG-SUB) (1:1) = 'T'
             WHEN EOB-REMARK-CODE-3-TWR (TWR-CRG-SUB) (1:1) = 'T'
             WHEN EOB-REMARK-CODE-4-TWR (TWR-CRG-SUB) (1:1) = 'T'
             WHEN EVAL-PCS-HOLD-HARMLESS       (1)
             WHEN EVAL-PCS-HOLD-HARMLESS       (2)
             WHEN EVAL-PCS-HOLD-HARMLESS       (3)
             WHEN EVAL-PCS-HOLD-HARMLESS       (4)
             WHEN EVAL-PCS-HOLD-HARMLESS       (5)
      *%%% TT 86616 KJ BEGIN
             WHEN ( PROCEDURE-CODE-1-TWR (TWR-CRG-SUB) = 'D9221  '
             AND BENEFIT-OVERRIDE-CODE-TWR (TWR-CRG-SUB) = 'AFSY')
      *%%% TT 86616 KJ END
               CONTINUE
             WHEN OTHER
               IF  OC-CALCULATED
               AND ANY-APP-AFFECTED-CHRG-TWR (TWR-CRG-SUB)
                   MOVE 0 TO POSITIVE-SAVINGS-AMT
                             NEGATIVE-SAVINGS-AMT
                   IF  TS1-NOT-APPLICABLE-TWR (TWR-CRG-SUB)
                       CONTINUE
                   ELSE
                       MOVE TYPE-SAVINGS-IND-1-TWR (TWR-CRG-SUB)
                         TO HOLD-SAVINGS-CODE
                       MOVE SAVINGS-AMOUNT-1-CP-TWR (TWR-CRG-SUB)
                         TO HOLD-SAVINGS-AMOUNT
                       PERFORM 9510-ACCUM-SAVINGS THRU 9510-EXIT
                   END-IF
                   IF  TS2-NOT-APPLICABLE-TWR (TWR-CRG-SUB)
                       CONTINUE
                   ELSE
                       MOVE TYPE-SAVINGS-IND-2-TWR (TWR-CRG-SUB)
                         TO HOLD-SAVINGS-CODE
                       MOVE SAVINGS-AMOUNT-2-CP-TWR (TWR-CRG-SUB)
                         TO HOLD-SAVINGS-AMOUNT
                       PERFORM 9510-ACCUM-SAVINGS THRU 9510-EXIT
                   END-IF
                   IF  TS3-NOT-APPLICABLE-TWR (TWR-CRG-SUB)
                       CONTINUE
                   ELSE
                       MOVE TYPE-SAVINGS-IND-3-TWR (TWR-CRG-SUB)
                         TO HOLD-SAVINGS-CODE
                       MOVE SAVINGS-AMOUNT-3-CP-TWR (TWR-CRG-SUB)
                         TO HOLD-SAVINGS-AMOUNT
                       PERFORM 9510-ACCUM-SAVINGS THRU 9510-EXIT
                   END-IF
                   IF  TS4-NOT-APPLICABLE-TWR (TWR-CRG-SUB)
                       CONTINUE
                   ELSE
                       MOVE TYPE-SAVINGS-IND-4-TWR (TWR-CRG-SUB)
                         TO HOLD-SAVINGS-CODE
                       MOVE SAVINGS-AMOUNT-4-CP-TWR (TWR-CRG-SUB)
                         TO HOLD-SAVINGS-AMOUNT
                       PERFORM 9510-ACCUM-SAVINGS THRU 9510-EXIT
                   END-IF
                   PERFORM 9520-CROSSFOOT-CALCULATION THRU 9520-EXIT
                   PERFORM 9530-CROSSFOOT-CHECK THRU 9530-EXIT
               END-IF
           END-EVALUATE
           .
       9500-EXIT.
           EXIT.

       9510-ACCUM-SAVINGS.
           EVALUATE TRUE
             WHEN HOSP-AUDIT-SAVINGS-CODES
               CONTINUE
             WHEN NEGATIVE-SAVINGS-CODES
               ADD HOLD-SAVINGS-AMOUNT
                TO NEGATIVE-SAVINGS-AMT
             WHEN OTHER
               ADD HOLD-SAVINGS-AMOUNT
                TO POSITIVE-SAVINGS-AMT
           END-EVALUATE
           .
       9510-EXIT.
           EXIT.

       9520-CROSSFOOT-CALCULATION.
           MOVE CVRD-CHRGS-ALL-SERVS-CP-TWR (TWR-CRG-SUB)
             TO CEM-CVRD-CHGS
           MOVE PARTIAL-REJECT-AMOUNT-TWR (TWR-CRG-SUB)
             TO CEM-PARTIAL-REJECT-AMT

      *%%% EL CMR354750 BEGIN - PERFORM CROSSFOOT ON MEDICARE CLAIMS
      *                         PROBLEM LOG CLMPRB00302
           IF  PRODUCE-N4-LINES
      *%%% EL CMR354750 END

               MOVE DEDUCTIBLE-AMOUNT-CP-TWR (TWR-CRG-SUB)
                 TO CEM-DEDUCT-AMOUNT
               MOVE COINSURANCE-AMOUNT-CP-TWR (TWR-CRG-SUB)
                 TO CEM-COINS-AMOUNT
               MOVE AMOUNT-PAID-CP-TWR (TWR-CRG-SUB)
                 TO CEM-AMOUNT-PAID

               COMPUTE TEMP-CHARGES
                     = PARTIAL-REJECT-AMOUNT-TWR (TWR-CRG-SUB)
                     + DEDUCTIBLE-AMOUNT-CP-TWR (TWR-CRG-SUB)
                     + COINSURANCE-AMOUNT-CP-TWR (TWR-CRG-SUB)
                     + AMOUNT-PAID-CP-TWR (TWR-CRG-SUB)
                     + POSITIVE-SAVINGS-AMT
                     - NEGATIVE-SAVINGS-AMT
           ELSE
               MOVE DEDUCT-AMOUNT TO CEM-DEDUCT-AMOUNT
               MOVE COINSURANCE-AMOUNT TO CEM-COINS-AMOUNT
               MOVE AMOUNT-PAID TO CEM-AMOUNT-PAID

               COMPUTE TEMP-CHARGES
                  = PARTIAL-REJECT-AMOUNT-TWR (TWR-CRG-SUB)
                  + DEDUCT-AMOUNT
                  + COINSURANCE-AMOUNT
                  + AMOUNT-PAID
                  + POSITIVE-SAVINGS-AMT
                  - NEGATIVE-SAVINGS-AMT
           END-IF

           MOVE POSITIVE-SAVINGS-AMT TO CEM-POSITIVE-SAVINGS
           MOVE NEGATIVE-SAVINGS-AMT TO CEM-NEGATIVE-SAVINGS

           COMPUTE CROSSFOOT-DIFFERENCE
                 = CVRD-CHRGS-ALL-SERVS-CP-TWR (TWR-CRG-SUB)
                 - TEMP-CHARGES
           .
       9520-EXIT.
           EXIT.

       9530-CROSSFOOT-CHECK.
           IF  CROSSFOOT-DIFFERENCE < 1.00
               CONTINUE
           ELSE
      *%%% PE TT85518 BEGIN
             IF PROCESS-CODE-TWR IS NOT = 'A'
               AND (ORIGINAL-D1-TWR OR ADJUSTMENT-D2-TWR)
               AND DENTAL-CARE-HCL
                 SET DEFER-THIS-CHARGE TO TRUE
                 MOVE R-FZK TO ERROR-REASON
                 PERFORM 9900-ERROR-ROUTINE
                 THRU 9900-EXIT
             ELSE
      *%%% PE TT85518 END
               MOVE LINE-NUMBER-AN-TWR (TWR-CRG-SUB)
                 TO WS-V-CHG-LINE-NUM
                SET   PROG-MSG       TO  TRUE
                MOVE 9530            TO WS-V-ERROR-PARA
                SET   FEP-MAF-OTHER-SOFTWARE    TO TRUE
                MOVE  2000           TO FEP-MAF-EXCPT-MSG-ID-SUFFIX
                MOVE  SPACES         TO WS-V-ERR-MESSAGE-TEXT
                MOVE  CROSSFOOT-ERROR-MSG
                                     TO WS-V-ERR-MESSAGE-TEXT
                SET FEP-MAF-EXCPT-INFORMATIONAL TO TRUE
                PERFORM 9880-ERROR-RTN
                   THRU 9880-EXIT
               MOVE 'FP8'           TO ERROR-REASON
               SET CANNOT-PROCESS-THIS-CHARGE TO TRUE
               PERFORM 9900-ERROR-ROUTINE THRU 9900-EXIT
             END-IF
           END-IF
           .
       9530-EXIT.
           EXIT.

      *%%% EL TT 9223 BEGIN
       9600-RESET-CAT-MAX-IND.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *   SET THE CATASTROPHIC MAX IND TO RESET IF ACCUM WAS AT OR
      *   ABOVE THE MAX AND HAS FALLEN BELOW THE MAX ON THIS CLAIM
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           EVALUATE TRUE
             WHEN REG-CAT-MAX-MET-CURR
             WHEN BOTH-CAT-MAX-MET-CURR
             WHEN REG-CAT-MAX-MET-PR1
             WHEN BOTH-CAT-MAX-MET-PR1
             WHEN REG-CAT-MAX-MET-PR2
             WHEN BOTH-CAT-MAX-MET-PR2
               IF  FAMILY-CAT-ACCUM-F030 < REG-CATAS-MAX-DOLLAR-AMT
                   SET CATASTROPHIC-MAX-RESET-TWR TO TRUE
                   SET THIS-CHARGE-UPDATED-FAMILY TO TRUE
               END-IF
           END-EVALUATE

           EVALUATE TRUE
             WHEN PPO-CAT-MAX-MET-CURR
             WHEN BOTH-CAT-MAX-MET-CURR
             WHEN PPO-CAT-MAX-MET-PR1
             WHEN BOTH-CAT-MAX-MET-PR1
             WHEN PPO-CAT-MAX-MET-PR2
             WHEN BOTH-CAT-MAX-MET-PR2
               IF  FAMILY-PPO-ACCUM-F030 < PPO-CATAS-MAX-DOLLAR-AMT
                   SET CATASTROPHIC-MAX-RESET-TWR TO TRUE
                   SET THIS-CHARGE-UPDATED-FAMILY TO TRUE
               END-IF
           END-EVALUATE
           .
       9600-EXIT.
           EXIT.
      *%%% EL TT 9223 END

       9700-CONVERT-FEP-CENTURY-DT.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *    CALL FX70P2M6 TO CONVERT FEP CENTURY DATE TO 8 POSITION
      *    CALENDAR DATE
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           SET FX70P2M6-MODULE       TO TRUE
           CALL WS-S-CALL2-MODULE   USING
                                   DFHEIBLK
                                   DFHCOMMAREA
                                   FEP-CENTURY-DATE
                                   MMDDCCYY-DATE
             ON EXCEPTION
               MOVE 9700                 TO WS-V-ERROR-PARA
               SET FEP-MAF-CICS-SOFTWARE TO TRUE
               SET CALL-PGM              TO TRUE
               PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           MOVE SPACES TO WS-S-CALL2-MODULE
           .
       9700-EXIT.
           EXIT.

       9900-ERROR-ROUTINE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            PROCESS ERRORS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           IF  APPL-ERROR
               GO TO 0000-GOBACK
           END-IF
           IF  ERROR-REASON NOT = SPACES


               EVALUATE TRUE
                  WHEN CANNOT-PROCESS-THIS-CHARGE
                     MOVE TRANSACTION-ORG-RECORD
                       TO TRANSACTION-WORK-RECORD
                          (1:LENGTH OF TRANSACTION-ORG-RECORD)
                     MOVE NOT-PROCESS-STATUS TO CLAIM-STATUS-TWR
                     MOVE ERROR-REASON TO CLM-RESPONSE-REASON-1-TWR
      * 04/01/2003  F ALABI TT 3612
                     MOVE 'FPB'        TO CLM-RESPONSE-REASON-1-TWR
                     MOVE ERROR-REASON TO CLM-RESPONSE-REASON-2-TWR
      * 04/01/2003  F ALABI TT 3612
                     SET SKIP-PROCESSING TO TRUE
                     GO TO 0000-GOBACK
                  WHEN DEFER-THIS-CHARGE
                     PERFORM VARYING ORG-CRG-SUB FROM 1 BY 1
                       UNTIL ORG-CRG-SUB > NUMBER-OF-CHARGES-ORG
                       IF  LINE-NUMBER-ORG (ORG-CRG-SUB) =
                           LINE-NUMBER-TWR (TWR-CRG-SUB)
                         MOVE CHARGE-LINE-ORG (ORG-CRG-SUB)
                           TO CHARGE-LINE-TWR (TWR-CRG-SUB)
                       END-IF
                     END-PERFORM
                     MOVE '50' TO CLAIM-STATUS-TWR
                                  CHARGE-STATUS-TWR (TWR-CRG-SUB)
                     ADD +01 TO TOTAL-DEF-CHARGES
                     SET NOT-EDITTING-AGAINST-HISTORY TO TRUE
                     PERFORM 9910-SRCH-FOR-ERROR THRU 9910-EXIT
                        VARYING SUB1 FROM 1 BY 1
                        UNTIL SUB1 > 5 OR EDITTING-AGAINST-HISTORY
      *%%% EL TT 915663 - BEGIN
                     PERFORM 9950-BUILD-RESPONSE-IN-TWR THRU 9950-EXIT
      *%%% EL TT 915663 - END
                     IF  EDITTING-AGAINST-HISTORY
                         MOVE 'Y'
                           TO CHRG-SUPPORT-HIST-SW-TWR (TWR-CRG-SUB)
                         PERFORM 9960-DO-H3-SUPP-HIST THRU 9960-EXIT
                     END-IF
      *%%% EL TT# 22916 - BEGIN                                         FH02P0M3
      *********      GO TO 0000-GOBACK                                  FH02P0M3
      *%%% EL TT# 22916 - END                                           FH02P0M3
                  WHEN REJECT-THIS-CHARGE
                     SET NOT-EDITTING-AGAINST-HISTORY TO TRUE
                     PERFORM 9910-SRCH-FOR-ERROR THRU 9910-EXIT
                        VARYING SUB1 FROM 1 BY 1
                        UNTIL SUB1 > 5 OR EDITTING-AGAINST-HISTORY
                     IF  EDITTING-AGAINST-HISTORY
                         MOVE 'Y'
                           TO CHRG-SUPPORT-HIST-SW-TWR (TWR-CRG-SUB)
                         PERFORM 9960-DO-H3-SUPP-HIST THRU 9960-EXIT
                     END-IF
      *%%% P7 TT 1059469 BEGIN
                     EVALUATE TRUE
                       WHEN ERROR-REASON = 'FZ7'
                         PERFORM 9970-CLAIM-ERROR-ROUTINE
                            THRU 9970-EXIT
                       WHEN OTHER
                         PERFORM 9940-REJECT-CHARGE
                            THRU 9940-EXIT
                     END-EVALUATE
      *%%% P7 TT 1059469 END
               END-EVALUATE

           END-IF
                                                                        FH02P0M3
           .
       9900-EXIT.
           EXIT.

       9910-SRCH-FOR-ERROR.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *    SEARCH FOR THE ERROR REASON ON THE H3 SUPP HISTORY TBL
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           IF  ERROR-REASON = 'FKR'
               IF  EDIT-REASON-CODE (SUB1) = 'FKP'
                   PERFORM VARYING SUB2 FROM 1 BY 1
                      UNTIL SUB2 > EDIT-HIST-NUMBER (SUB1)
                      IF  EDIT-HIST-FKR-ON (SUB1, SUB2)
                          SET EDITTING-AGAINST-HISTORY TO TRUE
                      END-IF
                   END-PERFORM
               END-IF
           ELSE
               IF  EDIT-REASON-CODE (SUB1) = ERROR-REASON
                   SET EDITTING-AGAINST-HISTORY TO TRUE
               END-IF
           END-IF
           .
       9910-EXIT.
           EXIT.

       9940-REJECT-CHARGE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            REJECTION LOGIC
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      * IF THE CHARGE WAS PREVIOUSLY QUALIFIED AND WE ARE NOW GOING
      * TO REJECT IT, WE WILL NEED TO BACK ONE OUT OF THE TOTAL
      * OF QUALIFIED CHARGES. THAT TOTAL WILL BE USED AT THE END OF
      * PROCESSING THE CLAIM TO DETERMINE IF ANY QUALIFIED CHARGES ARE
      * LEFT. IF  NOT, STATUS WILL RETURN TO AN APPROVAL.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      *
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      * IF THE CHARGE WAS PREVIOUSLY DEFERRED AND WE ARE NOW GOING
      * TO REJECT IT, WE WILL NEED TO BACK ONE OUT OF THE TOTAL
      * OF DEFERRED CHARGES. THAT TOTAL WILL BE USED AT THE END OF
      * PROCESSING THE CLAIM TO DETERMINE IF ANY DEFERRED CHARGES ARE
      * LEFT. IF  NOT, STATUS WILL RETURN TO AN APPROVAL.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      *
           IF  DEFERRED-CHRG-TWR (TWR-CRG-SUB)
               SUBTRACT +01 FROM TOTAL-DEF-CHARGES
               IF  TOTAL-DEF-CHARGES < 1
                   MOVE '70' TO CLAIM-STATUS-TWR
               END-IF
           END-IF
      *
      *-----------------------------------------------------------------
      *     CALL FH02P6M0 TO WRITE A DUMMY SUPPORTING HISTORY RECORD
      * WHEN A CHARGE HAS SUPPORTING HISTORY CREATED IN A PREVIOUS
      * MODULE AND IS NOW GOING TO REJECT, WE NEED TO TELL PLAN
      * SUPPORT TO DROP THE ORIGINAL SUPPORTING HISTORY BY CREATING
      * A DUMMY RECORD WITH A LOWER CHARGE STATUS. HOWEVER, WE DO NOT
      * WANT TO DO THIS FOR THE PRIMARY CALCULATION OF A COB CLAIM.
      *-----------------------------------------------------------------
      *
      *
           IF  COB-INVOLVED-TWR
               CONTINUE
           ELSE
               IF  CHRG-SUPPORT-HIST-TWR (TWR-CRG-SUB)
                   MOVE TWR-CRG-SUB TO LINE-NUMBER
                   MOVE SPACES      TO K1-MESSAGE-LINE
                   SET FH02P0MK-MODULE       TO TRUE
                   CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                              DUMMY-COMMAREA
                                              APPL-RETURN-AREA
                                              FUNCTION-CODE
                                              TRANSACTION-WORK-RECORD
                                              LINE-NUMBER
                                              ESRD-OR-INC-DATE
                                              DUMMY-REASON
                                              K1-MESSAGE-LINE
                        ON EXCEPTION
                           MOVE 9940                 TO WS-V-ERROR-PARA
                           SET FEP-MAF-CICS-SOFTWARE TO TRUE
                           SET CALL-PGM              TO TRUE
                           PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
                   END-CALL
               END-IF
           END-IF
      *
           ADD +01 TO TOTAL-REJECTED-CHARGES
           MOVE '30' TO CHARGE-STATUS-TWR (TWR-CRG-SUB)
      *
      *%%% KX TT 49146 - BEGIN
      *    IF  DISPOSITION-6-TWR
      *        ADD +01 TO TOTAL-REJ-DISP6-CHARGES
      *    END-IF
      *%%% KX TT 49146 - END
      *
           MOVE SPACES TO CHARGE-RESPONSE-REASONS-TWR (TWR-CRG-SUB)
                          CHARGE-UPDATED-PATIENT-SW
                          CHARGE-UPDATED-FAMILY-SW
                          STOP-LOSS-DFR-SW
      *
           MOVE ERROR-REASON TO CHRG-RESPONSE-REASON-1-TWR (TWR-CRG-SUB)
      *
           MOVE ' ' TO CHRG-SUPPORT-HIST-SW-TWR (TWR-CRG-SUB)
           .
       9940-EXIT.
           EXIT.
      *
       9950-BUILD-RESPONSE-IN-TWR.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            MOVE ERROR TO FIRST EMPTY SLOT ON THE TWR
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           EVALUATE TRUE
              WHEN CHRG-RESPONSE-REASON-1-TWR(TWR-CRG-SUB) = SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-1-TWR (TWR-CRG-SUB)
               IF  EDITTING-AGAINST-HISTORY
                   MOVE 'Y' TO CHRG-RESPONSE-SH-IND-1-TWR (TWR-CRG-SUB)
               END-IF
              WHEN CHRG-RESPONSE-REASON-2-TWR(TWR-CRG-SUB) = SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-2-TWR (TWR-CRG-SUB)
               IF  EDITTING-AGAINST-HISTORY
                   MOVE 'Y' TO CHRG-RESPONSE-SH-IND-2-TWR (TWR-CRG-SUB)
               END-IF
              WHEN CHRG-RESPONSE-REASON-3-TWR(TWR-CRG-SUB) = SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-3-TWR (TWR-CRG-SUB)
               IF  EDITTING-AGAINST-HISTORY
                   MOVE 'Y' TO CHRG-RESPONSE-SH-IND-3-TWR (TWR-CRG-SUB)
               END-IF
              WHEN CHRG-RESPONSE-REASON-4-TWR(TWR-CRG-SUB) = SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-4-TWR (TWR-CRG-SUB)
               IF  EDITTING-AGAINST-HISTORY
                   MOVE 'Y' TO CHRG-RESPONSE-SH-IND-4-TWR (TWR-CRG-SUB)
               END-IF
              WHEN CHRG-RESPONSE-REASON-5-TWR(TWR-CRG-SUB) = SPACES
               MOVE ERROR-REASON
                 TO CHRG-RESPONSE-REASON-5-TWR (TWR-CRG-SUB)
               IF  EDITTING-AGAINST-HISTORY
                   MOVE 'Y' TO CHRG-RESPONSE-SH-IND-4-TWR (TWR-CRG-SUB)
               END-IF
              WHEN OTHER
               MOVE 'M' TO CHRG-OVERFLOW-REASON-SW-TWR (TWR-CRG-SUB)
           END-EVALUATE
           .
       9950-EXIT.
           EXIT.
      *%%% PE TT 34821 BEGIN                                            FH02P0M3
       9951-BUILD-CLM-RESPONSE.                                         FH02P0M3
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-  FH02P0M3
      *            MOVE ERROR TO FIRST EMPTY SLOT ON THE TWR            FH02P0M3
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-  FH02P0M3

           EVALUATE TRUE                                                FH02P0M3
              WHEN CLM-RESPONSE-REASON-1-TWR = SPACES                   FH02P0M3
               MOVE ERROR-REASON                                        FH02P0M3
                 TO CLM-RESPONSE-REASON-1-TWR                           FH02P0M3
              WHEN CLM-RESPONSE-REASON-2-TWR = SPACES                   FH02P0M3
               MOVE ERROR-REASON                                        FH02P0M3
                 TO CLM-RESPONSE-REASON-2-TWR                           FH02P0M3
              WHEN CLM-RESPONSE-REASON-3-TWR = SPACES                   FH02P0M3
               MOVE ERROR-REASON                                        FH02P0M3
                 TO CLM-RESPONSE-REASON-3-TWR                           FH02P0M3
              WHEN CLM-RESPONSE-REASON-4-TWR = SPACES                   FH02P0M3
               MOVE ERROR-REASON                                        FH02P0M3
                 TO CLM-RESPONSE-REASON-4-TWR                           FH02P0M3
              WHEN CLM-RESPONSE-REASON-5-TWR = SPACES                   FH02P0M3
               MOVE ERROR-REASON                                        FH02P0M3
                 TO CLM-RESPONSE-REASON-5-TWR                           FH02P0M3
           END-EVALUATE                                                 FH02P0M3
           .                                                            FH02P0M3
       9951-EXIT.                                                       FH02P0M3
           EXIT.                                                        FH02P0M3
           .                                                            FH02P0M3
      *%%% PE TT 34821 END                                              FH02P0M3
       9960-DO-H3-SUPP-HIST.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            PRODUCE H3 SUPPORTING HISTORY
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *
      *-----------------------------------------------------------------
      *  CALL FX61 EP 8 FIRST WITH A  'DUMMY' CALL. THIS WILL INSURE
      *  THAT THE HOLD PARMS IN FX61 WILL NOT BE EQUAL TO THE PASSED
      *  PARMS ON THE SUBSEQUENT 'REAL' CALL.
      *  THIS CAUSES FX61 TO DO A SETL WHEN WE CALL FOR REAL TO
      *  ESTABLISH POINTER AND READ F00400.  OTHERWISE, AN ABEND CAN
      *  RESULT.
      *-----------------------------------------------------------------
      *
      *%%% KX CMR 387791 BEGIN
      **   MOVE 'L' TO TYPE-FUNCTION
      *
      **   MOVE  ID-NUMBER-TWR TO HOLD-P0M3-ID-NUMBER
      *-----------------------------------------------------------------
      *    WHEN WE CALL TO FORCE FX61 EP 8'S PARMS TO CHANGE, WE
      *    CAN NOT SIMPLY CALL WITH AN ID OF 0'S.  THAT'S BECAUSE, IN
      *    SPLIT PROCESSING, TERMINAL DIGITS OF 0'S WILL CAUSE A SEARCH
      *    ON F00400.  IF YOU ARE IN ANY SPLIT BUT 1 OR 11, YOU WILL
      *    ABEND BECAUSE F00400 WILL NOT HAVE BEEN OPENED.
      *    THEREFORE, WE GET AROUND THAT PROBLEM BY ADDING 100 TO THE
      *    ID.  THAT CHANGES THE PARMS IN FX61 BUT DOES NOT AFFECT
      *    THE TERMINAL DIGIT OF THE ID THUS PREVENTING AN ABEND.
      *-----------------------------------------------------------------
      **   ADD 100 TO HOLD-P0M3-ID-NUMBER
      *
      **   MOVE  HOLD-P0M3-ID-NUMBER TO FX61-ID-NUMBER
      **   MOVE  'A'                 TO FX61-PATIENT-CODE
      **   MOVE  ZEROES              TO FX61-PLAN-CODE-R
      **   MOVE  ZEROES              TO FX61-CLAIM-NUMBER
      *%%% EL CMR# 387791 - BEGIN
           MOVE '20'                 TO FX61-PROCESS-CC
           MOVE FX-PROCESS-YEAR      TO FX61-PROCESS-YY
      *%%% EL CMR# 387791 - END

      *
      **   PERFORM 9966-CALL-FX61-RANDOM THRU 9966-EXIT
      *
           SET RANDOM-RETRIEVAL      TO TRUE.
           SET FX61-BEGIN-DATE-ZERO  TO TRUE.
      *%%% KX CMR# 387791 - END
      *
           PERFORM 9964-SEARCH-TABLE THRU 9964-EXIT
              VARYING SUB1 FROM 1 BY 1
              UNTIL SUB1 > 5
           .
       9960-EXIT.
           EXIT.
      *
       9964-SEARCH-TABLE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *     SEARCH TABLE AND WRITE H3 FOR THE GIVEN ERROR REASON
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           IF  EDIT-REASON-CODE (SUB1) = ERROR-REASON
           OR  (ERROR-REASON = 'FKR'
                AND EDIT-REASON-CODE (SUB1) = 'FKP')
      *
               PERFORM VARYING SUB2 FROM 1 BY 1
                 UNTIL SUB2 > EDIT-HIST-NUMBER (SUB1)
                    PERFORM 9966-SET-UP-FX61-RANDOM THRU 9966-EXIT
      *
                    MOVE LINE-NUMBER-TWR (TWR-CRG-SUB)
                      TO TWR-LINE-NUMBER
                    MOVE EDIT-HIST-CHG-LINE-NUMBER (SUB1, SUB2)
                      TO CHG-SUB
                    MOVE 50 TO CHARGE-STATUS
      *
                    MOVE ERROR-REASON TO REASON
      *
                    SET FH02P0MH-MODULE       TO TRUE
                    CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                               DUMMY-COMMAREA
                                               APPL-RETURN-AREA
                                               CLAIM-WORK-RECORD
                                               CHG-SUB
                                               TRANSACTION-WORK-RECORD
                                               TWR-LINE-NUMBER
                                               CHARGE-STATUS
                                               REASON
                                               HOLD-TWR-CHARGE-LINE
                         ON EXCEPTION
                            MOVE 9964                 TO WS-V-ERROR-PARA
                            SET FEP-MAF-CICS-SOFTWARE TO TRUE
                            SET CALL-PGM              TO TRUE
                            PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
                    END-CALL
      *
                    MOVE SPACES TO REASON
                    MOVE 0 TO CHG-SUB TWR-LINE-NUMBER
               END-PERFORM
           END-IF
           .
       9964-EXIT.
           EXIT.

       9966-SET-UP-FX61-RANDOM.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *          SET UP THE KEY TO DO A RANDOM READ OF HISTORY
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
           IF  ERROR-REASON = 'FKR'
           AND EDIT-HIST-FKR-OFF(SUB1, SUB2)
               GO TO 9966-EXIT
           END-IF

           MOVE  EDIT-HIST-ID-NUMBER (SUB1, SUB2)
             TO  FX61-ID-NUMBER
           MOVE  EDIT-HIST-PATIENT-CODE (SUB1, SUB2)
             TO  FX61-PATIENT-CODE
           MOVE  EDIT-HIST-PLAN-CODE    (SUB1, SUB2)
             TO  FX61-PLAN-CODE-R
           MOVE  EDIT-HIST-CLAIM-NUMBER (SUB1, SUB2)
             TO  FX61-CLAIM-NUMBER
           .
       9966-CALL-FX61-RANDOM.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            READ HISTORY USING KEY INFORMATION
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

      *%%% EL CMR# 387791 - BEGIN
      *%%% CWR CONTAINERS BEGIN
           MOVE 'FH02-CWR-CHANNEL' TO CWR-CHANNEL-NAME
           MOVE 'FH02-CWR-CONTNR' TO CWR-CONTAINER-NAME
      *    MOVE 'FH11P7M1' TO WS-S-CALL2-MODULE
      *%%% CWR CONTAINERS END
           SET FX60P0M1-MODULE       TO TRUE

           CALL WS-S-CALL2-MODULE   USING  DFHEIBLK
                                      DUMMY-COMMAREA
                                      FX61-RESULT-CODE
                                      TYPE-FUNCTION
                                      FX61-CLM-RETRIEVAL-DATA
                                      CWR-CONTAINER-DATA
                                      FX61-PROCESS-YEAR
                                      TWR-BEGIN-AND-END-DATES
      *%%% EL CMR# 387791 - END
                ON EXCEPTION
                   MOVE 9966                 TO WS-V-ERROR-PARA
                   SET FEP-MAF-CICS-SOFTWARE TO TRUE
                   SET CALL-PGM              TO TRUE
                   PERFORM 9880-ERROR-RTN    THRU 9880-EXIT
           END-CALL
           .
      *
      *%%% KX CMR 387791 - BEGIN

           IF  VALID-RESULT-CODE
               SET ADDRESS OF CLAIM-WORK-RECORD
                           TO CWR-CONTAINER-PTR
           ELSE
               SET   PROG-MSG                    TO  TRUE
               SET   FEP-MAF-EXCPT-WARNING       TO TRUE
               SET   FEP-MAF-OTHER-SOFTWARE      TO TRUE
               MOVE  2000              TO FEP-MAF-EXCPT-MSG-ID-SUFFIX
               MOVE  SPACES            TO WS-V-ERR-MESSAGE-TEXT
      *
               EVALUATE TRUE
                   WHEN INVALID-PARM
                        MOVE INVALID-PARM-MESSAGE
                          TO WS-V-ERR-MESSAGE-TEXT
                   WHEN OTHER
                        MOVE FX61-RESULT-CODE
                          TO DATA-LAYER-RC
                        MOVE TYPE-FUNCTION
                          TO DATA-LAYER-FC
                        MOVE INVALID-RC-MESSAGE
                          TO WS-V-ERR-MESSAGE-TEXT
               END-EVALUATE
      *
               PERFORM 9880-ERROR-RTN
                  THRU 9880-EXIT
           END-IF.
      *%%% KX CMR 387791 - END
      *
       9966-EXIT.
           EXIT.

      *%%% EL TT# 915663 - BEGIN
       9970-CLAIM-ERROR-ROUTINE.
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *            PROCESS ERRORS
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

           IF  ERROR-REASON NOT = SPACES

               MOVE ERROR-REASON TO CLM-RESPONSE-REASON-1-TWR

               EVALUATE TRUE
                 WHEN CANNOT-PROCESS-THIS-CHARGE
                   MOVE NOT-PROCESS-STATUS TO CLAIM-STATUS-TWR
                   MOVE ERROR-REASON TO CLM-RESPONSE-REASON-2-TWR
                   PERFORM VARYING SUB1 FROM 1 BY 1
                     UNTIL SUB1 > NUMBER-OF-CHARGES-TWR
                      MOVE '65' TO CHARGE-STATUS-TWR (SUB1)
                   END-PERFORM
                 WHEN DEFER-THIS-CHARGE
                   MOVE '50' TO CLAIM-STATUS-TWR
                   PERFORM VARYING SUB1 FROM 1 BY 1
                     UNTIL SUB1 > NUMBER-OF-CHARGES-TWR
                      MOVE '50' TO CHARGE-STATUS-TWR (SUB1)
                   END-PERFORM
                 WHEN REJECT-THIS-CHARGE
                   MOVE '30' TO CLAIM-STATUS-TWR
                   PERFORM VARYING SUB1 FROM 1 BY 1
                     UNTIL SUB1 > NUMBER-OF-CHARGES-TWR
                      MOVE '30' TO CHARGE-STATUS-TWR (SUB1)
                   END-PERFORM
               END-EVALUATE

           END-IF
                                                                        FH02P0M3
           .
       9970-EXIT.
           EXIT.
      *%%% EL TT# 915663 - END

      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      *    CALL FV11P9M9 TO LOG ERROR MESSAGES
      *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
       9880-ERROR-RTN.

           MOVE CONTRACT-ID-NUMBER-TWR
             TO WS-V-CONTRACT-ID

           MOVE REPORTING-PLAN-CODE-TWR
             TO WS-V-PLAN-CODE

           MOVE CLAIM-NUMBER-TWR
             TO WS-V-CLAIM-NUM

           MOVE LINE-NUMBER-AN-TWR (TWR-CRG-SUB)
             TO WS-V-CHG-LINE-NUM

           COPY FH02CC02.

       9880-EXIT.  EXIT.

            COPY FV11CC00.


