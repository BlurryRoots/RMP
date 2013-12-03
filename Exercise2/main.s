;******************** (C) Sven Freiberg, Clemens Akens ********************************
;* File Name          : main.s
;* Author             : Sven Freiberg && Clemens Akens
;* Date               : 03.12.2013
;* Description        : This is the source code for exercise 2.
;
;*******************************************************************************
	
    ; bubble sort stuff
    ; data
	; first list
	IMPORT DataList		
	IMPORT DataListEnd		
	; second list
	IMPORT DataList1
	IMPORT DataListEnd1
	; subprograms
	IMPORT bubblesort

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************	
	AREA MyData, DATA, align = 4
	
; no data used

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

	EXPORT main [CODE]	
	
	b main
	
	
;--------------------------------------------
; main subroutine
;--------------------------------------------
main PROC
	
	bl bubblesort
		
forever	
	b	forever		; nowhere to retun if main ends		
		
	ENDP
	
	ALIGN
       
	END
		