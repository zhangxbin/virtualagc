### FILE="Main.annotation"
## Copyright:   Public domain.
## Filename:    P34-P35,_P74-P75.agc
## Purpose:     A section of Luminary revision 163.
##              It is part of the reconstructed source code for the first
##              (unflown) release of the flight software for the Lunar
##              Module's (LM) Apollo Guidance Computer (AGC) for Apollo 14.
##              The code has been recreated from a reconstructed copy of
##              Luminary 173, as well as Luminary memos 157 amd 158.
##              It has been adapted such that the resulting bugger words
##              exactly match those specified for Luminary 163 in NASA
##              drawing 2021152N, which gives relatively high confidence
##              that the reconstruction is correct.
## Reference:   pp. 653-697
## Assembler:   yaYUL
## Contact:     Ron Burkey <info@sandroid.org>.
## Website:     www.ibiblio.org/apollo/index.html
## Warning:     THIS PROGRAM IS STILL UNDERGOING RECONSTRUCTION
##              AND DOES NOT YET REFLECT THE ORIGINAL CONTENTS OF
##              LUMINARY 163.
## Mod history: 2019-08-21 MAS  Created from Luminary 173. Removed zeroing of
##                              ELEV from P34/P74A.

## Page 653
# TRANSFER PHASE INITIATION (TPI) PROGRAMS (P34 AND P74)

# MOD NO -1       LOG SECTION - P32-P35, P72-P75
# MOD BY WHITE.P  DATE 1JUNE67

# PURPOSE

#       (1) TO CALCULATE THE REQUIRED DELTA V AND OTHER INITIAL CONDITIONS
#           REQUIRED BY THE ACTIVE VEHICLE FOR EXECUTION OF THE TRANSFER
#           PHASE INITIATION (TPI) MANEUVER, GIVEN -

#           (A) TIME OF IGNITION TIG (TPI) OR THE ELEVATION ANGLE (E) OF
#               THE ACTIVE/PASSIVE VEHICLE LOS AT TIG (TPI).

#           (B) CENTRAL ANGLE OF TRANSFER (CENTANG) FROM TIG (TPI) TO
#               INTERCEPT TIME (TIG (TPF)).

#       (2) TO CALCULATE TIG (TPI) GIVEN E OR E GIVEN TIG (TPI).

#       (3) TO CALCULATE THESE PARAMETERS BASED UPON MANEUVER DATA
#           APPROVED AND KEYED INTO THE DSKY BY THE ASTRONAUT.

#       (4) TO DISPLAY TO THE ASTRONAUT AND THE GROUND CERTAIN DEPENDENT
#           VARIABLES ASSOCIATED WITH THE MANEUVER FOR APPROVAL BY THE
#           ASTRONAUT/GROUND.

#       (5) TO STORE THE TPI TARGET PARAMETERS FOR USE BY THE DESIRED
#           THRUSTING PROGRAM.

# ASSUMPTIONS

#       (1) LM ONLY - THIS PROGRAM IS BASED UPON PREVIOUS COMPLETION OF
#           THE CONSTANT DELTA ALTITUDE (CDH) PROGRAM (P33/P73).
#           THEREFORE -

#           (A) AT A SELECTED TPI TIME (NOW IN STORAGE) THE LINE OF SIGHT
#               BETWEEN THE ACTIVE AND PASSIVE VEHICLES WAS SELECTED TO BE
#               A PRESCRIBED ANGLE (E) (NOW IN STORAGE) FROM THE
#               HORIZONTAL PLANE DEFINED BY THE ACTIVE VEHICLE POSITION.

#           (B) THE TIME BETWEEN CDH IGNITION AND TPI IGNITION WAS
#               COMPUTED TO BE GREATER THAN 10 MINUTES.

#           (C) THE VARIATION OF THE ALTITUDE DIFFERENCE BETWEEN THE
#               ORBITS WAS MINIMIZED.

#           (D) THE PERICENTER ALTITUDES OF ORBITS FOLLOWING CSI AND

#               CDH WERE COMPUTED TO BE GREATER THAN 35,000 FT FOR LUNAR
## Page 654
#               ORBIT OR 85 NM FOR EARTH ORBIT.

#           (E) THE CSI AND CDH MANEUVERS WERE ASSUMED TO BE PARALLEL TO
#               THE PLANE OF THE PASSIVE VEHICLE ORBIT.  HOWEVER, CREW
#               MODIFICATION OF DELTA V (LV) COMPONENTS MAY HAVE RESULTED
#               IN AN OUT-OF-PLANE MANEUVER.

#       (2) STATE VECTOR UPDATED BY P27 ARE DISALLOWED DURING AUTOMATIC
#           STATE VECTOR UPDATING INITIATED BY P20 (SEE ASSUMPTION (4)).

#       (3) THIS PROGRAM MUST BE DONE OVER A TRACKING STATION FOR REAL
#           TIME GROUND PARTICIPATION IN DATA INPUT AND OUTPUT.  COMPUTED
#           VARIABLES MAY BE STORED FOR LATER VERIFICATION BY THE GROUND.
#           THESE STORAGE CAPABILITIES ARE LIMITED ONLY TO THE PARAMETERS
#           FOR ONE THRUSTING MANEUVER AT A TIME EXCEPT FOR CONCENTRIC
#           FLIGHT PLAN MANEUVER SEQUENCES.

#       (4) THE RENDEZVOUS RADAR MAY OR MAY NOT BE USED TO UPDATE THE LM
#           OR CSM STATE VECTORS FOR THIS PROGRAM.  IF RADAR USE IS
#           DESIRED THE RADAR WAS TURNED ON AND LOCKED ON THE CSM BY
#           PREVIOUS SELECTION OF P20.  RADAR SIGHTING MARKS WILL BE MADE
#           AUTOMATICALLY APPROXIMATELY ONCE A MINUTE WHEN ENABLED BY THE
#           TRACK AND UPDATE FLAGS (SEE P20).  THE RENDEZVOUS TRACKING
#           MARK COUNTER IS ZEROED BY THE SELECTION OF P20 AND AFTER EACH
#           THRUSTING MANEUVER.

#       (5) THE ISS NEED NOT BE ON TO COMPLETE THIS PROGRAM.

#       (6) THE OPERATION OF THE PROGRAM UTILIZES THE FOLLOWING FLAGS -

#               ACTIVE VEHICLE FLAG - DESIGNATES THE VEHICLE WHICH IS
#               DOING RENDEZVOUS THRUSTING MANEUVERS TO THE PROGRAM WHICH
#               CALCULATES THE MANEUVER PARAMETERS.  SET AT THE START OF
#               EACH RENDEZVOUS PRE-THRUSTING PROGRAM.

#               FINAL FLAG - SELECTS FINAL PROGRAM DISPLAYS AFTER CREW HAS
#               SELECTED THE FINAL MANEUVER COMPUTATION CYCLE.

#               EXTERNAL DELTA V FLAG - DESIGNATES THE TYPE OF STEERING
#               REQUIRED FOR EXECUTION OF THIS MANEUVER BY THE THRUSTING
#               PROGRAM SELECTED AFTER COMPLETION OF THIS PROGRAM.

#       (7) ONCE THE PARAMETWRS REQUIRED FOR COMPUTION OF THE MANEUVER
#           HAVE BEEN COMPLETELY SPECIFIED, THE VALUE OF THE ACTIVE
#           VEHICLE CENTRAL ANGLE OF TRANSFER IS COMPUTED AND STORED.
#           THIS NUMBER WILL BE AVAILABLE FOR DISPLAY TO THE ASTRONAUT
#           THROUGH THE USE OF V06N52.
#
#           THE ASTRONAUT WILL CALL THIS DISPLAY TO VERIFY THAT THE
#           CENTRAL ANGLE OF TRANSFER OF THE ACTIVE VEHICLE IS NOT WITHIN
## Page 655
#           170 TO 190 DEGREES.  IF THE ANGLE IS WITHIN THIS ZONE THE
#           ASTRONAUT SHOULD REASSESS THE INPUT TARGETING PARAMETERS BASED
#           UPON DELTA V AND EXPECTED MANEUVER TIME.

