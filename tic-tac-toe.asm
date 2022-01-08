TITLE Final Project
;Author - Majed Salah
;NAME OF ARRAY WITH LETTERS = playBoard
;Description - Plays either a pvpvp tic - tac - toe game or a cvcvc

Include Irvine32.inc 

PlayerMode PROTO twoArray:PTR DWORD, character:BYTE
chooseOrder PROTO runNumber:PTR DWORD, pass:PTR DWORD
checkRowsandDiagonals PROTO array:PTR DWORD, letter:BYTE, xScore:PTR DWORD
checkColumns PROTO letter:PTR DWORD, tArray:PTR DWORD, xScore:PTR DWORD
computerTurn PROTO letter:PTR DWORD, array:PTR DWORD
theWinner PROTO score1:PTR DWORD, score2:PTR DWORD, score3:PTR DWORD, mode:PTR DWORD, p1:PTR DWORD, p2:PTR DWORD, p3:PTR DWORD, c1:PTR DWORD, c2:PTR DWORD, c3:PTR DWORD, barr:PTR DWORD
resetBoard PROTO ar:PTR DWORD


.data
newline TEXTEQU <0Ah, 0Dh>

StartMsg BYTE "CHOOSE FROM THE FOLLOWING", newline, newline, 0
Msg1 BYTE "1. Play the game of Tic-Tac-Toe. More options inside.", newline, 0
Msg2 BYTE "2. Scoreboard.", newline, 0
Msg3 BYTE "3. Exit.", newline, 0
ErrorMsg BYTE "You entered an invalid choice. Try again.", newline, 0
p1Score BYTE "Player 1 Score (X): ", 0
p2Score BYTE "Player 2 Score (Y): ", 0
p3Score BYTE "Player 3 Score (Z): ", 0
c1Score BYTE "Computer 1 Score (X): ", 0
c2Score BYTE "Computer 2 Score (Y): ", 0
c3Score BYTE "Computer 3 Score (Z): ", 0
p1TotalCount BYTE "Player 1 Wins: ", 0
p2TotalCount BYTE "Player 2 Wins: ", 0
p3TotalCount BYTE "Player 3 Wins: ", 0
c1TotalCount BYTE "Computer 1 Wins: ", 0
c2TotalCount BYTE "Computer 2 Wins: ", 0
c3TotalCount BYTE "Computer 3 Wins: ", 0

playBoard BYTE 6 DUP(0) ;declares 6 x 6 grid where game will be played
		  BYTE 6 DUP(0)
		  BYTE 6 DUP(0)
		  BYTE 6 DUP(0)
		  BYTE 6 DUP(0)
		  BYTE 6 DUP(0)

gameRunLoop BYTE 12

xChar BYTE 58h
yChar BYTE 59h
zChar BYTE 5Ah

player1Score BYTE ?
player2Score BYTE ?
player3Score BYTE ?

gMode BYTE ? ;chooses game mode for proc (computer or player)

p1Wins BYTE 0
p2Wins BYTE 0
p3Wins BYTE 0

c1Wins BYTE 0
c2Wins BYTE 0
c3Wins BYTE 0

.code
main PROC

call randomize ;used for random order of players later

starthere:

mov edx, OFFSET StartMsg ;choose from following message
call WriteString

mov edx, OFFSET Msg1 ;playgame message
call WriteString
mov edx, OFFSET Msg2 ;scoreboard message
call WriteString
mov edx, OFFSET Msg3 ;exit message
call WriteString

call ReadDec ;reads choice of user for what they want to do

opt1:
cmp eax, 1 ;if user option is 1, player mode is chosen
jne opt2
call chooseMode ;whether they want to play player mode or computer mode

cmp eax, 1 ;if user chooses player mode
jne computer
invoke chooseOrder, ADDR gameRunLoop, ADDR playBoard

call crlf

invoke checkRowsAndDiagonals, ADDR playBoard, xChar, ADDR player1Score
invoke checkColumns, ADDR xChar, ADDR playBoard, ADDR player1Score

mov edx, OFFSET p1Score
call WriteString
mov al, player1Score ;prints player 1 score
call WriteDec
call crlf

invoke checkRowsAndDiagonals, ADDR playBoard, yChar, ADDR player2Score
invoke checkColumns, ADDR yChar, ADDR playBoard, ADDR player2Score

mov edx, OFFSET p2Score
call WriteString ;prints player 2 score
mov al, player2Score
call WriteDec
call crlf

invoke checkRowsAndDiagonals, ADDR playBoard, zChar, ADDR player3Score
invoke checkColumns, ADDR zChar, ADDR playBoard, ADDR player3Score

mov edx, OFFSET p3Score ;prints player 3 score
call WriteString
mov al, player3Score
call WriteDec
call crlf

mov gMode, 0 ;since gamemode is player

invoke theWinner, ADDR player1Score, ADDR player2Score, ADDR player3Score, ADDR gMode, ADDR p1Wins, ADDR p2Wins, ADDR p3Wins, ADDR c1Wins, ADDR c2Wins, ADDR c3Wins, ADDR playBoard ;decided winner based on scores calculated
invoke resetBoard, ADDR playBoard ;fills array with nulls

call waitmsg
call clrscr
jmp starthere
computer:
mov ecx, 12 ;3 turns before 1 loop, 36 turns total to fill grid

compLoop:
push ecx
invoke computerTurn, ADDR xChar, ADDR playBoard
invoke computerTurn, ADDR yChar, ADDR playBoard
invoke computerTurn, ADDR zChar, ADDR playBoard
pop ecx
loop compLoop

mov eax, 0
invoke checkRowsAndDiagonals, ADDR playBoard, xChar, ADDR player1Score
invoke checkColumns, ADDR xChar, ADDR playBoard, ADDR player1Score

mov edx, OFFSET c1Score
call WriteString
mov al, player1Score
call WriteDec
call crlf

invoke checkRowsAndDiagonals, ADDR playBoard, yChar, ADDR player2Score
invoke checkColumns, ADDR yChar, ADDR playBoard, ADDR player2Score

mov edx, OFFSET c2Score
call WriteString
mov al, player2Score
call WriteDec
call crlf

