MODEL small
code SEGMENT
ASSUME CS:code, DS:code
stack [10]
	;declaratii de date cu mesaje text
	msg1 db "        ~~~~~~~~~~~~AUTOMAT SGR~~~~~~~~~~~~~", 0Dh, 0Ah, '$'
    msg2 db "        !Apasa ENTER pentru a porni aparatul", 0Dh, 0Ah, '$'
    msg3 db "          !Aparatul porneste in 4 secunde...", '$'
    msg4 db "     ~Introduceti deseuri (metal('m'), plastic('p'), sticla('s')): ", '$'
	msg5 db "     ~Introduceti litri ('5'), ('3'), ('1'): ", '$'
    msg6 db 0Dh, 0Ah,0Dh, 0Ah, "     {error} Recipient nevalidat! Reincercati...", 0Dh, 0Ah, '$'
    msg7 db 0Dh, 0Ah, "     +Recipient validat! Continuati...", 0Dh, 0Ah, '$'
	msg8 db 0Dh, 0Ah, "     {error} Recipient respins(cantitate neacceptata)!", 0Dh, 0Ah, '$'
	msg9 db "      !Actiune terminata", 0Dh, 0Ah, '$'
	msg10 db "     ~Apasa ('escape') pentru a termina procesul", 0Dh, 0Ah, '$'
	msg11 db 0Dh, 0Ah, 0Dh, 0Ah,"     !Numarul total de recipiente introduse este: ", '$'
	msg12 db "     ~Apasa ('space') pentru a elibera banii!", 0Dh, 0Ah, '$'
	msg13 db "           !Felicitari, esti cu ", '$'
	msg14 db " lei mai bogat! ^a^", 0Dh, 0Ah, '$'
	msg15 db "           :( Ai uitat bani in aparat: ", '$'
	msg16 db "metal", 20h, '$'
	msg17 db "plastic", 20h, '$'
	msg18 db "sticla", 20h, '$'
	msg19 db "     !Din care: ", '$'
	msg20 db "          !Aparatul porneste in 3 secunde...", '$'
	msg21 db "          !Aparatul porneste in 2 secunde...", '$'
	msg22 db "          !Aparatul porneste in 1 secunde...", '$'
	msg23 db "                   Aparat pornit!!!", 0Dh, 0Ah, 0Dh, 0Ah, '$'
	msg24 db "          !Aparatul porneste in 0 secunde...", 0Dh, 0Ah, '$'

	;contoare
	count_metal db 0 
	count_sticla db 0
	count_plastic db 0
	threebool db 0
	totalcount db 0

start:
	mov ax, cs
	mov ds, ax

;--------------------------------------------;
;               Pornire Automat              ;

    lea dx, msg1 ;AUTOMAT SGR text
	mov ah, 09h
	int 21h
	lea dx, msg2 ;Enter start text
	mov ah, 09h
	int 21h

;Asteapta apasarea tastei enter
wait_enter:  
	mov ah, 08h
	int 21h
	cmp al, 0Dh
	jne wait_enter

	lea dx, msg3 ;3s asteptare text
	mov ah, 09h
	int 21h

;Citeste timpul curent din BIOS in tickuri de ceas
	mov ah, 00h  
	int 1Ah
	mov bx, dx ;Salvare tickuri in bx
	add bx, 18 ;Aduna 18 tickuri de ceas/1 secunda
wait_delay4s:  ;Așteaptă 1 secunde
    mov ah, 00h ;Citire timp
    int 1Ah
    cmp dx, bx ;Compara timpul cu cel tinta
    jl wait_delay4s

	mov ah, 02h
	mov dl, 0Dh ;Muta cursorul la începutul liniei curente (Carriage Return)
	int 21h
	lea dx, msg20 ;Asteptare 3s text
	mov ah, 09h
	int 21h

	mov ah, 00h ;1s
	int 1Ah
	mov bx, dx
	add bx, 18
wait_delay3s:
    mov ah, 00h
    int 1Ah
    cmp dx, bx
    jl wait_delay3s

	mov ah, 02h ;Carriage Return
	mov dl, 0Dh 
	int 21h
	lea dx, msg21 ;Asteptare 2s text
	mov ah, 09h
	int 21h

	mov ah, 00h ;1s
	int 1Ah
	mov bx, dx
	mov cx, 18 * 1 
	add bx, cx