#       (8) THIS PROGRAM IS SELECTED BY THE ASTRONAUT BY DSKY ENTRY -

#               P34 IF THIS VEHICLE IS ACTIVE VEHICLE.

#               P74 IF THIS VEHICLE IS PASSIVE VEHICLE.

# INPUT

#       (1) TTPI     TIME OF THE TPI MANEUVER
#       (2) ELEV     DESIRED LOS ANGLE AT TPI
#       (3) CENTANG  ORBITAL CENTRAL ANGLE OF THE PASSIVE VEHICLE DURING
#                    TRANSFER FROM TPI TO TIME OF INTERCEPT

# OUTPUT

#       (1) TRKMKCNT NUMBER OF MARKS
#       (2) TTOGO    TIME TO GO
#       (3) +MGA     MIDDLE GIMBAL ANGLE
#       (4) TTPI     COMPUTED TIME OF TPI MANEUVER
#            OR
#           ELEV     COMPUTED LOS ANGLE AT TPI
#       (5) POSTTPI  PERIGEE ALTITUDE AFTER THE TPI MANEUVER
#       (6) DELVTPI  MAGNITUDE OF DELTA V AT TPI
#       (7) DELVTPF  MAGNITUDE OF DELTA V AT INTERCEPT
#       (8) DVLOS    DELTA VELOCITY AT TPI - LINE OF SIGHT
#       (9) DELVLVC  DELTA VELOCITY AT TPI - LOCAL VERTICAL COORDINATES

# DOWNLINK

#       (1) TTPI     TIME OF THE TPI MANEUVER
#       (2) TIG      TIME OF THE TPI MANEUVER
#       (3) ELEV     DESIRED LOS ANGLE AT TPI
#       (4) CENTANG  ORBITAL CENTRAL ANGLE OF THE PASSIVE VEHICLE DURING
#                    TRANSFER FROM TPI TO TIME OF INTERCEPT
#       (5) DELVEET3 DELTA VELOCITY AT TPI - REFERENCE COORDINATES
#       (6) TPASS4   TIME OF INTERCEPT
# COMMUNICATION TO THRUSTING PROGRAMS

#       (1) TIG      TIME OF THE TPI MANEUVER
#       (2) RTARG    OFFSET TARGET POSITION
#       (3) TPASS4   TIME OF INTERCEPT
#       (4) XDELVFLG RESET TO INDICATE LAMBERT (AIMPOINT) VG COMPUTATION

# SUBROUTINES USED

#       AVFLAGA
## Page 656
#       AVFLAGP
#       VNPOOH
#       DISPLAYE
#       SELECTMU
#       PRECSET
#       S33/34.1
#       ALARM
#       BANKCALL
#       GOFLASH
#       GOTOPOOH
#       TIMETHET
#       S34/35.2
#       PERIAPO1
#       SHIFTR1
#       S34/35.5
#       VN1645

                SETLOC          CSI/CDH
                BANK
                EBANK=          SUBEXIT
                COUNT*          $$/P3474
P34             TC              AVFLAGA
                TC              P34/P74A
P74             TC              AVFLAGP
P34/P74A        TC              P20FLGON                # SET UPDATFLG, TRACKFLG
                CAF             V06N37                  # TTPI
                TC              VNPOOH
                EXTEND
                DCA             130DEG
                DXCH            CENTANG
                CAF             P30ZERO
                TS              NN
                TC              DISPLAYE                # ELEV AND CENTANG
                TC              INTPRET
                CLEAR           DLOAD
                                ETPIFLAG
                                TTPI
                STODL           TIG
                                ELEV
                BZE             SET
                                P34/P74B
                                ETPIFLAG

## Page 657
P34/P74B        CALL
                                SELECTMU
DELELO          EQUALS          26D
P34/P74C        DLOAD           SET
                                ZEROVECS
                                ITSWICH
                BON             CLEAR
                                ETPIFLAG
                                SWCHSET
                                ITSWICH
SWCHSET         STORE           NOMTPI
INTLOOP         DLOAD           DAD
                                TTPI
                                NOMTPI
                STCALL          TDEC1
                                PRECSET
                CALL
                                S33/34.1
                BZE             EXIT
                                SWCHCLR
                TC              ALARM
                OCT             611
                CAF             V05N09
                TC              BANKCALL
                CADR            GOFLASH
                TC              GOTOPOOH
                TC              P34/P74A                # PROCEED
                TC              -7                      # V32

SWCHCLR         BONCLR          BON
                                ITSWICH
                                INTLOOP
                                ETPIFLAG
                                P34/P74D                # DISPLAY TTPI
                EXIT
                TC              DISPLAYE                # DISPLAY ELEV AND CENTANG
                TC              P34/P74E
P34/P74D        EXIT
                CAF             V06N37                  # TTPI
                TC              VNPOOH
P34/P74E        TC              INTPRET
                SETPD           DLOAD
                                0D
                                RTX1
                STODL           X1
                                CENTANG
                PUSH            COS
                STODL           CSTH
                SIN
                STOVL           SNTH
## Page 658
                                RPASS3
                VSR*
                                0,2
                STOVL           RVEC
                                VPASS3
                VSR*            SET
                                0,2
                                RVSW
                STCALL          VVEC
                                TIMETHET
                DLOAD
                                TTPI
                STORE           INTIME                  # FOR INITVEL
                DAD
                                T                       # RENDEZVOUS TIME
                STCALL          TPASS4                  # FOR INITVEL
                                S34/35.2
                VLOAD           ABVAL
                                DELVEET3
                STOVL           DELVTPI
                                VPASS4
                VSU             ABVAL
                                VTPRIME
                STOVL           DELVTPF
                                RACT3
                PDVL            CALL
                                VIPRIME
                                PERIAPO1
                CALL
                                SHIFTR1
                STODL           POSTTPI
                                TTPI
                STORE           TIG
                EXIT
                CAF             V06N58
                TC              VNPOOH
                TC              INTPRET
                CALL
                                S34/35.5
                CALL
                                VN1645
                GOTO
                                P34/P74C

## Page 659
# RENDEZVOUS MID-COURSE MANEUVER PROGRAMS (P35 AND P75)

# MOD NO -1       LOG SECTION - P32-P35, P72-P75
# MOD BY WHITE.P  DATE  1JUNE67

# PURPOSE

#       (1) TO CALCULATE THE REQUIRED DELTA V AND OTHER INITIAL CONDITIONS
#           REQUIRED BY THE ACTIVE VEHICLE FOR EXECUTION OF THE NEXT
#           MIDCOURSE CORRECTION OF THE TRANSFER PHASE OF AN ACTIVE
#           VEHICLE RENDEZVOUS.

#       (2) TO DISPLAY TO THE ASTRONAUT AND THE GROUND CERTAIN DEPENDENT
#           VARIABLES ASSOCIATED WITH THE MANEUVER FOR APPROVAL BY THE
#           ASTRONAUT/GROUND.

#       (3) TO STORE THE TPM TARGET PARAMETERS FOR USE BY THE DESIRED
#           THRUSTING PROGRAM.

# ASSUMPTIONS

#       (1) THE ISS NEED NOT BE ON TO COMPLETE THIS PROGRAM.

#       (2) STATE VECTOR UPDATES BY P27 ARE DISALLOWED DURING AUTOMATIC
#           STATE VECTOR UPDATING INITIATED BY P20 (SEE ASSUMPTION (3)).