invoke checkRowsAndDiagonals, ADDR playBoard, zChar, ADDR player3Score
invoke checkColumns, ADDR zChar, ADDR playBoard, ADDR player3Score

mov edx, OFFSET c3Score
call WriteString
mov al, player3Score
call WriteDec
call crlf
mov gMode, 1
invoke theWinner, ADDR player1Score, ADDR player2Score, ADDR player3Score, ADDR gMode, ADDR p1Wins, ADDR p2Wins, ADDR p3Wins, ADDR c1Wins, ADDR c2Wins, ADDR c3Wins, ADDR playBoard ;all scores passed so that winner is incremented
call waitmsg ;so that user can see results
call clrscr
invoke resetBoard, ADDR playBoard
jmp starthere ;jumps back to beginning

opt2:
cmp eax, 2
jne opt3
mov eax, 0
mov edx, OFFSET p1TotalCount ;prints out player 1 record
call WriteString
mov al, p1Wins
call WriteDec
call crlf
mov edx, OFFSET p2TotalCount ;prints out player 2 record
call WriteString
mov al, p2Wins
call WriteDec
call crlf
mov edx, OFFSET p3TotalCount ;prints out player 3 record
call WriteString
mov al, p3Wins
call WriteDec
call crlf
mov edx, OFFSET c1TotalCount ;prints out computer 1 record
call WriteString
mov al, c1Wins
call WriteDec
call crlf
mov edx, OFFSET c2TotalCount ;prints out computer 2 record
call WriteString
mov al, c2Wins
call WriteDec
call crlf
mov edx, OFFSET c3TotalCount ;prints out computer 3 record
call WriteString
mov al, c3Wins
call WriteDec
call crlf
call waitmsg ;wait message so that results can be seen
call clrscr

jmp starthere

opt3:
cmp eax, 3 ;checks if option chosen is 3
jne err
exit ;exits program

exit

err:
mov edx, OFFSET ErrorMsg ;prints message saying number is not in rnage of choices
call WriteString
call waitMsg
call ClrScr
jmp starthere

exit
main ENDP






;---------------------------------------------------------------------------------------
printGrid PROC
;Receives - Nothing
;Returns - Nothing
;Function - Prints out tic tac toe board

.data
topOfBoard BYTE 0C9h, 3 DUP(0CDh), 0D1h, 3 DUP(0CDh), 0D1h, 3 DUP(0CDh), 0D1h, 3 DUP(0CDh), 0D1h, 3 DUP(0CDh), 0D1h, 3 DUP(0CDh), 0BBh, newline, 0
	row2 BYTE 0BAh, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0BAh, newline, 0
	row3 BYTE 0C7h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0B6h, newline, 0
	row4 BYTE 0BAh, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0BAh, newline, 0
	row5 BYTE 0C7h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0B6h, newline, 0
	row6 BYTE 0BAh, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0BAh, newline, 0
	row7 BYTE 0C7h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0B6h, newline, 0
	row8 BYTE 0BAh, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0BAh, newline, 0
	row9 BYTE 0C7h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0B6h, newline, 0
	row10 BYTE 0BAh, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0BAh, newline, 0
	row11 BYTE 0C7h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0C5h, 3 DUP(0C4h), 0B6h, newline, 0
	row12 BYTE 0BAh, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0B3h, "   ", 0BAh, newline, 0
	row13 BYTE 0C8h, 3 DUP(0CDh), 207, 3 DUP(0CDh), 207, 3 DUP(0CDh), 207, 3 DUP(0CDh), 207, 3 DUP(0CDh), 207, 3 DUP(0CDh), 0BCh, newline, 0

	.code

mov dl, 50
mov dh, 10
call goToXY

mov edx, OFFSET topOfBoard ;none of the strings above are null terminated so that one call prints whole board
call WriteString
mov dh, 11
mov dl, 50
call goToXY
mov edx, OFFSET row2 ;second row of board
call WriteString
mov dh, 12
mov dl, 50
call goToXY
mov edx, OFFSET row3 ;third row of board
call WriteString
mov dh, 13
mov dl, 50
call goToXY
mov edx, OFFSET row4 ;fourth row of board
call WriteString
mov dh, 14
mov dl, 50
call goToXY
mov edx, OFFSET row5 ;fifth row of board
call WriteString
mov dh, 15
mov dl, 50
call goToXY
mov edx, OFFSET row6 ;sixth row of board
call WriteString
mov dh, 16
mov dl, 50
call goToXY
mov edx, OFFSET row7 ;seventh row of board
call WriteString
mov dh, 17
mov dl, 50
call goToXY
mov edx, OFFSET row8 ;eigth row of board
call WriteString
mov dh, 18
mov dl, 50
call goToXY
mov edx, OFFSET row9 ;ninth row of baord
call WriteString
mov dh, 19
mov dl, 50
call goToXY
mov edx, OFFSET row10 ;tenth row of board
call WriteString
mov dh, 20
mov dl, 50
call goToXY
mov edx, OFFSET row11 ;eleventh row of board
call WriteString
mov dh, 21
mov dl, 50
call goToXY
mov edx, OFFSET row12 ;twelth row of board
call WriteString
mov dh, 22
mov dl, 50
call goToXY
mov edx, OFFSET row13 ;thirteenth row of board
call WriteString

ret
printGrid ENDP

;---------------------------------------------------------------------------------------






;---------------------------------------------------------------------------------------
chooseMode PROC
;Receives - Nothing
;Returns - user choice in eax
;Function - asks user what mode they want and returns choice

.data

pickOne BYTE "Which of the following would you like to do?", newline ,newline, 0
PMode BYTE "1. Play locally against 2 other players.", newline, 0
CMode BYTE "2. Watch a match against 3 computers.", newline, 0
note BYTE "NOTE: FOR #2, DUE TO COMPUTER RANDOM PICKS MORE TIME MAY BE NEEDED ESPECIALLY AS GRID FILLS UP. 1 SEC DELAY IS MINIMUM", newline, 0
invalidMode BYTE "You did not enter a valid option. Try again.", newline, 0

.code

call ClrScr

