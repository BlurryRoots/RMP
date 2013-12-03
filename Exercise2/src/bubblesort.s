;******************** (C) Sven Freiberg, Clemens Akens ********************************
;* File Name          : main.s
;* Author             : Sven Freiberg && Clemens Akens
;* Date               : 03.12.2013
;* Description        : This is the source code for exercise 2.
;
;*******************************************************************************
	
    ; for managing the references for the list
    ; to use and its element size
    ; data
	IMPORT CurrentList
	IMPORT CurrentListEnd
	IMPORT ElementSize
    ; subprograms
	IMPORT set_used_list_and_size
        
    ; for counting the swaps
    ; data
	IMPORT Swapped
	IMPORT SwappedCount
    ; subprograms
	IMPORT set_swapped
    IMPORT get_swapped
	IMPORT reset_swapped_counter
    IMPORT increment_swapped_counter
	
	; for iterator logic
	; data
	IMPORT Iterator			
	; subprograms
	IMPORT iterator_reset		
	IMPORT iterator_increment	
	IMPORT iterator_is_valid	
	IMPORT iterator_get			
	IMPORT iterator_get_value	
	IMPORT load_value_with_size	

	; logic for calculation mean value
	; export all used data
	IMPORT Mean
	; export used functions
	IMPORT reset_mean
	IMPORT calculate_mean
	
	IMPORT swap_values

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************	
	AREA MyData, DATA, align = 4
	
; first data list / size of element is 4
DataList		DCD	35, -1 , 13,  -12, 100, 101, -3, -5, 0, 7
DataListEnd		DCB 0

; second data list / size of element is 2
DataList1		DCB -12, -5, -3, -1, 0, 7, 13, 35, 100, 101
DataListEnd1	DCB 0

;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

	; data
	; first list
	EXPORT DataList			[DATA]
	EXPORT DataListEnd		[DATA]
	; second list			
	EXPORT DataList1		[DATA]
	EXPORT DataListEnd1		[DATA]
	; subprograms
	EXPORT bubblesort 		[CODE]
	
	
;--------------------------------------------
; main subroutine
;--------------------------------------------
bubblesort PROC
	
	; ----------------------
	; INITIAL SETUP
	; ----------------------
	
	ldr r0, =DataList
	ldr r1, =DataListEnd
	mov r2, #4
	bl set_used_list_and_size
	
	; ----------------------
	; INITIAL SETUP
	; ----------------------

	; caluculate mean value of current list
	bl calculate_mean
	; and store it to designated memory
	ldr r4, =Mean
	str r0, [r4]

	bl reset_swapped_counter

	; set swapped to true
	mov r0, #1
	bl set_swapped
	
; do bubble sort		
begin_while_swapped_true	
	
	; check if swapped
	bl get_swapped
	cmp r0, #1
	; and if not end loop
	bmi end_while_swapped_true
	
	; set swapped to false
	mov r0, #0
	bl set_swapped
	
	; reset iterator to the first element of
	; the currently used list
	ldr r0, =CurrentList
	ldr r0, [r0]
	bl iterator_reset
	
; while pointer is not the last element
begin_while_not_last_element

	; check if iterator is valid
	ldr r0, =CurrentListEnd
	ldr r0, [r0]
	bl iterator_is_valid
	
	; if not end loop
	cmp r0, #1	
	bmi end_while_not_last_element
		
begin_if_value_greater
	
	; get value to which iterator is pointing,
	; with offset 0 * element size (current element)
	mov r0, #0
	bl iterator_get_value
	mov r4, r0 ; current value
	
	; get value to which iterator is pointing,
	; with offset 1 * element size (successor)
	mov r0, #1
	bl iterator_get_value
	mov r5, r0 ; next value	
	
	; if current value greater than following value
	cmp r4, r5
	bmi end_if_value_greater ; if r4 is smaller or equal r5 end if
	
	; else swap both entries	
	bl iterator_get
	ldr r1, =ElementSize
	ldr r1, [r1]
	add r1, r0, r1
	bl swap_values
	
	; and increment the swap counter
	bl increment_swapped_counter
	
	; set swapped to true
	mov r0, #1
	bl set_swapped
	
end_if_value_greater
	
	; increment iterator
	bl iterator_increment
		
	b begin_while_not_last_element
		
end_while_not_last_element
		
	b begin_while_swapped_true
		
end_while_swapped_true
		
	ENDP
	
	ALIGN
       
	END
		