#       (3) THE RENDEZVOUS RADAR IS ON AND IS LOCKED ON THE CSM.  THIS WAS
#           DONE DURING PREVIOUS SELECTION OF P20.  RADAR SIGHTING MARKS
#           WILL BE MADE AUTOMATICALLY APPROXIMATELY ONCE A MINUTE WHEN
#           ENABLED BY THE TRACK AND UPDATE FLAGS (SEE P20). THE
#           RENDEZVOUS TRACKING MARK COUNTER IS ZEROED BY THE SELECTION OF
#           P20 AND AFTER EACH THRUSTING MANEUVER.

#       (4) THE OPERATION OF THE PROGRAM UTILIZES THE FOLLOWING FLAGS -

#               ACTIVE VEHICLE FLAG - DESIGNATES THE VEHICLE WHICH IS
#               DOING RENDEZVOUS THRUSTING MANEUVERS TO THE PROGRAM WHICH
#               CALCULATES THE MANEUVER PARAMETERS.  SET AT THE START OF
#               EACH RENDEZVOUS PRE-THRUSTING PROGRAM.

#               FINAL FLAG - SELECTS FINAL PROGRAM DISPLAYS AFTER CREW HAS
#               SELECTED THE FINAL MANEUVER COMPUTATION CYCLE.

#               EXTERNAL DELTA V FLAG - DESIGNATES THE TYPE OF STEERING
#               REQUIRED FOR EXECUTION OF THIS MANEUVER BY THE THRUSTING
#               PROGRAM SELECTED AFTER COMPLETION OF THIS PROGRAM.

#       (5) THE TIME OF INTERCEPT (T(INT)) WAS DEFINED BY PREVIOUS
#           COMPLETION OF THE TRANSFER PHASE INITIATION (TPI) PROGRAM
#           (P34/P74) AND IS PRESENTLY AVAILABLE IN STORAGE.

## Page 660
#       (6) ONCE THE PARAMETERS REQUIRED FOR COMPUTION OF THE MANEUVER
#           HAVE BEEN COMPLETELY SPECIFIED, THE VALUE OF THE ACTIVE
#           VEHICLE CENTRAL ANGLE OF TRANSFER IS COMPUTED AND STORED.
#           THIS NUMBER WILL BE AVAILABLE FOR DISPLAY TO THE ASTRONAUT
#           THROUGH THE USE OF V06N52.

#           THE ASTRONAUT WILL CALL THIS DISPLAY TO VERIFY THAT THE
#           CENTRAL ANGLE OF TRANSFER OF THE ACTIVE VEHICLE IS NOT WITHIN
#           170 TO 190 DEGREES.  IF THE ANGLE IS WITHIN THIS ZONE THE
#           ASTRONAUT SHOULD REASSESS THE INPUT TARGETING PARAMETERS BASED
#           UPON DELTA V AND EXPECTED MANEUVER TIME.

#       (7) THIS PROGRAM IS SELECTED BY THE ASTRONAUT BY DSKY ENTRY -

#               P35 IF THIS VEHICLE IS ACTIVE VEHICLE.

#               P75 IF THIS VEHICLE IS PASSIVE VEHICLE.

# INPUT

#       (1) TPASS4   TIME OF INTERCEPT - SAVED FROM P34/P74
# OUTPUT

#       (1) TRKMKCNT NUMBER OF MARKS
#       (2) TTOGO    TIME TO GO
#       (3) +MGA     MIDDLE GIMBAL ANGLE
#       (4) DVLOS    DELTA VELOCITY AT MID - LINE OF SIGHT
#       (5) DELVLVC  DELTA VELOCITY AT MID - LOCAL VERTICAL COORDINATES

# DOWNLINK

#       (1) TIG      TIME OF THE TPM MANEUVER
#       (2) DELVEET3 DELTA VELOCITY AT TPM - REFERENCE COORDINATES
#       (3) TPASS4   TIME OF INTERCEPT
# COMMUNICATION TO THRUSTING PROGRAMS

#       (1) TIG      TIME OF THE TPM MANEUVER
#       (2) RTARG    OFFSET TARGET POSITION
#       (3) TPASS4   TIME OF INTERCEPT
#       (4) XDELVFLG RESET TO INDICATE LAMBERT (AIMPOINT) VG COMPUTATION

# SUBROUTINES USED

#       AVFLAGA
#       AVFLAGP
#       LOADTIME
#       SELECTMU
#       PRECSET
#       S34/35.1
#       S34/35.2
## Page 661
#       S34/35.5
#       VN1645

                COUNT*          $$/P3575
                EBANK=          KT

P35             TC              AVFLAGA
                EXTEND
                DCA             ATIGINC
                TC              P35/P75A
P75             TC              AVFLAGP
                EXTEND
                DCA             PTIGINC
P35/P75A        DXCH            KT
                TC              P20FLGON                # SET UPDATFLG, TRACKFLG
                TC              INTPRET
                CALL
                                SELECTMU
P35/P75B        RTB
                                LOADTIME
                STORE           TSTRT
                DAD
                                KT
                STORE           TIG
                STORE           INTIME                  # FOR INITVEL
                STCALL          TDEC1
                                PRECSET                 # ADVANCE BOTH VEHICLES
                CALL
                                S34/35.1                # GET NORM AND LOS FOR TRANSFORM
                CALL
                                S34/35.2                # GET DELTA V(LV)
                CALL
                                S34/35.5
                CALL
                                VN1645
                GOTO
                                P35/P75B

## Page 662
# ..... S33/34.1  .....

S33/34.1        STQ             SSP
                                NORMEX
                                TITER
                OCT             40000
                DLOAD           SETPD
                                MAX250
                                0D
                STOVL           SECMAX
                                RACT3
                STOVL           RAPREC
                                VACT3
                STOVL           VAPREC
                                RPASS3
                STOVL           RPPREC
                                VPASS3
                STORE           VPPREC
ELCALC          CALL
                                S34/35.1                # NORMAL AND LOS
                VXV             PDVL
                                RACT3                   # (RA*VA)*RA 0D
                PDVL            UNIT                    # ULOS AT 6D
                                RACT3
                PDVL            VPROJ                   # XCHNJ AND UP
                VSL2            BVSU
                                ULOS
                UNIT            PDVL                    # UP AT 0D
                DOT             PDVL                    # UP.UN*RA AT 0D
                                0D                      # UP IN MPAC
                DOT             SIGN
                                ULOS
                SL1             ACOS
                PDVL            DOT                     # EA AT 0D
                                ULOS
                                RACT3
                BPL             DLOAD
                                TESTY
                                DPPOSMAX
                DSU             PUSH
TESTY           BOFF            DLOAD
                                ITSWICH
                                ELEX
                                DELEL
                STODL           DELELO
                DSU
                                ELEV
                STORE           DELEL
                ABS             DSU
                                ELEPS
## Page 663
                BMN
                                TIMEX                   # COMMERCIALS EVERYWHERE
FIGTIME         SLOAD           SR1
                                TITER
                BHIZ            LXA,1
                                NORMEX                  # TOO MANY ITERATIONS
                                MPAC
                SXA,1           VLOAD
                                TITER
                                RPASS3
                UNIT            PDDL
                                36D
                PDVL            UNIT
                                RACT3
                PDDL
                PDDL            PUSH
                                36D
                BDSU
                                12D
                STODL           30D                     # RP - RA MAGNITUDES
                                DPHALF
                DSU             PUSH
                                ELEV
                SIGN            BMN
                                30D
                                NORMEX
                DLOAD           COS
                DMP             DDV
                                14D
                                12D
                DCOMP                                   # SINCE COS(180-A)=-COS A
                STORE           28D
                ABS             BDSU
                                DPHALF
                BMN             VLOAD
                                NORMEX
                                UNRM
                VXV             UNIT
                                6D                      # UN*RA
                DOT             DMP
                                VACT3
                                12D
                PDVL            VXV
                                0D
                                VPASS3
                VXV             UNIT
                                0D                      # (RP*VP)*RP
                DOT             DMP
                                VPASS3
                                14D