choosehere:
mov edx, OFFSET pickOne ;prints message for user to pick option
call WriteString
mov edx, OFFSET PMode ;prints message for PVPVP
call WriteString
mov edx, OFFSET CMode ;prints message for CVCVC
call WriteString
mov edx, OFFSET note ;prints time message for number 2
call WriteString

call ReadDec ;number that user enters for choice

cmp eax, 1 ;sees if user put 1
jne another
jmp endOfChoice ;if one, returns to main

another:
cmp eax, 2 ;sees if user put 2
jne invalid
jmp endOfChoice ;if two, returns to main

invalid:
mov edx, OFFSET invalidMode ;error message, invalid input
call WriteString
call WaitMsg
call ClrScr
jmp choosehere ;jumps back to beginning of PROC so that user can choose again

endOfChoice:

ret
chooseMode ENDP
;---------------------------------------------------------------------------------------






;---------------------------------------------------------------------------------------
PlayerMode PROC, twoArray:PTR DWORD, character:BYTE
LOCAL xVal:BYTE, yVal:BYTE, passed:DWORD, choice:BYTE
;Receives - array address for letters, character for player symbol
;Returns - Nothing, but array is filled and letters are printed in spot on board
;Function - reads character of player and fills array accordingly

fillArray PROTO, filledArray:PTR DWORD

.data

player1 BYTE "Player 1: Choose a row to enter your character (1-6).", newline, 0
player1Column BYTE "Player 1: Choose a column to enter your character (1-6).", newline, 0
player2 BYTE "Player 2: Choose a row to enter your character (1-6).", newline, 0
player2Column BYTE "Player 2: Choose a column to enter your character (1-6).", newline, 0
player3 BYTE "Player 3: Choose a row to enter your character (1-6).", newline, 0
player3Column BYTE "Player 3: Choose a column to enter your character (1-6).", newline, 0
notInRange BYTE "Try again. Enter a number in range (1-6). Or, check to see if a letter is already in that position.", newline, 0

.code
mov cl, character
mov choice, cl ;choice variable holds passed letter

mov esi, twoArray
mov passed, esi

mov ecx, 6 ;sets 6 based on 6x6 grid

call ClrScr ;clears screen from original choices

player1Turn:
call printGrid ;prints out game board
invoke fillArray, passed
mov esi, passed
mov dh, 0 ;adjusts cursor back to beginning after grid is printed
mov dl, 0
call goToXY ;goes to beginning to print out messages

cmp choice, 058h ;if letter passed is X
jne p2
mov edx, OFFSET player1 ;prints message to player 1
call WriteString
jmp enter1

p2:
cmp choice, 059h
jne p3
mov edx, OFFSET player2
call WriteString
jmp enter1

p3:
mov edx, OFFSET player3 ;prints out message to enter row number
call WriteString

enter1:
call ReadDec ;reads user option for y axis

cmp eax, 6 ;error checking for over 6
ja again
cmp eax, 0 ;error checking for 0 or less
jbe again

mov bl, al ;moves row value to bl since it will go to another procedure soon
dec bl
mov yVal, bl

pc1:
cmp choice, 058h ;choice for if X
jne pc2
mov edx, OFFSET player1Column ;prints out message to fill in column
call WriteString
jmp enter2

pc2:
cmp choice, 059h ;choice for is Y
jne pc3
mov edx, OFFSET player2Column ;prints same message but to player 2
call WriteString
jmp enter2

pc3:
mov edx, OFFSET player3Column ;same message but for player 3
call WriteString

enter2:
call ReadDec ;reads column number from player

cmp eax, 6 ;error checking for over 6
ja again
cmp eax, 0 ;error checking for 0 or less
jbe again

mov bh, al ;moves column value to bh since it will go into another procedure soon
dec bh
mov xVal, bh

mov eax, 0
mov edx, 0
mov al, 6 ;since it will be multiplied, is 6 to set condition
mov dl, bl

mul dx ;accesses row of table by multiplying 6 by user row choice
mov dl, bh
add eax, edx ;adds column number
mov dl, choice
mov bh, 0
cmp [esi + eax], bh
jne again
mov [esi + eax], dl ;moves value of bh into array position
mov bl, dl

invoke fillArray, passed
jmp finished

again:
mov edx, OFFSET notInRange ;prints error message to user to put number from 1 - 6
call WriteString
call WaitMsg
call ClrScr
jmp player1Turn ;returns player to enter number again

finished:

call crlf
call crlf
call WaitMsg ;prints wait message so that user can see board before next player goes

ret
PlayerMode ENDP
;---------------------------------------------------------------------------------------





;---------------------------------------------------------------------------------------
fillArray PROC, filledArray:PTR DWORD
;Receives - address of array
;Returns - Nothing, but letter in array and printed in grid correctly
;Function - prints letter in tic tac toe board
.data


.code
push edx ;preserves registers since goes back to another procedure
push eax
push ecx
push ebx

mov esi, filledArray ; esi holds array

mov ecx, 36
mov eax, 0 ;getting ready since it will hold offset
mov ebx, 0 ;counter for column

mov dl, 48 ;offset that points to first square in grid
mov dh, 11 ;y coord offset

L3:
cmp ebx, 6
jne cont
add eax, 6 ;row offset count
mov ebx, 0
mov dl, 48 ;adds offset so that x and y coords are in line with tic tac toe board
add dh, 2

cont:
add esi, eax ;adds offset so that array is correctly accessed
add dl, 4
call goToXY ;goes to set offset above
mov al, [esi + ebx] ;grabs character from 2d array
call WriteChar ;prints character 
mov eax, 0

inc bl

loop L3


pop ebx
pop ecx ;bringing back values of registers
pop eax
pop edx
ret
fillArray ENDP
;---------------------------------------------------------------------------------------







;---------------------------------------------------------------------------------------
placeLetter PROC, xVal:BYTE, yVal:BYTE, array:PTR DWORD 

mul dx ;accesses row of table by multiplying 6 by user row choice
mov dl, bh
add eax, edx ;adds column number
mov edx, 058h
mov [esi + eax], dl ;moves value of bh into array position
mov bl, dl

ret
placeLetter ENDP
;---------------------------------------------------------------------------------------








