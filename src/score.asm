;
;

;Yousif Mansour 200360315
;ECE109 Section 001, Problem Session 402
;April 12, 2021
;score.asm 


;
;

		.ORIG x3000
		
;JSR SegClear				;attempts to clear display on bootup, does not work.
							;please TA if you have time, remove the semicolon and 
							;examine my code. SegClear is line 489
							
							;Error Message:
							;IllegalMemAccessException accessing address xC000
							;(The MPR and PSR do not permit access to this address)
							
							
							
START AND R0, R0, 0			;input character
AND R1, R1, 0				;negative character checks & nzp check
AND R2, R2, 0				;storage counter @ 0
AND R3, R3, 0				
AND R4, R4, 0
AND R5, R5, 0
AND R6, R6, 0
AND R7, R7, 0				;Do Not use


LEA R0, PROMPT1
PUTS



;begin character check loop 1
;	-recieves input and stores it, if it is "0" - "f"
;

		AGAIN GETC					;R0
		OUT

		LD R1, negCharq 			;input = "q" ?
		ADD R1, R0, R1
		Brnp isntq					;if no, continue

			LEA R0, ENDPROMPT			;if q, Prints End Prompt and HALTS
			PUTS
			HALT


					;PC-OFFSET 
					;	-Must be stored higher up in memory to be in reach of PC-Offset9

					nullfill		.FILL		x0010		;character after "f", clear character
					negChara		.FILL		xFF9F		;Check for a
					negCharf		.FILL		xFF99		;check for f
					negCharq		.FILL		xFF8F		;Check for q
					negChar0 		.FILL 		xFFD0 		;Check for 0
					negChar9 		.FILL 		xFFC7 		;Check for 9
					negRtrn			.FILL		xFFF6		;Check for Return
					negintASCII		.FILL		xFFD0		;Convert ASCII "0" - "9" to interger
					negcharASCII	.FILL		xFFA9		;Convert ASCII "a" - "f" to interger
					ENDPROMPT		.STRINGZ				"\nThank you for playing - Go Wolfpack!\n"
					PROMPT1			.STRINGZ				"Input 1-4 Hex characters: "
					LineFeed		.STRINGZ				"\n"
					Inputs			.BLKW		4	

					;
					;PC-OFFSET
					

isntq 	ADD R1, R2, 0			;storage counter > 0?
		BRz nortrn				;if no, no need to check for return
		
		LD R1, negRtrn			;input = "rtrn" ?
		ADD R1, R0, R1
		BRnp nortrn				;if no, skip return loop
			
			;return loop 
			;	-stores a "null" for every digit not already stored 
		
Loop		LD R3, nullfill			;Loads null
			LEA R1, Inputs			;store null
			ADD R1, R1, R2			;via storage counter
			STR R3, R1, 0
				
			ADD R2, R2, 1			;inc storage counter by 1
				
			ADD R1, R2, -4			;storage counter = 4?
			BRz Skip				;if yes, exit character check loop 1
			BRnp Loop
				
			;
			;return loop
		
		
nortrn	LD R1, negChar0			;input >= "0" ?
		ADD R1, R0, R1	
		BRn acheck				;if no, check for "a" - "f"
		
		LD R1, negChar9			;input <= "9" ?
		ADD R1, R0, R1
		BRp acheck				;if no, check for "a" - "f"
		
			LD R1, negintASCII		;if yes for both, subtract x30
			ADD R0, R0, R1
			BRnzp store				;store
			
			
acheck	LD R1, negChara			;input >= "a" ?	
		ADD R1, R0, R1
		BRn AGAIN				;if no, GETC
		
		LD R1, negCharf			;input <= "f" ?
		ADD R1, R0, R1
		BRzp AGAIN				;if no, GETC
		
			LD R1, negcharASCII 	;if yes for both, subtract #87
			ADD R0, R0, R1			;store
			
			
store	LEA R1, Inputs			;store input
		ADD R1, R1, R2
		STR R0, R1, 0			;via storage counter
		
		ADD R2, R2, 1			;inc storage counter by 1
		
		ADD R1, R2, -4			;storage counter < 4?
		BRn AGAIN				;if yes, GETC
		
;
;
;end character check loop 1
			
			
					
Skip 	AND R0, R0, 0				;input character
		AND R1, R1, 0 				;negative character checks & nzp check
		AND R2, R2, 0				;digit counter, only initialzed once every program run (every 4 digits)
		AND R4, R4, 0				
		AND R5, R5, 0
		AND R6, R6, 0
		AND R7, R7, 0				;Do Not Use


AGAIN2	AND R3, R3, 0				;character check counter (CCC), must be initialzed after every digit
		LEA R1, Inputs				;Load Digit
		ADD R1, R1, R2
		LDR R0, R1, 0				;via digit counter



;begin character check loop 2
;	-checks what the current loaded digit is, and jumps to respective branch

AGAIN1 	NOT R1, R3					;negate CCC
		ADD R1, R1, 1

		ADD R1, R0, R1				;is Digit = CCC ?
		BRz DONE
		
		ADD R3, R3, 1				;inc CCC by 1
		BRnp AGAIN1
		