## Page 664
                BDSU
                NORM            PDVL                    # NORMALIZED WA - WP 12D
                                X1
                                6D
                VXV             DOT
                                0D
                                UNRM                    # RA*RP.UN 14D
                PDVL            DOT
                                0D
                                6D
                SL1             ACOS
                SIGN
                DSU             DAD                     #   ALPHA   PI
                                DPHALF
                                ELEV
                PDDL            ACOS
                                28D
                BDSU            SIGN
                                DPHALF
                                30D                     # CONTAINS RP-RA
                DAD
                DMP             DDV
                                TWOPI
                DMP
                SL*             DMP
                                0 -3,1
                PUSH            ABS
                DSU             BMN
                                SECMAX
                                OKMAX
                DLOAD           SIGN                    #  REPLACE TIME WITH MAX TIME SIGNED
                                SECMAX
                PUSH
OKMAX           SLOAD           BPL                     # TEST FIRST ITERATION
                                TITER
                                REPETE
                SSP             DLOAD
                                TITER
                OCT             37777
                GOTO
                                STORDELT
REPETE          DLOAD           DMP
                                DELEL
                                DELELO
                BPL             DLOAD
                                NEXTES
                                SECMAX
                DMP
                                THIRD
                STODL           SECMAX
## Page 665
                ABS             SR1                     # CROSSED OVER SOLUTION
                DCOMP           GOTO                    # DT=(-SIGN(DTO)//DT//)/2
                                RESIGN
NEXTES          DLOAD           ABS
                                DELEL
                PDDL            ABS
                                DELELO
                DSU
                BMN             DLOAD
                                REVERS                  # WRONG DIRECTION
                ABS
RESIGN          SIGN            GOTO
                                DELTEEO
                                STORDELT
REVERS          DLOAD           DCOMP
                                DELTEEO
                PUSH            SR1
                STORE           DELTEEO
                DAD
                GOTO
                                ADTIME
STORDELT        STORE           DELTEEO
ADTIME          DAD
                                NOMTPI                  # SUM OF DELTA T:S
                STORE           NOMTPI
                VLOAD           PDVL
                                VAPREC
                                RAPREC
                CALL
                                GOINT
                CALL
                                ACTIVE                  # STORE NEW RACT3 VACT3
                VLOAD           PDVL
                                VPPREC
                                RPPREC
                CALL
                                GOINT
                CALL
                                PASSIVE                 # STORE NEW RPASS3 VPASS3
                GOTO
                                ELCALC
ELEX            DLOAD           DAD
                                TTPI
                                NOMTPI
                STODL           TTPI
                BON
                                ETPIFLAG
                                TIMEX
                STORE           ELEV
TIMEX           DLOAD           GOTO
## Page 666
                                ZEROVECS
                                NORMEX

## Page 667
# ..... S34/35.1  .....

# COMPUTE UNIT NORMAL AND LINE OF SIGHT VECTORS GIVEN THE ACTIVE AND
# PASSIVE POS AND VEL AT TIME T3
S34/35.1        VLOAD           VSU
                                RPASS3
                                RACT3
                UNIT            PUSH
                STOVL           ULOS
                                RACT3
                VXV             UNIT
                                VACT3
                STORE           UNRM
                RVQ

## Page 668
# ..... S34/35.2  .....

# ADVANCE PASSIVE VEH TO RENDEZVOUS TIME AND GET REQ VEL FROM LAMBERT
S34/35.2        STQ             VLOAD
                                SUBEXIT
                                VPASS3
                PDVL            PDDL
                                RPASS3
                                INTIME
                PDDL            PDDL
                                TPASS4
                                TWOPI                   # CONIC
                PDDL            BHIZ
                                NN
                                S3435.23
                DLOAD
                DLOAD           PUSH
                                ZEROVECS                # PRECISION
S3435.23        CALL
                                INTINT                  # GET TARGET VECTOR
S3435.25        STOVL           RTARG
                                VATT
                STOVL           VPASS4
                                RTARG
# COMPUTE PHI = PI + (ACOS(UNIT RA.UNIT RP)-PI)SIGN(RA*RP.U)
                UNIT            PDVL                    # UNIT RP
                                RACT3
                UNIT            PUSH                    # UNIT RA
                VXV             DOT
                                0D
                                UNRM                    # RA*RP.U
                PDVL
                DOT             SL1                     # UNIT RA.UNIT RP
                                0D
                ACOS            SIGN
                BPL             DAD
                                NOPIE
                                DPPOSMAX                # REASONABLE TWO PI
NOPIE           STODL           ACTCENT
                                TPASS4
                DSU
                                INTIME
                STORE           DELLT4
                SLOAD           SETPD
                                NN                      # NUMBER OF OFFSETS
                                0D
                PDDL            PDVL
                                EPSFOUR
                                RACT3
                STOVL           RINIT
## Page 669
                                VACT3
                STCALL          VINIT
                                INITVEL
                CALL
                                LOMAT
                VLOAD           MXV
                                DELVEET3
                                0D
                VSL1
                STCALL          DELVLVC
                                SUBEXIT

## Page 670
# ..... S34/35.3  .....

S34/35.3        STQ             CALL
                                NORMEX
                                LOMAT                   # GET MATRIX IN PUSH LIST
                VLOAD           VXM
                                DELVLVC                 # NEW DEL V TPI
                                0D
                VSL1
                STORE           DELVEET3                # SAVE FOR TRANSFORM
                VAD             PDVL
                                VACT3                   # NEW V REQ
                                RACT3
                PDDL            PDDL
                                TIG
                                TPASS4
                PDDL            PUSH
                                DPPOSMAX
                CALL                                    # INTEG. FOR NEW TARGET VEC
                                INTINT
                VLOAD
                                RATT
                STORE           RTARG
NOVRWRT         VLOAD           PUSH
                                ULOS
                VXV             VCOMP
                                UNRM
                UNIT            PUSH
                VXV             VSL1
                                ULOS
                PDVL
                PDVL            MXV
                                DELVEET3
                                0D
                VSL1
                STCALL          DVLOS
                                NORMEX

## Page 671
# ..... S34/35.4  .....

S34/35.4        STQ             SETPD                   # NO ASTRONAUT OVERWRITE
                                NORMEX
                                0D
                GOTO
                                NOVRWRT

## Page 672
# ..... LOMAT     .....

LOMAT           VLOAD           VCOMP
                                UNRM
                STOVL           6D                      # Y
                                RACT3
                UNIT            VCOMP
                STORE           12D
                VXV             VSL1
                                UNRM                    # Z*-Y
                STORE           0D
                SETPD           RVQ
                                18D
GOINT           PDDL            PDDL                    # DO
                                ZEROVECS                #   NOT
                                NOMTPI                  #
                PUSH            PUSH                    #            ORDER OR INSERT BEFORE INTINT
INTINT          STQ             CALL
                                RTRN
                                INTSTALL
                CLEAR           DLOAD
                                INTYPFLG
                BZE             SET
                                +2
                                INTYPFLG
                DLOAD           STADR
                STODL           TDEC1
                SET             LXA,2
                                MOONFLAG
                                RTX2
                BON             CLEAR
                                CMOONFLG
                                ALLSET
                                MOONFLAG
ALLSET          STOVL           TET
                VSR*
                                0,2
                STOVL           RCV
                VSR*
                                0,2
                STCALL          VCV
                                INTEGRVS
                VLOAD           GOTO
                                RATT
                                RTRN

## Page 673
# ..... S34/35.5  .....
# SUBROUTINES USED