wait_delay2s:
    mov ah, 00h
    int 1Ah
    cmp dx, bx
    jl wait_delay2s

	mov ah, 02h
	mov dl, 0Dh ;Carriage Return
	int 21h
	lea dx, msg22 ;Asteptare 1s text
	mov ah, 09h
	int 21h

	mov ah, 00h ;1s
	int 1Ah
	mov bx, dx
	mov cx, 18 * 1 
	add bx, cx
wait_delay1s:
    mov ah, 00h
    int 1Ah
    cmp dx, bx
    jl wait_delay1s

	mov ah, 02h
	mov dl, 0Dh ;Carriage Return
	int 21h
	lea dx, msg24 ;Asteptare 0s text
	mov ah, 09h
	int 21h
	lea dx, msg23 ; "Aparat pornit!!!" text
	mov ah, 09h
	int 21h

;Spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

;--------------------------------------------;
;             Introducere deseuri            ;

enter_deseu:
	mov	threebool, 0h ;boolean de 3 tipuri initializat cu 0
	lea dx, msg10 ;Exit mesaj
	mov ah, 09h
	int 21h
	lea dx, msg4 ;Introducere deseuri text
	mov ah, 09h
	int 21h

;Citire deseu (litera)
read_word: 
	mov ah, 08h ;Citire de la tastatura
    int 21h      
	cmp al, 1Bh ;Verifica daca este apasat 'escape'
	je finish_exec1 ;Saritura la finish_exec1
    cmp al, 61h  ; >= A 
    jl read_word ;Verificam daca este apasata o litera
    cmp al, 7Ah  ; <= Z
    jg read_word
	mov cl, al ;Salvare litera

	;Verificam ce litera a fost apasata
	cmp cl, 'm'
	je valid_metal
	cmp cl, 'p'
	je valid_plastic
	cmp cl, 's'
	je valid_sticla

;Litere invalide
invalid_type: 
	lea dx, msg6 ;Deseu incorect text
	mov ah, 09h
	int 21h
	jmp wait_2sec ;Saritura la wait_2sec

finish_exec1:
	jmp finish_exec2 ;Saritura la finish_exec2

valid_metal:
	lea dx, msg16 ;Metal text
	mov ah, 09h
	int 21h

	;Spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg5 ;Deseu valid text
	mov ah, 09h
	int 21h
	mov threebool, 01h ;Daca deseul introdus este metal bool=1
	jmp check_volume ;Saritura la check_volume


valid_plastic:
	lea dx, msg17 ;Plastic text
	mov ah, 09h
	int 21h

	;spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg5 ;Deseu valid text
	mov ah, 09h
	int 21h
	mov threebool, 02h ;Daca deseul introdus este metal bool=2
	jmp check_volume ;Saritura la check_volume

valid_sticla:
	lea dx, msg18 ;Sticla text
	mov ah, 09h
	int 21h

	;spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg5 ;Deseu valid text
	mov ah, 09h
	int 21h
	mov threebool, 03h ;Daca deseul introdus este metal bool=3
	jmp check_volume ;Saritura check_volume

check_volume: ;Verificare volum deseuri

;Citire cifra
read_number:
	mov ah, 08h ;Citire cifra tastatura
    int 21h      
    cmp al, 30h  ; >= 0 
    jl read_number ;Verifica daca este cifra
    cmp al, 39h  ; <= 9 
    jg read_number
	mov ah, 02h ;Afisare cifra
	mov dl, al
	int 21h
	mov cl, al ;Aalvare cifra
	mov ah, 02h
	mov dl, 'l' ;Afisare 'l'
	int 21h

	sub cl, '0' ;Transforma din ascii in nr: scade 48 din nr
	;Verifica ce volum s a introdus
	cmp cl, 5
	je valid_volume
	cmp cl, 3
	je valid_volume
	cmp cl, 1
	je valid_volume

;Volum nevalid
invalid_volume:
;spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg8 ;Volum invalid text
	mov ah, 09h
	int 21h
	jmp wait_2sec ;Saritura wait_2sec

;Volum valid
valid_volume:
	;Compara intre 1, 2 si 3 pentru corespondenta cu deseul respectiv
	cmp threebool, 01h ;1 corespunde cu metal
	je add_metal
	cmp threebool, 02H ;2 corespunde cu plastic
	je add_plastic
	cmp threebool, 03h ;3 corespunde cu sticla
	je add_sticla
add_metal: 
	inc byte ptr count_metal ;Incrementare metal
	mov threebool, 0  ;Aducere la 0 pentru urmatorul deseu introdus
	jmp add_total
add_plastic: 
	inc byte ptr count_plastic ;Incrementare plastic
	mov threebool, 0 
	jmp add_total