;---------------------------------------------------------------------------------------
chooseOrder PROC, runNumber:PTR DWORD, pass:PTR DWORD
LOCAL array:PTR DWORD, xCh:BYTE, yCh:BYTE, zCh:BYTE
;Recieves - array offset
;Returns - Nothing, but code is run and player turns are random
;Function - runs player turn based on random order

mov xCh, 058h ;ascii for X
mov yCh, 059h ;ascii for Y
mov zCh, 05Ah ;ascii for Z

mov ecx, 4 ;3 turns, 12 loops = 36 turns total

mov esi, pass
mov array, esi

mov eax, 6 ;range = 0-5
call randomrange ;gets random number

order1:			;this is the first possible order for the game
cmp eax, 0
jne order2
L5:

push ecx ;in case ecx is changed in procs
invoke PlayerMode, array, xCh
invoke PlayerMode, array, yCh ;order 1, p1, p2, p3
invoke PlayerMode, array, zCh
pop ecx

loop L5
jmp orderDone ;jumps if program already run

order2:
cmp eax, 1
jne order3

L6:
push ecx ;in case ecx is changed in procs
invoke PlayerMode, array, xCh
invoke PlayerMode, array, zCh ;p1, p3, p2
invoke PlayerMode, array, yCh
pop ecx
loop L6
jmp orderDone ;jumps if program already run

order3:
cmp eax, 2
jne order4
L7:
push ecx ;in case ecx is changed in procs
invoke PlayerMode, array, yCh
invoke PlayerMode, array, xCh ;p2, p1, p3
invoke PlayerMode, array, zCh
pop ecx
loop L7
jmp orderDone ;jumps if program already run

order4:
cmp eax, 3
jne order5
L8:
push ecx ;in case ecx is changed in procs
invoke PlayerMode, array, yCh
invoke PlayerMode, array, zCh ;p2, p3, p1
invoke PlayerMode, array, xCh
pop ecx
loop L8
jmp orderDone ;jumps if program already run

order5:
cmp eax, 4
jne order6
L9:
push ecx ;in case ecx is changed in procs
invoke PlayerMode, array, zCh
invoke PlayerMode, array, yCh ;p3, p2, p1
invoke PlayerMode, array, xCh
pop ecx
loop L9
jmp orderDone ;jumps if program already run

order6:
L10:
push ecx ;in case ecx is changed in procs
invoke PlayerMode, array, zCh
invoke PlayerMode, array, xCh ;p3, p1, p2
invoke PlayerMode, array, yCh
pop ecx
loop L10


orderDone:

ret
chooseOrder ENDP
;---------------------------------------------------------------------------------------






;---------------------------------------------------------------------------------------
printGrid2 PROC
;Receives - Nothing
;Returns - Nothing, but grid is printed (This one was made using writechar instead, one being used when running code is above)
;Function - prints tic tac toe grid

topOfGB:
mov ebx, 0
mov ecx, 23

mov al, 0C9h
call WriteChar

L15:
cmp ebx, 3
je instead
mov al, 0CDh
call WriteChar
jmp look
instead:
mov al, 0D1h
call WriteChar
mov ebx, 0
jmp otherwise

look:
inc ebx
otherwise:

loop L15

mov ebx, 0
mov ecx, 23

mov al, 0BBh
call WriteChar
call crlf

mov al, 0BAh
call WriteChar
mov ecx, 5

L18:
push ecx
mov ecx, 23
L16:

cmp ebx, 3
je bar
mov al, 20h
call WriteChar
jmp increment
bar:
mov al, 0B3h
call WriteChar
mov ebx, 0
jmp leaveAlone

increment:
inc ebx
leaveAlone:

loop L16

call crlf
mov al, 0C7h
call WriteChar
mov ecx, 23
mov ebx, 0

L17:

cmp ebx, 3
je foo
mov al, 0C4h
call WriteChar
jmp complete
foo:
mov al, 0C5h
call WriteChar
mov ebx, 0
jmp stagnant

complete:
inc ebx
stagnant:

loop L17

call crlf
mov al, 0BAh
call WriteChar
mov ebx, 0

pop ecx

loop L18

ret
printGrid2 ENDP
;---------------------------------------------------------------------------------------






;---------------------------------------------------------------------------------------
checkRowsAndDiagonals PROC, array:PTR DWORD, letter:BYTE, xScore:PTR DWORD
LOCAL max:BYTE, score:BYTE
;Receives - array offset, letter that represents player, total matches score offset
;Returns - Total number of 3 in a row for rows and diagonals
;Function - counts 3 in a rows for rows and diagonals

mov score, 0 ;resets so that there is no baggage
mov max, 0

mov esi, array ;holds address of array

mov eax, 6 ;will be used to increment through rows of arrays
mov ebx, 0
mov ecx, 0  ;clearing the registers
mov edx, 0
mov edi, 0

mul dl ;sets row number by multiplying 6 in eax
mov bl, letter ;holds character that is to be checked

;--------------------------------CODE SECTION FOR ROW 1----------------------------------
mov ecx, 6 ;sets loop count since grid is 6 x 6
add edi, eax ;adds row offset based on eax after multiplying
row1:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl
inc edx ;increases edx, temp count for max cocurrent letter
cmp dl, max
jb finish
mov max, dl ;moves number to max variable, continues to get updated while loop is running and finding concurrent letters
jmp finish ;jumps to end of loop since edx count should remain
endofl:
mov edx, 0 ;sets count to zero if non target letter found
finish:
inc edi ;increases column count to check next letter

loop row1

cmp max, 3
jb next
sub max, 2 ;checks if there was a 3 in a row, subtracts 2 from it and adds it to total score
mov dl, max
add score, dl

next:
mov ecx, 6
mov eax, 6
mov edi, 0 ;reseting registers so that next loop can be executed
mov dl, 1
mul dl
add edi, eax
mov edx, 0

;--------------------------CODE SECTION FOR ROW 2------------------------------
Level2:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl2
inc edx
cmp dl, max
jb finish2
mov max, dl
jmp finish2						;same code as row 1 code
endofl2:
mov edx, 0
finish2:
inc edi

loop Level2

