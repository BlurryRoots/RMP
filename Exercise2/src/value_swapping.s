;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

	EXPORT swap_values [CODE]	
	
; ------------------
; DEFINTIONS OF SUBROUTINES
; ------------------

; swaps two values
; param1 <- r0: address of first value
; param2 <- r1: address of second value
swap_values PROC

	push{r4,r5}

	ldr r4, [r0] ; load first value
	ldr r5, [r1] ; load second value
	
	str r5, [r0] ; write second value to first place
	str r4, [r1] ; write first value to second place
	
	pop{r4,r5}

	bx lr
	ENDP
	
	ALIGN
	
	END
	