#       BANKCALL
#       GOFLASH
#       GOTOPOOH
#       S34/35.3
#       S34/35.4
#       VNPOOH

S34/35.5        STQ             BON
                                SUBEXIT
                                FINALFLG
                                FLAGON
                SET             GOTO
                                UPDATFLG
                                FLAGOFF
FLAGON          CLEAR           VLOAD
                                NTARGFLG
                                DELVLVC
                STORE           GDT/2                   # SAVE DV BEFORE DISPLAY
                EXIT
 +5             CAF             V06N81
                TC              BANKCALL
                CADR            GOFLASH
                TC              GOTOPOOH
                TC              +2                      # PRO
                TC              FLAGON          +5      # LOAD
 +2             CA              EBANK7
                TS              EBANK                   # TO BE SURE

                ZL
                CA              FIVE
NTARGCHK        TS              Q
                INDEX           Q
                CS              DELVLVC
                INDEX           Q
                AD              GDT/2
                ADS             L
                CCS             Q
                TCF             NTARGCHK
                LXCH            A
                EXTEND
                BZF             +3
                TC              UPFLAG
                ADRES           NTARGFLG

                TC              INTPRET
                BOFF            CALL
                                NTARGFLG
## Page 674
                                NOCHG
                                S34/35.3
NOCHG           VLOAD
                                DELVEET3
                STORE           DELVSIN
FLAGOFF         CALL
                                S34/35.4
                EXIT
                CAF             V06N59
                TC              VNPOOH
                TC              INTPRET
                GOTO
                                SUBEXIT

## Page 675
# ..... VN1645    .....

# SUBROUTINES USED

#       P3XORP7X
#       GET+MGA
#       BANKCALL
#       DELAYJOB
#       COMPTGO
#       GOFLASHR
#       GOTOPOOH
#       FLAGUP

VN1645          STQ             DLOAD
                                SUBEXIT
                                DP-.01
                STORE           +MGA                    # MGA = -.01
                BOFF            DLOAD
                                FINALFLG
                                GET45
                                DP-.01
                DAD
                                DP-.01
                STORE           +MGA                    # MGA = -.02
                BOFF            EXIT
                                REFSMFLG
                                GET45
                TC              P3XORP7X
                TC              +2                      # P3X
                TC              GET45           +1      # P7X
                TC              INTPRET
                VLOAD           PUSH
                                DELVSIN
                CALL                                    # COMPUTE MGA
                                GET+MGA
GET45           EXIT
                TC              COMPTGO                 # INITIATE TASK TO UPDATE TTOGO
                CA              SUBEXIT
                TS              QSAVED
                CAF             1SEC
                TC              BANKCALL
                CADR            DELAYJOB
                CAF             V16N45                  # TRKMKCNT, TTOGO, +MGA
                TC              BANKCALL
                CADR            GOFLASH
                TC              KILCLOCK                # TERMINATE
                TC              N45PROC                 # PROCEED
                TC              CLUPDATE                # RECYCLE - RETURN FOR INITIAL COMPUTATION
KILCLOCK        CA              Z
                TS              DISPDEX
## Page 676
                TC              GOTOPOOH
N45PROC         CS              FLAGWRD2
                MASK            BIT6
                EXTEND
                BZF             KILCLOCK                # FINALFLG IS SET-FLASH V37-AWAIT NEW PGM
                TC              PHASCHNG
                OCT             04024
                TC              UPFLAG                  # SET
                ADRES           FINALFLG                # FINALFLG
CLUPDATE        CA              Z
                TS              DISPDEX
                TC              PHASCHNG
                OCT             04024
                TC              INTPRET
                CLEAR           GOTO
                                UPDATFLG
                                QSAVED

## Page 677
# ..... DISPLAYE  .....

# SUBROUTINES USED

#       BANKCALL
#       GOFLASHR
#       GOTOPOOH
#       BLANKET
#       ENDOFJOB

DISPLAYE        EXTEND
                QXCH            NORMEX
                CAF             V06N55
                TCR             BANKCALL
                CADR            GOFLASH
                TCF             GOTOPOOH
                TC              NORMEX
                TCF             -5

## Page 678
# ..... P3XORP7X  .....

P3XORP7X        CAF             HIGH9
                MASK            MODREG
                EXTEND
                BZF             +2
                INCR            Q
                RETURN

# ..... VNPOOH    .....

# SUBROUTINES USED

#       BANKCALL
#       GOFLASH
#       GOTOPOOH

VNPOOH          EXTEND
                QXCH            RTRN
                TS              VERBNOUN
                CA              VERBNOUN
                TCR             BANKCALL
                CADR            GOFLASH
                TCF             GOTOPOOH
                TC              RTRN
                TCF             -5

## Page 679
# ..... CONSTANTS .....

V06N37          VN              0637
V06N55          VN              0655
V06N58          VN              0658
V06N59          VN              0659
V06N81          VN              0681
V16N45          VN              1645
TWOPI           2DEC            6.283185307     B-4

MAX250          2DEC            25              E3

THIRD           2DEC            .333333333

ELEPS           2DEC            .27777777       E-3

DP-.01          OCT             77777                   # CONSTANTS
                OCT             61337                   # ADJACENT       -.01 FOR MGA DSP
EPSFOUR         2DEC            .0416666666

130DEG          2DEC            .3611111111

## Page 680
# ..... INITVEL .....
# MOD NO -1       LOG SECTION - P34-P35, P74-P75
# MOD BY WHITE.P  DATE  21NOV67

# FUNCTIONAL DESCRIPTION

#       THIS SUBROUTINE COMPUTES THE REQUIRED INITIAL VELOCITY VECTOR FOR
#       A TRAJECTORY OF SPECIFIED TRANSFER TIME BETWEEN SPECIFIED INITIAL
#       AND TARGET POSITIONS.  THE TRAJECTORY MAY BE EITHER CONIC OR
#       PRECISION DEPENDING ON AN INPUT PARAMETER (NAMELY, NUMBER OF
#       OFFSETS).  IN ADDITION, IN THE PRECISION TRAJECTORY CASE, THE
#       SUBROUTINE ALSO COMPUTES AN OFFSET TARGET VECTOR, TO BE USED
#       DURING PURE-CONIC CROSS-PRODUCT STEERING.  THE OFFSET TARGET
#       VECTOR IS THE TERMINAL POSITION VECTOR OF A CONIC TRAJECTORY WHICH
#       HAS THE SAME INITIAL STATE AS A PRECISION TRAJECTORY WHOSE
#       TERMINAL POSITION VECTOR IS THE SPECIFIED TARGET VECTOR.

#       IN ORDER TO AVOID THE INHERENT SINGULARITIES IN THE 180 DEGREE
#       TRANSFER CASE WHEN THE (TRUE OR OFFSET) TARGET VECTOR MAY BE
#       SLIGHTLY OUT OF THE ORBITAL PLANE, THIS SUBROUTINE ROTATES THIS
#       VECTOR INTO A PLANE DEFINED BY THE INPUT INITIAL POSITION VECTOR
#       AND ANOTHER INPUT VECTOR (USUALLY THE INITIAL VELOCITY VECTOR),
#       WHENEVER THE INPUT TARGET VECTOR LIES INSIDE A CONE WHOSE VERTEX
#       IS THE ORIGIN OF COORDINATES, WHOSE AXIS IS THE 180 DEGREE
#       TRANSFER DIRECTION, AND WHOSE CONE ANGLE IS SPECIFIED BY THE USER.

#       THE LAMBERT SUBROUTINE IS UTILIZED FOR THE CONIC COMPUTATIONS AND
#       THE COASTING INTEGRATION SUBROUTINE IS UTILIZED FOR THE PRECISION
#       TRAJECTORY COMPUTATIONS.

# CALLING SEQUENCE