cmp max, 3
jb next2
sub max, 2 ;same as above but with row 2
mov dl, max
add score, dl

next2:
mov ecx, 6
mov eax, 6
mov edi, 0 ;reseting of registers again
mov dl, 2
mul dl
add edi, eax
mov edx, 0

;-------------------------CODE SECTION FOR ROW 3-----------------------------
Level3:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl3
inc edx
cmp dl, max
jb finish3
mov max, dl
jmp finish3						;same code as row 2 code
endofl3:
mov edx, 0
finish3:
inc edi

loop Level3

cmp max, 3
jb next3
sub max, 2
mov dl, max
add score, dl

next3:
mov ecx, 6
mov eax, 6
mov edi, 0 ;reseting of registers again
mov dl, 3
mul dl
add edi, eax
mov edx, 0

;-------------------------CODE SECTION FOR ROW 4----------------------------
Level4:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl4
inc edx
cmp dl, max
jb finish4
mov max, dl
jmp finish4					;same code as row 3 code
endofl4:
mov edx, 0
finish4:
inc edi

loop Level4

cmp max, 3
jb next4
sub max, 2
mov dl, max
add score, dl

next4:
mov ecx, 6
mov eax, 6
mov edi, 0 ;reseting of registers again
mov dl, 4
mul dl
add edi, eax
mov edx, 0

;----------------CODE SECTION FOR ROW 5----------------------------
Level5:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl5
inc edx
cmp dl, max
jb finish5
mov max, dl
jmp finish5					;same code as row 4 code
endofl5:
mov edx, 0
finish5:
inc edi

loop Level5

cmp max, 3
jb next5
sub max, 2
mov dl, max
add score, dl

next5:
mov ecx, 6
mov eax, 6
mov edi, 0 ;reseting of registers again
mov dl, 5
mul dl
add edi, eax
mov edx, 0

;--------------------------CODE SECTION FOR ROW 6--------------------------
Level6:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl6
inc edx
cmp dl, max
jb finish6
mov max, dl
jmp finish6					;same code as row 5 code
endofl6:
mov edx, 0
finish6:
inc edi

loop Level6

cmp max, 3
jb next6
sub max, 2
mov dl, max
add score, dl

next6:
mov ecx, 3
mov eax, 6
mov edi, 3 ;reseting of registers again, edi is 3 since starting from near edge position
mov edx, 0

;------------------CODE SECTION FOR DIAGONAL 1------------------------------------
Diagonal1:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl7
inc edx
cmp dl, max
jb finish7
mov max, dl
jmp finish7				;same code as row 6 code
endofl7:
mov edx, 0
finish7:
inc edi
add edi, 6

loop Diagonal1

cmp max, 3
jb next7
sub max, 2
mov dl, max
add score, dl

next7:
mov ecx, 4
mov eax, 6
mov edi, 2 ;reseting of registers again
mov edx, 0

;------------------CODE SECTION FOR DIAGONAL 2------------------------------------

Diagonal2:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl8
inc edx
cmp dl, max
jb finish8
mov max, dl
jmp finish8			;same code as diagonal 1
endofl8:
mov edx, 0
finish8:
inc edi
add edi, 6

loop Diagonal2

cmp max, 3
jb next8
sub max, 2
mov dl, max
add score, dl

next8:
mov ecx, 5
mov eax, 6
mov edi, 1 ;reseting of registers again
mov edx, 0

;------------------CODE SECTION FOR DIAGONAL 3------------------------------------

Diagonal3:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl9
inc edx
cmp dl, max
jb finish9
mov max, dl
jmp finish9		;same code as diagonal 2 code
endofl9:
mov edx, 0
finish9:
inc edi
add edi, 6

loop Diagonal3

cmp max, 3
jb next9
sub max, 2
mov dl, max
add score, dl

next9:
mov ecx, 6
mov eax, 6
mov edi, 0 ;reseting of registers again
mov edx, 0

;------------------CODE SECTION FOR DIAGONAL 4------------------------------------

Diagonal4:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl10
inc edx
cmp dl, max
jb finish10
mov max, dl
jmp finish10	;same code as diagonal 3
endofl10:
mov edx, 0
finish10:
inc edi
add edi, 6

loop Diagonal4

cmp max, 3
jb next10
sub max, 2
mov dl, max
add score, dl

next10:
mov ecx, 5
mov eax, 6
mov edi, 0 ;reseting of registers again
mov edx, 0
add edi, eax

;------------------CODE SECTION FOR DIAGONAL 5------------------------------------

Diagonal5:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl11
inc edx
cmp dl, max
jb finish11
mov max, dl
jmp finish11	;same code as diagonal 4
endofl11:
mov edx, 0
finish11:
inc edi
add edi, 6


loop Diagonal5

cmp max, 3
jb next11
sub max, 2
mov dl, max
add score, dl

next11:
mov ecx, 4
mov eax, 6
mov edi, 0 ;reseting of registers again
mov dl, 2
mul dl
mov edx, 0
add edi, eax

;------------------CODE SECTION FOR DIAGONAL 6------------------------------------

Diagonal6:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl12
inc edx
cmp dl, max
jb finish12
mov max, dl
jmp finish12	;same code as diagonal 5
endofl12:
mov edx, 0
finish12:
inc edi
add edi, 6


loop Diagonal6

cmp max, 3
jb next12
sub max, 2
mov dl, max
add score, dl

next12:
mov ecx, 3
mov eax, 6
mov edi, 0 ;reseting of registers again
mov dl, 3
mul dl
mov edx, 0
add edi, eax

;------------------CODE SECTION FOR DIAGONAL 7------------------------------------

Diagonal7:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl13
inc edx
cmp dl, max
jb finish13
mov max, dl
jmp finish13	;same code as diagonal 6
endofl13:
mov edx, 0
finish13:
inc edi
add edi, 6


loop Diagonal7

cmp max, 3
jb next13
sub max, 2
mov dl, max
add score, dl

next13:
mov ecx, 3
mov eax, 6
mov edi, 2 ;reseting of registers again
mov edx, 0

;------------------CODE SECTION FOR DIAGONAL 8------------------------------------