add_sticla:
	inc byte ptr count_sticla ;Incrementare sticla
	mov threebool, 0 
	jmp add_total

add_total:
	inc byte ptr totalcount ;Incrementare contor total

	;spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg7 ;Volum valid text
	mov ah, 09h
	int 21h
	jmp wait_2sec ;Saritura wait_2sec

;--------------------------------------------;
;                    Final                   ;

;Asteptare 2s pentru a reveni iar la introducerea unui nou deseu
wait_2sec:
	mov ah, 00h ;Citeste timpul din bios in tickuri de ceas
	int 1Ah
	mov bx, dx ;Salveaza tickurile
	add bx, 36 ;Adauga 36 tacuri de ceas/2s
wait_delay1:
	mov ah, 00h ;Citeste timpul curent
	int 1Ah
	cmp dx, bx ;Compara timpul curent cu cel tinta
	jl wait_delay1 ;Daca este mai mic continua
	
	;spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h
	jmp enter_deseu ;Saritura enter_deseu

;Iesire din introducere deseuri
finish_exec2:
	lea dx, msg11 ;Informare contor text
	mov ah, 09h
	int 21h
	mov al, totalcount ;Contor total
	add al, '0' ;Adauga codul ASCII al carac '0' adica 48
	mov ah, 02 ;Afisare numar
	mov dl, al
	int 21h

	;spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg19 ;Din care deseuri: text
	mov ah, 09h
	int 21h

	lea dx, msg16 ;Metal text
	mov ah, 09h
	int 21h
	mov dl, 3Dh ;= text
	mov ah, 02H 
	int 21h
	mov dl, 20h ;Space text
	mov ah, 02H 
	int 21h
	mov al, count_metal ;Contor metal
	add al, '0' ;Adauga codul ASCII al carac '0' adica 48
	mov ah, 02 ;Afisare numar
	mov dl, al
	int 21h

	mov dl, 20h ;Space text
	int 21h
	mov dl, 2Bh ;+ text
	mov ah, 02H 
	int 21h
	mov dl, 20h ;Space text
	mov ah, 02H 
	int 21h

	lea dx, msg17 ;Plastic text
	mov ah, 09h
	int 21h
	mov dl, 3Dh ;= text
	mov ah, 02H 
	int 21h
	mov dl, 20h ;Space text
	mov ah, 02H 
	int 21h
	mov al, count_plastic ;Contor plastic
	add al, '0' ;Adauga codul ASCII al carac '0' adica 48
	mov ah, 02
	mov dl, al
	int 21h

	mov dl, 20h ;Space text
	mov ah, 02H 
	int 21h
	mov dl, 2Bh ;+
	mov ah, 02H 
	int 21h
	mov dl, 20h ;Space text
	mov ah, 02H 
	int 21h

	lea dx, msg18 ;Sticla text
	mov ah, 09h
	int 21h
	mov dl, 3Dh ;= text
	mov ah, 02H 
	int 21h
	mov dl, 20h ;Space text
	mov ah, 02H 
	int 21h
	mov al, count_sticla ;Contor sticla
	add al, '0' ;Adauga codul ASCII al carac '0' adica 48
	mov ah, 02
	mov dl, al
	int 21h

	;2 spatii linii
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg12 ;Eliberare bani text
	mov ah, 09h
	int 21h
;Asteapta pentru space
wait_space:
	mov ah, 08h 
	int 21h
	cmp al, 1Bh ;Escape tasta
	je exit_program ;Saritura exit_program - exit fara bani 
	cmp al, 20h ;Space tasta
	jne wait_space

	;spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg13 ;Felicitari text
	mov ah, 09h
	int 21h

	mov al, totalcount ;Contor total
	add al, '0' ;Adauga codul ASCII al carac '0' adica 48
	mov ah, 02 ;Afisare numar
	mov dl, al
	int 21h

	lea dx, msg14 ;Cu text
	mov ah, 09h
	int 21h

	jmp exit_program1 ;Saritura exit_program1 

;Iesire program fara a lua banii
exit_program: 
;Spatiu linie
	mov ah, 02H 
	mov dl, 0AH
	int 21h
	mov ah, 02H
	mov dl, 0DH
	int 21h

	lea dx, msg15 ;Bani uitati text
	mov ah, 09h
	int 21h
	mov al, totalcount ;Contor total
	add al, '0' ;Adauga codul ASCII al carac '0' adica 48
	mov ah, 02 ;Afisare numar/contor
	mov dl, al
	int 21h

exit_program1: ;exit cu bani
;;;;;
	mov ax, 4c00h
	int 21h

code ENDS
end start