#       L         CALL
#       L+1               INITVEL
#       L+2       (RETURN - ALWAYS)

# INPUT

#       (1) RINIT    INITIAL POSITION RADIUS VECTOR
#       (2) VINIT    INITIAL POSITION VELOCITY VECTOR
#       (3) RTARG    TARGET POSITION RADIUS VECTOR
#       (4) DELLT4   DESIRED TIME OF FLIGHT FROM RINIT TO RTARG
#       (5) INTIME   TIME OF RINIT
#       (6) 0D       NUMBER OF ITERATIONS OF LAMBERT/INTEGRVS
#       (7) 2D       ANGLE TO 180 DEGREES WHEN ROTATION STARTS
#       (8) RTX1     -2 FOR EARTH, -10D FOR LUNAR
#       (9) RTX2     COORDINATE SYSTEM ORIGIN - 0 FOR EARTH, 2 FOR LUNAR
#       PUSHLOC SET AT 4D

## Page 681
# OUTPUT

#       (1) RTARG    OFFSET TARGET POSITION VECTOR
#       (2) VIPRIME  MANEUVER VELOCITY REQUIRED
#       (3) VTPRIME  VELOCITY AT TARGET AFTER MANEUVER
#       (4) DELVEET3 DELTA VELOCITY REQUIRED FOR MANEUVER

# SUBROUTINES USED

#       LAMBERT
#       INTSTALL
#       INTEGRVS

                SETLOC          INTVEL
                BANK

                COUNT*          $$/INITV
INITVEL         SET                                     # COGA GUESS NOT AVAILABLE
                                GUESSW
HAVEGUES        VLOAD           STQ
                                RTARG
                                NORMEX
                STORE           RTARG1
                ABVAL
                STORE           RTMAG
                SLOAD           BHIZ
                                RTX2
                                INITVEL1
                VLOAD           VSL2
                                RINIT                   # B29
                STOVL           RINIT                   # B27
                                VINIT                   # B7
                VSL2
                STOVL           VINIT                   # B5
                                RTARG1
                VSL2
                STORE           RTARG1
                ABVAL
                STORE           RTMAG
#      INITIALIZATION

INITVEL1        SSP             DLOAD                   # SET ITCTR TO -1,LOAD MPAC WITH E4(PL 2D)
                                ITCTR
                                0               -1
                COSINE          SR1                     # CALCULATE COSINE (E4)  (+2)
                STODL           COZY4                   # SET COZY4 TO COSINE(E4)          (PL 0D)
                LXA,2           SXA,2
                                MPAC
                                VTARGTAG                # SET VTARGTAG TO 0D (SP)
                VLOAD
## Page 682
                                RINIT
                STOVL           R1VEC                   # R1VEC EQ RINIT
                                RTARG1
                STODL           R2VEC                   # R2VEC EQ RTARG
                                DELLT4
                STORE           TDESIRED                # TDESIRED EQ DELLT4
                SETPD           VLOAD
                                0D                      # INITIALIZE PL TO 0D
                                RINIT                   # MPAC EQ RINIT (+29)
                UNIT            PUSH                    # UNIT(RI)  (+1)                   (PL 6D)
                VXV             UNIT
                                VINIT                   # MPAC EQ UNIT(RI) X VI   (+8)
                STOVL           UN
                                RTARG1
                UNIT            DOT                     # TEMP=URT.URI  (+2)               (PL 0D)
                DAD             CLEAR
                                COZY4
                                NORMSW
                STORE           COZY4
INITVEL2        BPL             SET
                                INITVEL3                # UN CALCULATED IN LAMBERT
                                NORMSW
#    ROTATE RC INTO YC PLANE - SET UNIT NORMAL TO YC

                VLOAD           PUSH                    #                                  (PL 6D)
                                R2VEC                   # RC TO 6D  (+29)
                ABVAL           PDVL                    # RC TO MPAC, ABVAL(RC) (+29) TO OD(PL 2D)
                PUSH            VPROJ                   #                                  (PL 8D)
                                UN
                VSL2            BVSU
                UNIT            VXSC                    #                                  (PL 0D)
                VSL1
                STORE           R2VEC
                TLOAD           SLOAD
                                ZEROVEC
                                ITCTR
                BPL             VLOAD
                                INITVEL3
                                R2VEC
                STORE           RTARG1
INITVEL3        DLOAD           PDVL                    #                                  (PL 2D)
                                MUEARTH                 # POSITIVE VALUE
                                R2VEC
                UNIT            PDVL                    # 2D = UNIT(R2VEC)                 (PL 8D)
                                R1VEC
                UNIT            PUSH                    # 8D = UNIT(R1VEC)                 (PL14D)
                VXV             VCOMP                   # -N = UNIT(R2VEC) X UNIT(R1VEC)
                                2D
                PUSH                                    #                                  (PL20D)
                LXA,1           DLOAD
## Page 683
                                RTX1
                                18D
                BMN             INCR,1
                                +2
                DEC             -8
                INCR,1          SLOAD
                                10D
                                X1
                BHIZ            VLOAD                   #                                  (PL14D)
                                +2
                VCOMP           PUSH                    #                                  (PL20D)
                VLOAD                                   #                                  (PL14D)
                VXV             DOT                     #                                  (PL 2D)
                BPL             DLOAD                   #                                  (PL 0D)
                                INITVEL4
                DCOMP           PUSH                    #                                  (PL 2D)
INITVEL4        LXA,2           SXA,2
                                0D
                                GEOMSGN
#   SET INPUTS UP FOR LAMBERT

                LXA,1           SSP
                                RTX1
                                ITERCTR
                                20D
#    OPERATE THE LAMBERT CONIC ROUTINE (COASTFLT SUBROUTINE)

                CALL
                                LAMBERT

# ARRIVED AT SOLUTION IS GOOD ENOUGH ACCORDING TO SLIGHTLY WIDER BOUNDS.

                CLEAR           VLOAD
                                GUESSW
                                VVEC
# STORE CALCULATED INITIAL VELOCITY REQUIRED IN VIPRIME

                STODL           VIPRIME                 # INITIAL VELOCITY REQUIRED  (+7)

#    IF NUMIT IS ZERO, CONTINUE AT INITVELB, OTHERWISE
# SET UP INPUTS FOR ENCKE INTEGRATION (INTEGRVS).

                                VTARGTAG
                BHIZ            CALL
                                INITVEL7
                                INTSTALL
                SLOAD           CLEAR
                                RTX2
                                MOONFLAG
                BHIZ            SET
## Page 684
                                INITVEL5
                                MOONFLAG
INITVEL5        VLOAD
                                RINIT
                STORE           R1VEC
                STOVL           RCV
                                VIPRIME
                STODL           VCV
                                INTIME
                STORE           TET
                DAD             CLEAR
                                DELLT4
                                INTYPFLG
                STCALL          TDEC1
                                INTEGRVS
                VLOAD
                                VATT1
                STORE           VTARGET

#  IF ITERATION COUNTER (ITCTR) EQ NO. ITERATIONS (NUMIT), CONTINUE AT
# INITVELC, OTHERWISE REITERATE LAMBERT AND ENCKE

                LXA,2           INCR,2
                                ITCTR
                                1D                      # INCREMENT ITCTR
                SXA,2           XSU,2
                                ITCTR
                                VTARGTAG
                SLOAD           BHIZ                    # IF SP(MPAC) EQ 0, CONTINUE AT INITVELC
                                X2
                                INITVEL6
#
#   OFFSET CONIC TARGET VECTOR

                VLOAD           VSU
                                RTARG1
                                RATT1
                VAD
                                R2VEC
                STODL           R2VEC
                                COZY4
                GOTO
                                INITVEL2                # CONTINUE ITERATING AT INITVEL2
# COMPUTE THE DELTA VELOCITY