Diagonal8:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl30
inc edx
cmp dl, max
jb finish30
mov max, dl
jmp finish30			;same code as diagonal 7
endofl30:
mov edx, 0
finish30:
dec edi
add edi, 6

loop Diagonal8

cmp max, 3
jb next14
sub max, 2
mov dl, max
add score, dl

next14:
mov ecx, 4
mov eax, 6
mov edi, 3 ;reseting of registers again
mov edx, 0

;------------------CODE SECTION FOR DIAGONAL 9------------------------------------

Diagonal9:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl31
inc edx
cmp dl, max
jb finish31
mov max, dl
jmp finish31		;same code as diagonal 8
endofl31:
mov edx, 0
finish31:
dec edi
add edi, 6

loop Diagonal9

cmp max, 3
jb next15
sub max, 2
mov dl, max
add score, dl

next15:
mov ecx, 5
mov eax, 6
mov edi, 4 ;reseting of registers again
mov edx, 0

;------------------CODE SECTION FOR DIAGONAL 10------------------------------------

Diagonal10:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl32
inc edx
cmp dl, max
jb finish32
mov max, dl
jmp finish32		;same code as diagonal 9
endofl32:
mov edx, 0
finish32:
dec edi
add edi, 6

loop Diagonal10

cmp max, 3
jb next16
sub max, 2
mov dl, max
add score, dl

next16:
mov ecx, 6
mov eax, 6
mov edi, 5 ;reseting of registers again
mov edx, 0

;------------------CODE SECTION FOR DIAGONAL 11------------------------------------

Diagonal11:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl33
inc edx
cmp dl, max
jb finish33
mov max, dl
jmp finish33	;same code as diagonal 10
endofl33:
mov edx, 0
finish33:
dec edi
add edi, 6

loop Diagonal11

cmp max, 3
jb next17
sub max, 2
mov dl, max
add score, dl

next17:
mov ecx, 5
mov eax, 6
mov edi, 5 ;reseting of registers again
mov edx, 0
add edi, eax

;------------------CODE SECTION FOR DIAGONAL 12------------------------------------

Diagonal12:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl34
inc edx
cmp dl, max
jb finish34
mov max, dl
jmp finish34	;same code as diagonal 11
endofl34:
mov edx, 0
finish34:
dec edi
add edi, 6


loop Diagonal12

cmp max, 3
jb next18
sub max, 2
mov dl, max
add score, dl

next18:
mov ecx, 4
mov eax, 6
mov edi, 5 ;reseting of registers again
mov dl, 2
mul dl
mov edx, 0
add edi, eax

;------------------CODE SECTION FOR DIAGONAL 13------------------------------------

Diagonal13:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl35
inc edx
cmp dl, max
jb finish35
mov max, dl
jmp finish35	;same code as diagonal 12
endofl35:
mov edx, 0
finish35:
dec edi
add edi, 6


loop Diagonal13

cmp max, 3
jb next19
sub max, 2
mov dl, max
add score, dl

next19:
mov ecx, 3
mov eax, 6
mov edi, 5 ;reseting of registers again
mov dl, 3
mul dl
mov edx, 0
add edi, eax

;------------------CODE SECTION FOR DIAGONAL 14------------------------------------

Diagonal14:

cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl36
inc edx
cmp dl, max
jb finish36
mov max, dl
jmp finish36	;same code as diagonal 13
endofl36:
mov edx, 0
finish36:
dec edi
add edi, 6


loop Diagonal14

cmp max, 3
jb next20
sub max, 2
mov dl, max
add score, dl

next20:
mov esi, xScore
mov al, score
mov [esi], al

ret
checkRowsAndDiagonals ENDP
;---------------------------------------------------------------------------------------






;---------------------------------------------------------------------------------------
checkColumns PROC, letter:PTR DWORD, tArray:PTR DWORD, xScore:PTR DWORD
LOCAL max:BYTE, score:BYTE, rowOffset:PTR DWORD
;Receives - letter offset for player, array offset, score offset
;Returns - column count 3 in a row
;Function - finds 3 in a rows from columns

mov rowOffset, 6 ;6x6 grid, add 6 to access new row of array

mov score, 0

mov esi, tArray ;esi holds offset of array

mov edi, letter
mov bh, [edi]

mov ecx, 6
mov eax, 6
mov edi, 0 ;reseting registers so that next loop can be executed
mov edx, 0

;----------------------CODE SECTION FOR COLUMN 1---------------------------------------

column1:
cmp [esi + edi], bh ;checks if letter being looked for is in array position
jne endofl20
inc edx ;increases edx, temp count for max cocurrent letter
cmp dl, max
jb finish20
mov max, dl ;moves number to max variable, continues to get updated while loop is running and finding concurrent letters
jmp finish20 ;jumps to end of loop since edx count should remain
endofl20:
mov edx, 0 ;sets count to zero if non target letter found
finish20:
add edi, rowOffset

loop column1

cmp max, 3
jb reset
sub max, 2
mov dl, max
add score, dl

reset:
mov ecx, 6
mov eax, 6
mov edi, 1 ;reseting registers so that next loop can be executed
mov edx, 0

;----------------------CODE SECTION FOR COLUMN 2---------------------------------------

column2:
cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl21
inc edx ;increases edx, temp count for max cocurrent letter
cmp dl, max
jb finish21
mov max, dl ;moves number to max variable, continues to get updated while loop is running and finding concurrent letters
jmp finish21 ;jumps to end of loop since edx count should remain
endofl21:
mov edx, 0 ;sets count to zero if non target letter found
finish21:
add edi, rowOffset

loop column2

cmp max, 3
jb reset2 ;finds 3 in a rows based on max count, subs to to get score, adds to total count
sub max, 2
mov dl, max
add score, dl

reset2:
mov ecx, 6
mov eax, 6
mov edi, 2 ;reseting registers so that next loop can be executed
mov edx, 0

;----------------------CODE SECTION FOR COLUMN 3---------------------------------------

column3:
cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl22
inc edx ;increases edx, temp count for max cocurrent letter
cmp dl, max
jb finish22
mov max, dl ;moves number to max variable, continues to get updated while loop is running and finding concurrent letters
jmp finish22 ;jumps to end of loop since edx count should remain
endofl22:
mov edx, 0 ;sets count to zero if non target letter found
finish22:
add edi, rowOffset ;adds 6 to access new row

