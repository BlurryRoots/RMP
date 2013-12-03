;********************************************
; Data section, aligned on 4-byte boundery
;********************************************	
	AREA SwapData, DATA, align = 4

Swapped			DCB 1 ; boolean variable, storing infromation if algo has swapped values
SwappedCount	DCD 0 ; counts the number of swappes needed for the current list


;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

	; export all used data
	EXPORT Swapped [DATA]
	EXPORT SwappedCount [DATA]
	
	; export used functions
	EXPORT set_swapped [CODE]
    EXPORT get_swapped [CODE]
	EXPORT reset_swapped_counter [CODE]
    EXPORT increment_swapped_counter [CODE]
	
; sets the swapped variable
; param1 <- r0
set_swapped PROC
	
	push{r4}
	
	ldr r4, =Swapped
	strb r0, [r4]
	
	pop{r4}
	
	bx lr	
	ENDP

; returns value of swapped
; retval -> r0
get_swapped PROC

	ldr r4, =Swapped
	ldrb r0, [r4]

	bx lr
	ENDP

; resets swap counter to 0
reset_swapped_counter PROC

	push{r4,r5}
	
	mov r4, #0
	ldr r5, =SwappedCount
	str r4, [r5]

	pop{r4,r5}
	
	bx lr
	ENDP
	
; incremenst swap counter by 1
increment_swapped_counter PROC

	push{r4,r5}
	
	ldr r4, =SwappedCount	; load counter address
	ldr r5, [r4]			; load counter value
	add r5, r5, #1			; increment value by 1
	str r5, [r4]			; store new value to address

	pop{r4,r5}
	
	bx lr
	ENDP
	
	ALIGN
       
	END