INITVEL6        VLOAD
                                R2VEC
                STORE           RTARG1
INITVEL7        VLOAD           VSU
                                VIPRIME
                                VINIT
## Page 685
                STOVL           DELVEET3                # DELVEET3 = VIPRIME-VINIT  (+7)
                                VTARGET
                STORE           VTPRIME
                SLOAD           BHIZ
                                RTX2
                                INITVELX
                VLOAD           VSR2
                                VTPRIME
                STOVL           VTPRIME
                                VIPRIME
                VSR2
                STOVL           VIPRIME
                                RTARG1
                VSR2
                STOVL           RTARG1
                                DELVEET3
                VSR2
                STORE           DELVEET3
INITVELX        LXA,1           DLOAD*
                                RTX1
                                MUTABLE -2,1
                PUSH            DMP
                                R1A
                SR1             DDV
                                R1
                STODL           MU/A
                SR
                                6
                STORE           MUASTEER
                SETPD           VLOAD
                                0D
                                RTARG1
                STORE           RTARG
                CLEAR           GOTO
                                XDELVFLG
                                NORMEX

# ..... END OF INITVEL ROUTINE .....

## Page 686
# ..... MIDGIM .....

# MOD NO. 0, BY WILLMAN, SUBROUTINE RENDGUID, LOG P34-P35, P74-P75
#  REVISION 03, 17 FEB 67

#          IF THE ACTIVE VEHICLE IS DOING THE COMPUTATION, MIDGIM COMPUTES
# THE POSITIVE MIDDLE GIMBAL ANGLE OF THE ACTIVE VEHICLE TO THE INPUT
# DELTA VELOCITY VECTOR (0D IN PUSH LIST),  OTHERWISE
# MIDGIM CONVERTS THE INPUT DELTA VELOCITY VECTOR FROM INERTIAL COORDIN-
# ATES TO LOCAL VERTICAL COORDINATES OF THE ACTIVE VEHICLE.

#   .. INPUTS ..

#     NAME        MEANING                              UNITS/SCALING/MODE

#    AVFLAG  INT FLAG - 0 IS CSM ACTIVE, 1 IS LEM ACTIVE             BIT
#    RINIT   ACTIVE VEHICLE RADIUS VECTOR            METERS/CSEC (+7) VT
#    VINIT   ACTIVE VEHICLE VELOCITY VECTOR          METERS/CSEC (+7) VT
#    0D (PL) ACTIVE VEHICLE DELTA VELOCITY VECTOR    METERS/CSEC (+7) VT

#   .. OUTPUTS ..

#     NAME        MEANING                              UNITS/SCALING/MODE

#      +MGA  + MIDDLE GIMBAL ANGLE                  REVOLUTIONS (+0) DP
#    DELVLVC DELTA VELOCITY VECTOR IN LV COORD.     METERS/CSEC (+7) VT
#   MGLVFLAG INT FLAG - 0 IS +MGA COMPUTED, 1 IS DELVLVC COMP.  -   BIT

#  .. CALLING SEQUENCE ..

# L       CALL
# L+1            MIDGIM
# L+2     (RETURN - ALWAYS)

#   .. NO SUBROUTINES CALLED ..

#   .. DEBRIS - ERASEABLE TEMPORARY USAGE

#        A,Q,L, PUSH LIST, MPAC.

#   .. ALARMS - NONE ..

## Page 687
# MIDDLE GIMBAL ANGLE COMPUTATION.

                SETLOC          MIDDGIM
                BANK

                COUNT*          $$/MIDG

HALFREV         2DEC            1               B-1

GET+MGA         VLOAD           UNIT                    # (PL 0D) V (+7) TO MPAC, UNITIZE  UV (+1)
                UNIT
                DOT             SL1                     # DOT UV WITH Y(STABLE MEMBER) AND RESCALE
                                REFSMMAT        +6      #  FROM +2 TO +1 FOR ASIN ROUTINE
                ARCSIN          BPL
                                SETMGA
                DAD             DAD                     # CONVERT -MGA TO +MGA BY
                                HALFREV                 # ADDING ONE REVOLUTION
                                HALFREV
SETMGA          STORE           +MGA
                CLR             RVQ                     # CLEAR MGLVFLAG TO INDICATE +MGA CALC
                                MGLVFLAG                #     AND EXIT
GET.LVC         VLOAD           UNIT                    # (PL 6D)   R (+29) IN MPAC, UNITIZE UR
                                RINIT
                VCOMP                                   # U(-R)
                STORE           18D                     # U(-R) TO 18D
                VXV             UNIT                    # U(-R)*V EQ V*U(R), U(V*R)
                                VINIT
                STORE           12D                     # U(V*R) TO 12D
                VXV             UNIT                    # U(V*R)*U(-R), U((V*R)*(-R))
                                18D
                STOVL           6D                      # TRANSFORMATION MATRIX IS IN 6D (+1)
                                0D                      # DELTA V (+7) IN 0D
                MXV             VSL1                    # CONVERT FROM INER COOR TO LV COOR (+8)
                                6D                      #  AND SCALE +7 IN MPAC
                STORE           DELVLVC                 # STORE IN DELVLVC (+7)
                SET             RVQ                     # SET MGLVFLAG TO INDICATE LVC CALC
                                MGLVFLAG                #     AND EXIT
#    ..... END OF MIDGIM ROUTINE .....

## Page 688
                BANK            10
                SETLOC          SLCTMU
                BANK
                COUNT*          $$/MIDG

SELECTMU        AXC,1           AXT,2
                                2D
                                0D
                BOFF
                                CMOONFLG
                                SETMUER
                AXC,1           AXT,2
                                10D
                                2D
SETMUER         DLOAD*          SXA,1
                                MUTABLE +4,1
                                RTX1
                STODL*          RTSR1/MU
                                MUTABLE -2,1
                BOFF            SR
                                CMOONFLG
                                RTRNMU
                                6D
RTRNMU          STORE           RTMU
                SXA,2           CLEAR
                                RTX2
                                FINALFLG
                GOTO
                                VN1645

## Page 689
# ..... PERIAPO .....

# MOD NO -1       LOG SECTION - P34-P35, P74-P75
# MOD BY WHITE.P  DATE  18JAN68

# FUNCTIONAL DESCRIPTION

#       THIS SUBROUTINE COMPUTES THE TWO BODY APOCENTER AND PERICENTER
#       ALTITUDES GIVEN THE POSITION AND VELOCITY VECTORS FOR A POINT ON
#       THE TRAJECTORY AND THE PRIMARY BODY.

#       SETRAD IS CALLED TO  DETERMINE THE RADIUS OF THE PRIMARY BODY.

#       APSIDES IS CALLED TO SOLVE FOR THE TWO BODY RADII OF APOCENTER AND
#       PERICENTER AND THE ECCENTRICITY OF THE TRAJECTORY.

# CALLING SEQUENCE

#       L         CALL
#       L+1               PERIAPO
#       L+2       (RETURN - ALWAYS)

# INPUT

#       (1) RVEC     POSITION VECTOR IN METERS
#                    SCALE FACTOR - EARTH +29, MOON +27
#       (2) VVEC     VELOCITY VECTOR IN METERS/CENTISECOND
#                    SCALE FACTOR - EARTH +7, MOON +5
#       (3) X1       PRIMARY BODY INDICATOR
#                    EARTH -2, MOON -10

# OUTPUT

