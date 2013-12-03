
	IMPORT ElementSize

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************	
	AREA IteratorData, DATA, align = 4

Iterator	DCD 0 ; points to currently used element

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3
	
	; data
	EXPORT Iterator			[DATA]

	; subprograms
	EXPORT iterator_reset		[CODE]
	EXPORT iterator_increment	[CODE]
	EXPORT iterator_is_valid	[CODE]
	EXPORT iterator_get			[CODE]
	EXPORT iterator_get_value	[CODE]
	EXPORT load_value_with_size	[CODE]

; resets iterator to start of array
; param1 <- r0: start address of array
iterator_reset PROC

	push{r4}

	ldr r4, =Iterator ; load address of iterator
	str r0, [r4]	  ; set it to address given to procedure
	
	pop{r4}

	bx lr
	ENDP

; increments iterator by size
iterator_increment PROC

	push{r4-r7}

	; load value of iterator
	ldr r4, =Iterator
	ldr r5, [r4]
	
	; load value of element size
	ldr r6, =ElementSize
	ldr r7, [r6]
	
	; add element size to iterator
	add r5, r7, r5
	
	; store new value to Iterator
	str r5, [r4]
	
	pop{r4-r7}

	bx lr
	ENDP
	
; checks if iterator is not the last element
; param2 <- r0 : end of array
; retval -> r0: 1 if valid 0 if not
iterator_is_valid PROC

	push{r4-r6}

	; load iterator value (address of current element)
	ldr r4, =Iterator
	ldr r4, [r4]
	
	;ldr r5, =ElementSize
	;ldr r5, [r5]
	
	;sub r5, r0, r5 ; subtract one element size to get from end to last element
	
	; check if r4 < r0
	mov r6, #0 ; assume false
	;cmp r4, r5
	cmp r4, r0
	movmi r6, #1 ; if cmp was negative set true

	mov r0, r6
	
	pop{r4-r6}
	
	bx lr
	ENDP

; returns value current address iterator is pointing to
; retval -> r0: address of current element
iterator_get PROC

	push{r4}

	ldr r4, =Iterator ; fetch var address
	ldr r0, [r4]	  ; get current element address

	pop{r4}

	bx lr
	ENDP

; loads value from array at current iterator position
; param1 <- r0: offset
; retval -> r0: value got from array
iterator_get_value PROC

	push{r4-r7}

	; save procedure param1
	mov r4, r0

	; load address of current element
	push{lr}
	bl iterator_get
	pop{lr}
	mov r5, r0
	
	ldr r6, =ElementSize
	ldr r6, [r6]
	
	mul r7, r4, r6 ; calculate address offset depending on element size
	add r5, r5, r7 ; calculate address by adding the offset to the current iterator address

	; distinguish between 1, 2 and 4 byte
	mov r0, r5
	mov r1, r6
	push{lr}
	bl load_value_with_size
	pop{lr}
	
	; r0 is set through subprogram load_value_with_size
	
	pop{r4-r7}

	bx lr
	ENDP
	
; loads a value of a given address with a given byte size
; param1 <- r0: address to derefer
; param1 <- r1: size of the information to load
; retval -> r0: value got from address
load_value_with_size PROC
	
	push{r4}
	
	mov r4, r0
	
	cmp r1, #1		; check if size is 1 byte
	ldrbeq r0, [r4] ; derefer 1 byte from address
	beq end_load_value_with_size
	
	cmp r1, #2		; check if size is 1 byte
	ldrheq r0, [r4] ; derefer 1 byte from address
	beq end_load_value_with_size
	
	cmp r1, #4		; check if size is 1 byte
	ldreq r0, [r4] ; derefer 1 byte from address

end_load_value_with_size	; label to jump to when successful
	pop{r4}
	
	bx lr
	ENDP
	
	ALIGN
	
	END
	