loop column3

cmp max, 3
jb reset3 ;same as above
sub max, 2
mov dl, max
add score, dl

reset3:
mov ecx, 6
mov eax, 6
mov edi, 3 ;reseting registers so that next loop can be executed
mov edx, 0

;----------------------CODE SECTION FOR COLUMN 4---------------------------------------

column4:
cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl23
inc edx ;increases edx, temp count for max cocurrent letter
cmp dl, max
jb finish23
mov max, dl ;moves number to max variable, continues to get updated while loop is running and finding concurrent letters
jmp finish23 ;jumps to end of loop since edx count should remain
endofl23:
mov edx, 0 ;sets count to zero if non target letter found
finish23:
add edi, rowOffset ;adds 6 to access new row

loop column4

cmp max, 3
jb reset4
sub max, 2
mov dl, max
add score, dl

reset4:
mov ecx, 6
mov eax, 6
mov edi, 4 ;reseting registers so that next loop can be executed
mov edx, 0

;----------------------CODE SECTION FOR COLUMN 5---------------------------------------

column5:
cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl24
inc edx ;increases edx, temp count for max cocurrent letter
cmp dl, max
jb finish24
mov max, dl ;moves number to max variable, continues to get updated while loop is running and finding concurrent letters
jmp finish24 ;jumps to end of loop since edx count should remain
endofl24:
mov edx, 0 ;sets count to zero if non target letter found
finish24:
add edi, rowOffset ;adds 6 to access new row

loop column5

cmp max, 3
jb reset5 ;same as above
sub max, 2
mov dl, max
add score, dl

reset5:
mov ecx, 6
mov eax, 6
mov edi, 5 ;reseting registers so that next loop can be executed
mov edx, 0

;----------------------CODE SECTION FOR COLUMN 6---------------------------------------

column6:
cmp [esi + edi], bl ;checks if letter being looked for is in array position
jne endofl25
inc edx ;increases edx, temp count for max cocurrent letter
cmp dl, max
jb finish25
mov max, dl ;moves number to max variable, continues to get updated while loop is running and finding concurrent letters
jmp finish25 ;jumps to end of loop since edx count should remain
endofl25:
mov edx, 0 ;sets count to zero if non target letter found
finish25:
add edi, rowOffset ;adds 6 to access new row

loop column6

cmp max, 3
jb reset6
sub max, 2 ;same as above
mov dl, max
add score, dl

reset6:
mov edi, xScore
movzx eax, score
add [edi], eax

ret
checkColumns ENDP
;---------------------------------------------------------------------------------------






;---------------------------------------------------------------------------------------
computerTurn PROC, letter:PTR DWORD, array:PTR DWORD
LOCAL let:BYTE, passed:PTR DWORD
;Receives - letter for computer profile, offset of array
;Returns - Nothing, but letter is placed in array and printed accordingly on screen
;Function - prints array and spot on board

.data

computerPlayer1 BYTE "Computer 1 is taking its turn.", newline, 0
computerPlayer2 BYTE "Computer 2 is taking its turn.", newline, 0
computerPlayer3 BYTE "Computer 3 is taking its turn.", newline, 0

.code
mov esi, array ;moves offset of array to esi
mov passed, esi ;stores address in local dword variable
mov eax, letter ;holds letter since that decides who is going first
mov ebx, [eax] ;ebx holds letter
mov let, bl ;letter stored in local byte

mov ecx, 6

call ClrScr ;clears screen from original choices

player1Turn:
call printGrid ;prints out game board
invoke fillArray, passed
mov esi, passed
mov dh, 0 ;adjusts cursor back to beginning after grid is printed
mov dl, 0
call goToXY
cmp let, 058h ;checks if letter is x (computer 1)
jne statement2
mov edx, OFFSET computerPlayer1 ;prints message to player 1
call WriteString
jmp over
statement2:
cmp let, 059h ;checks if letter is y (computer 2)
jne statement3
mov edx, OFFSET computerPlayer2 ;prints message to player 1
call WriteString
jmp over
statement3:
mov edx, OFFSET computerPlayer3 ;prints message to player 1, means letter is z (computer 3)
call WriteString

over:
mov eax, 6 ;chooses random number between 0 and 5
call randomRange
mov bl, al ;uses random number as row count

mov eax, 6
call randomrange
mov bh, al ;uses random number as column count

mov eax, 0
mov al, 6 ;set to 6 since it needs to be multiplied to find row number
mov dl, bl

mul dl ;accesses row of table by multiplying 6 by user row choice
mov edx, 0
mov dl, bh ;moves column number to dl, added to eax next
add eax, edx ;adds column number

cmp let, 058h ;this checks if letter is x
jne letter2
mov edx, 058h ;if letter x, moves to edx to be printed on playboard
jmp filling

letter2:
cmp let, 059h ;checks if letter is y
jne letter3
mov edx, 059h ;moves y to edx to be printed and placed in array
jmp filling

letter3:
mov edx, 05Ah ;letter is z and will be placed and printed

filling:
mov bh, 0
cmp [esi + eax], bh
jne again ;jumps to again so that new position can be chosen since there is already letter in chosen position
mov [esi + eax], dl ;moves value of bh into array position
mov bl, dl

invoke fillArray, passed ;prints out the arrays in position
jmp finished

again:
call ClrScr ;clears screen
jmp player1Turn ;returns player to enter number again

finished:
mov eax, 1000 ;sets delay to 1 second
call delay

call crlf
call crlf

ret
computerTurn ENDP
;---------------------------------------------------------------------------------------

theWinner PROC, score1:PTR DWORD, score2:PTR DWORD, score3:PTR DWORD, mode:PTR DWORD, p1:PTR DWORD, p2:PTR DWORD, p3:PTR DWORD, c1:PTR DWORD, c2:PTR DWORD, c3:PTR DWORD, barr:PTR DWORD
LOCAL max:BYTE, row:BYTE

