;********************************************
; Data section, aligned on 4-byte boundery
;********************************************	
	AREA ListData, DATA, align = 4

; this variables can be changed to indicate with which array the algorithm should work
CurrentList		DCD 0 ; begin of list to be used
CurrentListEnd 	DCD 0 ; end of list to be used

ElementSize		DCB	4 ; stores size of one element of array in bytes


;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

	; export all used data
	EXPORT CurrentList [DATA]
	EXPORT CurrentListEnd [DATA]
	EXPORT ElementSize [DATA]
	
	; export used functions
	EXPORT set_used_list_and_size [CODE]
	
; set the beginning and end of the list to be used
; as well as the size of an element in the list
; param1 <- r0: start of list
; param2 <- r1: end of list
; param3 <- r2: size of one element
set_used_list_and_size PROC

	push{r4}
	
	ldr r4, =CurrentList
	str r0, [r4]
	
	ldr r4, =CurrentListEnd
	str r1, [r4]
	
	ldr r4, =ElementSize
	str r2, [r4]
	
	pop{r4}

	bx lr
	ENDP
	
	ALIGN
       
	END
