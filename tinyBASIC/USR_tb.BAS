  10 REM USR( ) TEST
  20 PRINT " ENTEREING... "
  30 GOSUB USR(4096)
  40 PRINT " NEVER PRINTED "
  50 STOP
  60 END
  70 REM TRY PEEK() 3000H with Assembly opcode
  80 REM Transfer the control using USR( )
  90 REM return back to tiny BASIC
 100 REM the above routine invokes MONITOR