.data
p1Win BYTE "Player 1 wins!", newline, 0
p2Win BYTE "Player 2 wins!", newline, 0
p3Win BYTE "Player 3 wins!", newline, 0
c1Win BYTE "Computer 1 wins!", newline, 0
c2Win BYTE "Computer 2 wins!", newline, 0
c3Win BYTE "Computer 3 wins!", newline, 0

.code

mov row, 6
mov esi, barr
mov eax, 6
mov ebx, 3
mov dl, 2
mul dl
add eax, ebx

mov cl, [esi + eax]
cmp cl, 058h ;checks if X is in middle 4 squares
jne Ysquare
inc eax
mov cl, [esi + eax] ;moves new array position into cl
cmp cl, 058h ;checks if cl is X
jne Ysquare
add al, row ;row offset
mov cl, [esi + eax] ;keeps going but with new position 
cmp cl, 058h
jne ySquare
dec eax
mov cl, [esi + eax] ;last checked position
cmp cl, 058h
jne ySquare
mov edi, mode ;checks if mode is computer or player
mov bh, [edi]
cmp bh, 0
jne compWin
mov edx, OFFSET p1Win ;prints player 1 win message
call WriteString
call crlf
mov esi, p1
mov ah, 1
add [esi], ah
jmp complete
compWin:
mov edx, OFFSET c1Win ;prints computer 1 win message
call WriteString
call crlf
mov esi, c1
mov ah, 1
add [esi], ah
jmp complete

mov eax, 6
mov ebx, 3
mov dl, 2
mul dl
add eax, ebx

YSquare:
mov cl, [esi + eax]
cmp cl, 059h ;checks if X is in middle 4 squares
jne Zsquare
inc eax
mov cl, [esi + eax]
cmp cl, 059h
jne Zsquare
add al, row ;row offset
mov cl, [esi + eax]
cmp cl, 059h
jne ZSquare
dec eax
mov cl, [esi + eax]										;SAME AS CODE BLOCK BEFORE IT BUT CHECKS Y
cmp cl, 059h
jne ZSquare
mov edi, mode
mov bh, [edi]
cmp bh, 0
jne compWin2
mov edx, OFFSET p2Win
call WriteString
call crlf
mov esi, p2
mov ah, 1
add [esi], ah
jmp complete
compWin2:
mov edx, OFFSET c2Win
call WriteString
call crlf
mov esi, c2
mov ah, 1
add [esi], ah
jmp complete

mov eax, 6
mov ebx, 3
mov dl, 2
mul dl
add eax, ebx

ZSquare:
mov cl, [esi + eax]
cmp cl, 05Ah ;checks if Z is in middle 4 squares
jne regular
inc eax
mov cl, [esi + eax]
cmp cl, 05Ah
jne regular
add al, row ;row offset
mov cl, [esi + eax]
cmp cl, 05Ah
jne regular
dec eax
mov cl, [esi + eax]
cmp cl, 05Ah
jne regular
mov edi, mode
mov bh, [edi]
cmp bh, 0
jne compWin3 ;jumps if computer was the one that won					;SAME AS CODE BLOCK BEFORE IT BUT CHECKS FOR Z
mov edx, OFFSET p3Win
call WriteString
call crlf
mov esi, p2
mov ah, 1
add [esi], ah
jmp complete
compWin3:
mov edx, OFFSET c3Win
call WriteString
call crlf
mov esi, c2
mov ah, 1
add [esi], ah
jmp complete

regular:

mov eax, 0
mov ebx, 0
mov ecx, 0
mov edx, 0 ;clearing of registers
mov esi, 0
mov edi, 0


mov edi, mode ;holds mode, whether it is computer mode or player
mov bl, [edi]

mov esi, score1 ;checks if first score is max, stores it
mov al, [esi]

mov max, al

mov esi, score2 ;does the same but for score 2
mov al, [esi]

cmp al, max
jbe try2 ;checks score 3 to make sure max score is held
mov max, al

try2:
mov esi, score3
mov al, [esi]

cmp al, max ;checks if al is equal to max so that max score is known
jbe printing
mov max, al

printing:
mov esi, score1 ;holds offset of score 1
mov al, [esi]

cmp al, max ;checks if score 1 is max so that it can increment if necessary
jne otherp
cmp bl, 0
jne comp1
mov edx, OFFSET p1Win ;prints player 1 winner message
call WriteString
call crlf
mov al, 1
mov edi, p1
add [edi], al ;adds 1 to total win counter
jmp otherp

comp1:
mov edx, OFFSET c1Win
call WriteString
call crlf ;prints message for computer 1 winner
mov al, 1
mov edi, c1
add [edi], al ;icrements win counter for comp 1

otherp:
mov esi, score2
mov al, [esi]
cmp al, max ;checks for player 2
jne other3
cmp bl, 0
jne comp2
mov edx, OFFSET p2Win ;prints win message for player 2
call WriteString
call crlf
mov al, 1
mov edi, p2 ;increments counter for player 2
add [edi], al
jmp other3

comp2:
mov edx, OFFSET c2Win ;prints win message for computer 2
call WriteString
call crlf
mov al, 1
mov edi, c2
add [edi], al ;increments counter for comp 2 wins

other3:
mov esi, score3 ;stores 3rd score to see if it was highest
mov al, [esi]
cmp al, max
jne complete
cmp bl, 0
jne comp3
mov edx, OFFSET p3Win ;computer win message for player 3
call WriteString
mov al, 1
mov edi, p3
add [edi], al
jmp complete

comp3:
mov edx, OFFSET c3Win ;computer win message for c3
call WriteString
mov al, 1
mov edi, c3
add [edi], al

complete: ;if code is complete

ret
theWinner ENDP


resetBoard PROC, ar:PTR DWORD
;Receives - array offset for main array
;Returns - Nothing, but array is cleared
;Function - fills array with null

mov esi, ar ;esi holds array offset
mov eax, 0
mov edx, 0 ;resets registers
mov ebx, 0
mov ecx, 36 ;total count for 6x6 grid

L50:

cmp ebx, 6
jne fillNull
add esi, ebx
mov ebx, 0
fillNull:
mov [esi + ebx], dl
inc ebx

loop L50

ret
resetBoard ENDP


END MAIN