#       (1) 2D       APOCENTER RADIUS IN METERS
#                    SCALE FACTOR - EARTH +29, MOON +27
#       (2) 4D       APOCENTER ALTITUDE IN METERS
#                    SCALE FACTOR - EARTH +29, MOON P27
#       (3) 6D       PERICENTER RADIUS IN METERS
#                    SCALE FACTOR - EARTH +29, MOON +27
#       (4) 8D       PERICENTER ALTITUDE IN METERS
#                    SCALE FACTOR - EARTH +29, MOON +27
#       (5) ECC      ECCENTRICITY OF CONIC TRAJECTORY
#                    SCALE FACTOR - +3
#       (6) XXXALT   RADIUS OF THE PRIMARY BODY IN METERS
#                    SCALE FACTOR - EARTH +29, MOON +27
#       (7) PUSHLOC  EQUALS 10D

# SUBROUTINES USED

#       SETRAD
## Page 690
#       APSIDES

                SETLOC          APOPERI
                BANK

                COUNT*          $$/PERAP

RPAD            2DEC            6373338         B-29    # STANDARD RADIUS  OF PAD 37-B.

                                                        # = 20 909 901.57 FT

PERIAPO1        LXA,2           VSR*
                                RTX2
                                0,2
                STOVL           VVEC
                LXA,1           VSR*
                                RTX1
                                0,2
                STORE           RVEC
PERIAPO         STQ             CALL
                                NORMEX
                                SETRAD
                STCALL          XXXALT
                                APSIDES
                SETPD           PUSH                    # 2D = APOCENTER RADIUS   B29 OR B27
                                2D
                DSU             PDDL                    # 4D = APOGEE ALTITUDE    B29 OR B27
                                XXXALT
                                0D
                PUSH            DSU                     # 6D = PERICENTER RADIUS  B29 OR B27
                                XXXALT
                PUSH            GOTO                    # 8D = PERIGEE ALTITUDE   B29 OR B27
                                NORMEX

## Page 691
# SETRAD
SETRAD          DLOAD           PUSH
                                RPAD
                SXA,1           INCR,2
                                X2
                                2D
                SLOAD           BHIZ
                                X2
                                SETRADX
                VLOAD           ABVAL
                                RLS
                PDDL
SETRADX         DLOAD           RVQ

## Page 692
# PRECSET
PRECSET         STQ
                                NORMEX
                STCALL          TDEC2
                                LEMPREC
                CALL
                                LEMSTORE
                DLOAD
                                TDEC2
                STCALL          TDEC1
                                CSMPREC
                CALL
                                CSMSTORE
                GOTO
                                NORMEX
LEMSTORE        VLOAD           BOFF
                                RATT
                                AVFLAG
                                PASSIVE
ACTIVE          STOVL           RACT3
                                VATT
                STORE           VACT3
                RVQ
CSMSTORE        VLOAD           BOFF
                                RATT
                                AVFLAG
                                ACTIVE
PASSIVE         STOVL           RPASS3
                                VATT
                STORE           VPASS3
                RVQ

## Page 693
# VECSHIFT
VECSHIFT        LXA,2           VSR*
                                RTX2
                                0,2
                LXA,1           PDVL
                                RTX1
                VSR*            PDVL
                                0,2
                RVQ

## Page 694
# SHIFTR1
SHIFTR1         LXA,2           SL*
                                RTX2
                                0,2
                RVQ

## Page 695
# PROGRAM DESCRIPTION
# SUBROUTINE NAME       R36  OUT-OF-PLANE RENDEZVOUS ROUTINE
# MOD NO.  0                      DATE      22 DECEMBER 67
# MOD BY   N.M.NEVILLE            LOG SECTION  EXTENDED VERBS
# FUNCTIONAL DESCRIPTION

# TO DISPLAY AT ASTRONAUT REQUEST LGC CALCULATED RENDEZVOUS
# OUT-OF-PLANE PARAMETERS (Y , YDOT , PSI). (REQUESTED BY DSKY).

# CALLING SEQUENCE

# ASTRONAUT REQUEST THROUGH DSKY  V 90 E

# SUBROUTINES CALLED

# EXDSPRET
# GOMARKF
# CSMPREC
# LEMPREC
# SGNAGREE
# LOADTIME

# NORMAL EXIT MODES

# ASTRONAUT REQUEST THROUGH DSKY TO TERMINATE PROGRAM V 34 E

# ALARM OR ABORT EXIT MODES

# NONE

# OUTPUT

# DECIMAL DISPLAY OF TIME , Y , YDOT AND PSI

# DISPLAYED VALUES Y , YDOT , AND PSI , ARE STORED IN ERASABLE
# REGISTERS RANGE , RRATE AND RTHETA RESPECTIVELY.

# ERASABLE INITIALIZATION REQUIRED

# CSM AND LEM STATE VECTORS

# DEBRIS

# CENTRALS A,Q,L

# OTHER THOSE USED BY THE ABOVE LISTED SUBROUTINES

                BANK            20
                SETLOC          R36LM
                BANK

## Page 696
                EBANK=          TIG
                COUNT*          $$/R36

R36             EXTEND
                DCA             TIG                     # SET TIME-OF-EVENT TO TIG FOR NOMINAL
                DXCH            DSPTEMX                 # DISPLAY
                CAF             V06N16N
                TC              BANKCALL
                CADR            GOMARKF
                TCF             ENDEXT                  # TERMINATE
                TCF             +2                      # PROCEED
                TCF             -5                      # RECYCLE FOR ASTRONAUT INPUT TIME
                TC              INTPRET
                DLOAD           BZE
                                DSPTEMX
                                GETNOW                  # ASTOR-LOADED ZERO, GET PRES TIME
R36INT          STCALL          TDEC1
                                OTHPREC
                VLOAD           PDVL
                                VATT
                                RATT                    # -
                STORE           RPASS36                 # R
                UNIT            PDVL                    #  P
                VXV             UNIT                    # -
                STADR
                STODL           UNP36                   # U
                                TAT
                STCALL          TDEC1
                                THISPREC
                VLOAD           PDVL                    #                  -
                                VATT                    # VELOCITY VECTOR  V               00D
                                RATT                    #                   A
                PUSH            PUSH                    # POSITION VECTOR  R   IN  06D AND 12D
                BVSU            PDVL                    #                   A  -   -
                                RPASS36                 # LINE OF SIGHT VECTOR R - R       12D
                DOT             SL1                     #                        P   A
                                UNP36                   #     -   -
                STOVL           RANGE                   # Y = U . R
                                00D                     #          A
                DOT             SL1
                                UNP36                   # .   -   -
                STOVL           RRATE                   # Y = U . V
                                06D                     # -        A  -
                UNIT            PUSH                    # U   = UNIT( R )                  18D
                VXV             VXV                     #  RA          A
                                00D                     #  -   -   -     -
                                18D                     # (U  XV )XU    =U
                VSL2            UNIT                    #   RA  A   RA    A
                UNIT
                STOVL           00D                     # UNIT HORIZONTAL IN FORWARD DIR.  00D
## Page 697
                                18D
                DOT             VXSC                    # -
                                12D                     # U
                VSL2                                    #  L
                BVSU            UNIT
                UNIT
                PUSH            DOT                     # LOS PROJECTED INTO HORIZONTAL    12D
                                00D                     # PLANE
                SL1             ARCCOS                  #              -   -
                STOVL           RTHETA                  # PSI = ARCCOS(U . U )
                VXV             DOT                     #               A   L
                                00D
                BPL             DLOAD
                                R36TAG2
                                LODPMAX
                DSU
                                RTHETA
                STORE           RTHETA
R36TAG2         EXIT
                CAF             V06N90N                 #  DISPLAY Y , YDOT , AND PSI
                TC              BANKCALL
                CADR            GOMARKF
                TCF             ENDEXT                  # TERMINATE
                TCF             ENDEXT                  # PROCEED , END OF PROGRAM
                TCF             R36                     # RECYCLE, TIG OR ASTRO-OPTION
GETNOW          RTB             GOTO                    # ASTRO-SELECTED PRESENT TIME
                                LOADTIME
                                R36INT
V06N16N         VN              00616
V06N90N         VN              00690
