TITLE Project04     (Project04.asm)

; Author: Ian Collier
; Course / Project ID: CS271 / Project04                 Date: 2/17/19
; Description: A composite number calculator

INCLUDE Irvine32.inc

; Const
UPPER_LIMIT = 400
LOWER_LIMIT = 1
INVALID_INPUT = -1

.data

; Vars
intro1		BYTE	"Welcome to Composite Num Calc (made by Ian Collier).",0
intro2		BYTE	"Enter the amount of composite numbers to see (up to 400),",0
intro3		BYTE	"Then I'll print them out.",0

getdata1	BYTE	"How many composites [1-400]: ",0
getdataerr1	BYTE	"Out of range.",0

spacer		BYTE	"  ",0

farewell1	BYTE	"Results certified fresh. Bye.",0


; Input vars
numberIn		DWORD	?			; Input holder
compCount		DWORD	0			; Count of composites printed 
compCheck		DWORD	?			; Param for composite checker

.code
main PROC
	; Call procs
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP

; Print the intro
introduction PROC
	pushad

	; Print title of program
	mov		edx,OFFSET intro1
	call	WriteString
	call	Crlf
	call	Crlf
	; Print instructions
	mov		edx,OFFSET intro2
	call	WriteString
	call	Crlf
	mov		edx,OFFSET intro3
	call	WriteString
	call	Crlf
	call	Crlf

	popad
	ret
introduction ENDP

; Get the user data and store in globals
getUserData PROC
	pushad

	; Loop until break
	getUserDataLoop:
		; Input prompt
		mov		edx,OFFSET getdata1
		call	WriteString
		; Get user input
		call	ReadInt
		mov		numberIn, eax
		; Validate using subproc
		call	validateUserData

		; If not invalid break
		mov		eax, numberIn
		cmp		eax, INVALID_INPUT
		jne		getUserDataDone

		; Else loop
		jmp		getUserDataLoop

	getUserDataDone:
	popad
	ret
getUserData ENDP

; Checks if input is valid (between upper and lower limit)
; Preconditions: numberIn contains number to validate
; Returns: numberIn = INVALID_INPUT if invalid, otherwise nothing
validateUserData PROC
	pushad

	; If below lower limit error
	mov		eax, numberIn
	cmp		eax, LOWER_LIMIT
	jl		validateUserDataErr

	; Or if above upper limit error
	mov		eax, numberIn
	cmp		eax, UPPER_LIMIT
	jg		validateUserDataErr

	; In range, no error
	jmp		validateUserDataDone

	; Error label
	validateUserDataErr:
		mov		numberIn, INVALID_INPUT
		mov		edx,OFFSET getdataerr1	; Prompt
		call	WriteString
		call	Crlf

		
	validateUserDataDone:
	popad
	ret
validateUserData ENDP

; Loops to print all composites in range
showComposites PROC
	pushad

	; Index for loop
	mov		ebx, 3
	mov		compCheck, 3

	; Loop to print numbers
	showCompositesLoop:
		; Validate the index
		mov		compCheck, ebx
		call	isComposite

		; If invalid skip printing it
		mov		eax, compCheck
		cmp		eax, INVALID_INPUT
		je		showCompositesLoopNoPrint

		; Print and increment printed count
		mov		eax, ebx			; Print index
		call	WriteDec
		mov		edx,OFFSET spacer	; Print space
		call	WriteString
		inc		compCount

		showCompositesLoopNoPrint:
		; Increment the index
		inc		ebx


		; Break if enough printed
		mov		eax, compCount
		cmp		eax, numberIn
		jge		showCompositesDone

		; Else loop
		jmp		showCompositesLoop

	showCompositesDone:
	popad
	ret
showComposites ENDP

; Checks if a single number is composite
; Preconditions: compCheck contains number to validate
; Returns: compCheck = INVALID_INPUT if invalid, otherwise nothing
isComposite PROC
	pushad

	; Setup loop
	mov		ebx, 0			; ebx = counter
	mov		ecx, 1			; ecx = loop index

	; Loop
	isCompositeLoop:

		; If (compCheck % ecx) != 0 dont count
		mov		eax, compCheck
		xor		edx, edx
		div		ecx
		mov		eax, edx		; compCheck % ecx

		cmp		eax, 0			; Result != 0
		jne		isCompositeLoopSkip

		; Increment counter
		inc ebx

		isCompositeLoopSkip:
		; Increment index
		inc		ecx

		; While index <= compCheck loop
		cmp		ecx, compCheck
		jle		isCompositeLoop

	; If count > 2 then is composite
	cmp		ebx, 2
	jg		isCompositeDone

	isCompositeFalse:
		mov		compCheck, INVALID_INPUT

	isCompositeDone:
	popad
	ret
isComposite ENDP
	

; Print the farewell
farewell PROC
	pushad

	call	Crlf
	call	Crlf
	mov		edx,OFFSET farewell1
	call	WriteString
	call	Crlf

	popad
	ret
farewell ENDP

END main
