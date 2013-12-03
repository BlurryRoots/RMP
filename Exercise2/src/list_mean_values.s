
	IMPORT CurrentList
	IMPORT CurrentListEnd
	
	IMPORT iterator_reset		
	IMPORT iterator_increment	
	IMPORT iterator_is_valid	
	IMPORT iterator_get_value	

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************	
	AREA ListData, DATA, align = 4

Mean			DCD 0 ; stores the mean value of the MeanSum / SwappedCount


;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

	; export all used data
	EXPORT Mean 			[DATA]
	
	; export used functions
	EXPORT reset_mean 		[CODE]
	EXPORT calculate_mean 	[CODE]

; resets the mean sum and the mean value
reset_mean PROC

	push{r4,r5}
	
	mov r4, #0
	ldr r5, =Mean
	str r4, [r5]
	
	pop{r4,r5}

	bx lr
	ENDP
	
; adds given number to 
calculate_mean PROC

	push{r4-r7}
	
	; reset iterator to the first element of
	; the currently used list
	ldr r0, =CurrentList ; load pointer to current list variable
	ldr r0, [r0]		 ; get value of resembling the address of the current list variable
	push{lr}
	bl iterator_reset
	pop{lr}
	
	mov r4, #0 ; reset list length counter
	mov r5, #0 ; reset list element sum
	
begin_while_iterator_good

	; check if iterator is valid
	ldr r0, =CurrentListEnd
	ldr r0, [r0]
	push{lr}
	bl iterator_is_valid
	pop{lr}	
	cmp r0, #1 					; check if result is true
	bmi end_while_iterator_good ; if itertor is not valid end loop
	
	; else get value, and sum up
	mov r0, #0
	push{lr}
	bl iterator_get_value
	pop{lr}
	
	add r4, r4, #1	; increment length counter
	add r5, r5, r0  ; add value to sum
	
	; increment iterator
	push{lr}
	bl iterator_increment
	pop{lr}
	
	; jump back to loop head
	b begin_while_iterator_good
	
end_while_iterator_good

	sdiv r0, r5, r4  ; divide the sum by the list length

	pop{r4-r6}

	bx lr
	ENDP
	
	ALIGN
	
	END
	