DONE 	LEA R1, Charlist			;jump to branch
		ADD R1, R1, R3				;via CCC
		JMP R1
		
;
;end charachter check loop 2


;list of characters
;	-Branch for every character that is jumped to via character check counter

Charlist	BRnzp zero
			BRnzp one
			BRnzp two
			BRnzp three
			BRnzp four
			BRnzp five
			BRnzp six
			BRnzp seven
			BRnzp eight
			BRnzp nine
			BRnzp a
			BRnzp b
			BRnzp c
			BRnzp d
			BRnzp e
			BRnzp f
			BRnzp null

;
;list of characters


NextDig	ADD R2, R2, 1 			;inc digit counter by 1
		ADD R1, R2, 0			;digit counter = 4 ?
		ADD R1, R1, -4
		BRnp AGAIN2				;if no, repeat print process for next digit
		LEA R0, LineFeed	    ;if yes, start over
		PUTS
		BRnzp START


;Character Fills
;	-Encodes the color that each segment must be filled for said character

null	JSR BSegA			;this special character fill clears a character slot (sets it black)
		JSR BSegB				
		JSR BSegC				
		JSR BSegD
		JSR BSegE
		JSR BSegF
		JSR BSegG
		BRnzp NextDig
		
zero	JSR BSegG			;BSegA means Black Segment A
		JSR RSegA			;note that black segments must come first
		JSR RSegB			;to ensure no black overwrites red in a character
		JSR RSegC
		JSR RSegD
		JSR RSegE
		JSR RSegF
		BRnzp NextDig		;if all segments are filled, check for next digit
		
one 	JSR BSegA
		JSR BSegD
		JSR BSegE
		JSR BSegF
		JSR BSegG
		JSR RSegB
		JSR RSegC
		BRnzp NextDig
		
two		JSR BSegC
		JSR BSegF
		JSR RSegA
		JSR RSegB
		JSR RSegD
		JSR RSegE
		JSR RSegG
		BRnzp NextDig
		
three	JSR BSegE
		JSR BSegF
		JSR RSegA
		JSR RSegB
		JSR RSegC
		JSR RSegD
		JSR RSegG
		BRnzp NextDig
		
four	JSR BSegA
		JSR BSegD
		JSR BSegE
		JSR RSegB
		JSR RSegC
		JSR RSegF
		JSR RSegG
		BRnzp NextDig
		
five	JSR BSegB
		JSR BSegE
		JSR RSegA
		JSR RSegC
		JSR RSegD
		JSR RSegF
		JSR RSegG
		BRnzp NextDig
		
six		JSR BSegB
		JSR RSegA
		JSR RSegC
		JSR RSegD
		JSR RSegE
		JSR RSegF
		JSR RSegG
		BRnzp NextDig
		
seven	JSR BSegD
		JSR BSegE
		JSR BSegF
		JSR BSegG
		JSR RSegA
		JSR RSegB
		JSR RSegC
		BRnzp NextDig
		
eight	JSR RSegA
		JSR RSegB
		JSR RSegC
		JSR RSegD
		JSR RSegE
		JSR RSegF
		JSR RSegG
		BRnzp NextDig
		
nine	JSR BSegD
		JSR BSegE
		JSR RSegA
		JSR RSegB
		JSR RSegC
		JSR RSegF
		JSR RSegG
		BRnzp NextDig
		
a		JSR BSegD
		JSR RSegA
		JSR RSegB
		JSR RSegC
		JSR RSegE
		JSR RSegF
		JSR RSegG
		BRnzp NextDig
		
b		JSR BSegA
		JSR BSegB
		JSR RSegC
		JSR RSegD
		JSR RSegE
		JSR RSegF
		JSR RSegG
		BRnzp NextDig
		
c 		JSR BSegB
		JSR BSegG
		JSR BSegC
		JSR RSegA
		JSR RSegD
		JSR RSegE
		JSR RSegF
		BRnzp NextDig
		
d		JSR BSegA
		JSR BSegF
		JSR RSegB
		JSR RSegC
		JSR RSegD
		JSR RSegE
		JSR RSegG
		BRnzp NextDig
		
e		JSR BSegB
		JSR BSegC
		JSR RSegA
		JSR RSegD
		JSR RSegE
		JSR RSegF
		JSR RSegG
		BRnzp NextDig

f		JSR BSegB
		JSR BSegC
		JSR BSegD
		JSR RSegA
		JSR RSegE
		JSR RSegF
		JSR RSegG
		BRnzp NextDig
		
;
;Character Fills


;Segment Fills
;	-All the inputs needed for each segment for Segment Fill Loop

BSegA		LD R1,	ColorBlk		;Load Black Color
			BRnzp SegA

RSegA		LD R1, 	ColorRed		;Load Red Color
			BRnzp SegA

SegA		LD R0, 	CoordA			;Load Coordinate for this segment
			LD R3,	HrzRowNum		;Load number of rows for this segment
			LD R4,	HrzRowLen		;Load number of pixels in row for this segment
			LEA R5, ShiftLoop		;jump to horizontal shift loop
			JMP R5
			
			
BSegB		LD R1,	ColorBlk		;Load Black Color
			BRnzp SegB

RSegB		LD R1, 	ColorRed		;Load Red Color
			BRnzp SegB

SegB		LD R0, 	CoordB			
			LD R3,	VerRowNum
			LD R4,	VerRowLen
			LEA R5, ShiftLoop
			JMP R5
			
			
BSegC		LD R1,	ColorBlk		;Load Black Color
			BRnzp SegC

RSegC		LD R1, 	ColorRed		;Load Red Color
			BRnzp SegC

SegC		LD R0, 	CoordC			
			LD R3,	VerRowNum
			LD R4,	VerRowLen
			LEA R5, ShiftLoop
			JMP R5
			
			
BSegD		LD R1,	ColorBlk		;Load Black Color
			BRnzp SegD

RSegD		LD R1, 	ColorRed		;Load Red Color
			BRnzp SegD

SegD		LD R0, 	CoordD			
			LD R3,	HrzRowNum
			LD R4,	HrzRowLen
			LEA R5, ShiftLoop
			JMP R5
			
			
BSegE		LD R1,	ColorBlk		;Load Black Color
			BRnzp SegE

RSegE		LD R1, 	ColorRed		;Load Red Color
			BRnzp SegE

SegE		LD R0, 	CoordE			
			LD R3,	VerRowNum
			LD R4,	VerRowLen
			LEA R5, ShiftLoop
			JMP R5
			
			
BSegF		LD R1,	ColorBlk		;Load Black Color
			BRnzp SegF

RSegF		LD R1, 	ColorRed		;Load Red Color
			BRnzp SegF

SegF		LD R0, 	CoordF			
			LD R3,	VerRowNum
			LD R4,	VerRowLen
			LEA R5, ShiftLoop
			JMP R5
			
			
BSegG		LD R1,	ColorBlk		;Load Black Color
			BRnzp SegG

RSegG		LD R1, 	ColorRed		;Load Red Color
			BRnzp SegG

SegG		LD R0, 	CoordG			
			LD R3,	HrzRowNum
			LD R4,	HrzRowLen
			LEA R5, ShiftLoop
			JMP R5
			
;
;Segment Fills


;Horizontal Shift Loop	
;	-Horizontally shifts starting coordinate based on digit counter

ShiftLoop	ADD R5, R2, 0			;copy digit counter to R5
Loop1		ADD R5, R5, 0			;is digit counter = 0 ?
			BRz	SegFill				;if yes, start printing
			
			LD R6, twentyfive		;if no, add 25 to initial Coordinate
			ADD R0, R0, R6			
			
			ADD R5, R5, -1			;dec digit counter by 1
			BRnzp Loop1 			;loop
			
;
;Horizontal Shift Loop
	
	
	
;Segment Fill Loop
;	-Function for printing based on inputs
;		-Inputs: R0: initial Coord,	R1:	Color,  R3: Number of Rows,	R4:	Pixels in Row

SegClear	LD R0, ClearCoord					;I do not get the error message when setting pixels in my fill
			AND R1, R1, 0						;function, but I do from here. I've tried many different 
			LD R3, TotalRows					;possible inputs to be loaded in, even ones that other segments
			LD R4, MaxRowLen					;use, and I still get an error.
		
									
			
SegFill		ADD R6, R4, 0			;init row length counter by copying to R6
print		STR R1, R0, 0			;print pixel at coord
			
				ADD R5, R6, 0			;is row length = 0 ?
				BRz	NewRow
			
				ADD R0, R0, 1			;if no, inc coord by 1
				ADD R6, R6, -1			;dec row length by 1
				BRnzp print				;print pixel at coord

NewRow		ADD R5, R3, 0			;is row number = 0 ?
			BRz DONE1
			
				LD R5, ROW				;if no, inc coord by 128
				ADD R0, R0, R5			
				
				NOT R6, R4				;dec coord by row length
				ADD R6, R6, 1				
				ADD R0, R0, R6			
				
				ADD R3, R3, -1			;dec row number by 1
				BRnzp SegFill				
				
DONE1		RET

;
;
;Segment Fill Loop

		

HALT	

twentyfive		.FILL		x0019		;#25
ClearCoord		.FILL		xC000
TotalRows		.FILL		#124
MaxRowLen		.FILL		#128
CoordA			.FILL		xCE13
CoordB			.FILL		xCF1C
CoordC			.FILL		xD71C
CoordD			.FILL		xDD13
CoordE			.FILL		xD710
CoordF			.FILL		xCF10
CoordG			.FILL		xD593
ColorRed		.FILL		x7C00
ColorBlk		.FILL		x0000
HrzRowLen		.FILL		x000A
HrzRowNum		.FILL		x0005
VerRowLen		.FILL		x0004
VerRowNum		.FILL		x000E
Row				.FILL		#128	