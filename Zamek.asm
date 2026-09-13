; r0 		; Registr R0 se v tomto programu nepoužívá.
; r1 		; Registr R1 se v tomto programu nepoužívá.
; r2 		; Registr R2 se v tomto programu nepoužívá.
; r3 		; Registr R3 se v tomto programu nepoužívá.
; r4 		; Registr R4 ukládá poslední stisknutou klávesu.
; r5 		; Registr R5 obsahuje číslo, které se má zobrazit na displeji.
; r6 		; Registr R6 slouží jako vnější čítač pro zpoždění.
; r7 		; Registr R7 slouží jako vnitřní čítač pro zpoždění.

; RAM 20-23 		; Tato místa v RAM obsahují uložený PIN.
; RAM 24-27 		; Tato místa v RAM obsahují uložený PUK.

disp equ p3 		; Nastaví název disp jako zástupný název pro port P3 (displej).
klv equ p1 		; Nastaví název klv jako zástupný název pro port P1 (klávesnice).

org 0 			; Nastaví začátek programu na adresu 0.

jmp start 		; Po spuštění skočí na část programu označenou start.

start: 				; Začátek hlavního programu.
	mov 20,#1 		; Uloží do RAM adresy 20 hodnotu 1, což je první číslice PINu.
	mov 21,#2 		; Uloží do RAM adresy 21 hodnotu 2, což je druhá číslice PINu.
	mov 22,#3 		; Uloží do RAM adresy 22 hodnotu 3, což je třetí číslice PINu.
	mov 23,#4 		; Uloží do RAM adresy 23 hodnotu 4, což je čtvrtá číslice PINu.
	
	mov 24,#9 		; Uloží do RAM adresy 24 hodnotu 9, což je první číslice PUKu.
	mov 25,#8 		; Uloží do RAM adresy 25 hodnotu 8, což je druhá číslice PUKu.
	mov 26,#7 		; Uloží do RAM adresy 26 hodnotu 7, což je třetí číslice PUKu.
	mov 27,#6 		; Uloží do RAM adresy 27 hodnotu 6, což je čtvrtá číslice PUKu.
	
	mov r5,#10 		; Uloží do R5 hodnotu 10, která znamená prázdný znak displeje.
	
	call zobraz1 		; Zavolá funkci, která zobrazí hodnotu z R5 na první pozici displeje.
	call zobraz2 		; Zavolá funkci, která zobrazí hodnotu z R5 na druhou pozici displeje.
	call zobraz3 		; Zavolá funkci, která zobrazí hodnotu z R5 na třetí pozici displeje.
	call zobraz4 		; Zavolá funkci, která zobrazí hodnotu z R5 na čtvrtou pozici displeje.
	
smycka: 		; Začátek hlavní smyčky, program se sem stále vrací.
	call nacti 		; Zavolá funkci načtení klávesy a čeká na první číslici PINu.
	cjne a,20,puk 		; Porovná zadanou hodnotu v A s první číslicí PINu. Pokud nesouhlasí, skočí na PUK.
	call nacti 		; Načte druhou číslici PINu.
	cjne a,21,smycka 	; Porovná druhou číslici PINu. Pokud nesouhlasí, vrátí se na začátek.
	call nacti 		; Načte třetí číslici PINu.
	cjne a,22,smycka 	; Porovná třetí číslici PINu. Pokud nesouhlasí, vrátí se na začátek.
	call nacti 		; Načte čtvrtou číslici PINu.
	cjne a,23,smycka 	; Porovná čtvrtou číslici PINu. Pokud nesouhlasí, vrátí se na začátek.
	call blikej		; PIN byl správně, zavolá blikání displeje.
	jmp smycka 		; Vrátí program zpět na začátek zadávání PINu.
	
puk: 			; Sem program skočí, pokud nebyla první číslice PINu správná a kontroluje se PUK.
	cjne a,24,smycka 	; Porovná zadanou číslici s první číslicí PUKu uloženou v RAM 24. Pokud nesedí, vrátí se na začátek.
	call nacti 		; Načte druhou číslici PUKu.
	cjne a,25,smycka 	; Porovná druhou číslici PUKu s hodnotou v RAM 25. Pokud nesedí, vrátí se na začátek.
	call nacti 		; Načte třetí číslici PUKu.
	cjne a,26,smycka 	; Porovná třetí číslici PUKu s hodnotou v RAM 26. Pokud nesedí, vrátí se na začátek.
	call nacti 		; Načte čtvrtou číslici PUKu.
	cjne a,27,smycka 	; Porovná čtvrtou číslici PUKu s hodnotou v RAM 27. Pokud nesedí, vrátí se na začátek.
	call zobrazpin 		; PUK je správný, zobrazí aktuální PIN na displeji.
	mov disp,#01110000b 	; Nastaví desetinnou tečku na displeji jako označení první měněné číslice.
	
pin1: 			; Začátek zadávání první číslice nového PINu.
	call klavesa 		; Načte hodnotu z klávesnice.
	cjne a,#0,pin1a 	; Zkontroluje, jestli byla nějaká klávesa stisknuta. Pokud ano, pokračuje dál.
	jmp pin1 		; Pokud nebyla klávesa stisknuta, čeká znovu.
	
pin1a: 			; Sem program přijde po zadání první číslice nového PINu.
	mov 20,a 		; Uloží první číslici nového PINu do RAM adresy 20.
	mov r5,a 		; Uloží zadané číslo do registru R5 pro zobrazení.
	call zobraz4 		; Zobrazí první číslici nového PINu na čtvrté pozici displeje.
	call zpomal 		; Udělá časovou prodlevu.
	mov disp,#01100000b 	; Posune desetinnou tečku na další číslici.
	
pin2: 			; Začátek zadávání druhé číslice nového PINu.
	call klavesa 		; Načte hodnotu z klávesnice.
	cjne a,#0,pin2a 	; Kontroluje, jestli byla klávesa stisknuta.
	jmp pin2 		; Pokud ne, čeká dál.
	
pin2a: 			; Sem program přijde po zadání druhé číslice nového PINu.
	mov 21,a 		; Uloží druhou číslici nového PINu do RAM adresy 21.
	mov r5,a 		; Připraví číslo pro zobrazení na displeji.
	call zobraz3 		; Zobrazí druhou číslici na třetí pozici displeje.
	call zpomal 		; Udělá krátkou prodlevu.
	mov disp,#01010000b 	; Posune desetinnou tečku na další číslici.
	
pin3: 			; Začátek zadávání třetí číslice nového PINu.
	call klavesa 		; Načte hodnotu z klávesnice.
	cjne a,#0,pin3a 	; Kontroluje, zda byla klávesa stisknuta.
	jmp pin3 		; Pokud nebyla, čeká dál.
	
pin3a: 			; Sem program přijde po zadání třetí číslice nového PINu.
	mov 22,a 		; Uloží třetí číslici nového PINu do RAM adresy 22.
	mov r5,a 		; Připraví číslo pro zobrazení.
	call zobraz2 		; Zobrazí třetí číslici na druhé pozici displeje.
	call zpomal 		; Udělá časovou prodlevu.
	mov disp,#01000000b 	; Posune desetinnou tečku na poslední číslici.
	
pin4: 			; Začátek zadávání čtvrté číslice nového PINu.
	call klavesa 		; Načte hodnotu z klávesnice.
	cjne a,#0,pin4a 	; Kontroluje, jestli byla klávesa stisknuta.
	jmp pin4 		; Pokud nebyla, čeká dál.
	
pin4a: 			; Sem program přijde po zadání poslední číslice nového PINu.
	mov 23,a 		; Uloží čtvrtou číslici nového PINu do RAM adresy 23.
	mov r5,a 		; Připraví poslední číslici pro zobrazení.
	call zobraz1 		; Zobrazí poslední číslici na první pozici displeje.
	call zpomal 		; První prodleva po zadání PINu.
	call zpomal 		; Druhá prodleva po zadání PINu.
	call zpomal 		; Třetí prodleva po zadání PINu.
	call zpomal 		; Čtvrtá prodleva po zadání PINu.
	call blikej 		; Po úspěšné změně PINu začne displej blikat.
	jmp smycka 		; Vrátí program zpět na kontrolu nového PINu.
	
nacti: 			; Podprogram pro načtení jedné číslice z klávesnice.
	call klavesa 		; Zavolá funkci klavesa, která načte stisknutou klávesu.
	cjne a,#0,nacti1 	; Porovná hodnotu v registru A s nulou. Pokud není 0, byla stisknuta klávesa a pokračuje dál.
	jmp nacti 		; Pokud nebyla stisknuta žádná klávesa, vrátí se zpět a čeká.
	
nacti1: 		; Část programu, která pokračuje po zadání klávesy.
	mov r5,a 		; Uloží zadanou hodnotu do registru R5 pro zobrazení.
	call zobraz1 		; Zobrazí zadanou číslici na první pozici displeje.
	call zpomal 		; Udělá krátkou prodlevu, aby bylo číslo vidět.
	mov a,r4 		; Přesune poslední stisknutou klávesu z registru R4 zpět do A.
	ret 			; Vrátí se zpět do části programu, odkud byla funkce zavolána.

zobrazpin: 		; Podprogram pro zobrazení aktuálně uloženého PINu.
	mov r5,20 		; Načte první číslici PINu z RAM adresy 20 do registru R5.
	call zobraz4 		; Zobrazí první číslici PINu na čtvrté pozici displeje.
	mov r5,21 		; Načte druhou číslici PINu z RAM adresy 21.
	call zobraz3 		; Zobrazí druhou číslici PINu na třetí pozici displeje.
	mov r5,22 		; Načte třetí číslici PINu z RAM adresy 22.
	call zobraz2 		; Zobrazí třetí číslici PINu na druhé pozici displeje.
	mov r5,23 		; Načte čtvrtou číslici PINu z RAM adresy 23.
	call zobraz1 		; Zobrazí čtvrtou číslici PINu na první pozici displeje.
	call zpomal 		; Udělá prodlevu, aby byl PIN viditelný.
	ret 			; Vrátí se zpět do hlavního programu.

blikej: 		; Podprogram pro blikání displeje po správném PINu nebo změně PINu.
	mov r5,#8 		; Nastaví hodnotu 8 pro zobrazení na displeji.
	call zobraz1 		; Zobrazí číslo 8 na první pozici displeje.
	call zobraz2 		; Zobrazí číslo 8 na druhé pozici displeje.
	call zobraz3 		; Zobrazí číslo 8 na třetí pozici displeje.
	call zobraz4 		; Zobrazí číslo 8 na čtvrté pozici displeje.
	call zpomal 		; Čekací doba mezi rozsvícením a zhasnutím.
	mov r5,#10 		; Nastaví hodnotu 10, která znamená prázdný znak (zhasnutí displeje).
	call zobraz1 		; Zhasne první pozici displeje.
	call zobraz2 		; Zhasne druhou pozici displeje.
	call zobraz3 		; Zhasne třetí pozici displeje.
	call zobraz4 		; Zhasne čtvrtou pozici displeje.
	call zpomal 		; Čekací doba mezi zhasnutím a dalším rozsvícením.
	call klavesa 		;Zkontroluje, jestli uživatel nezmáčkl nějakou klávesu.
	cjne a,#0,bl1 		; Pokud byla stisknuta klávesa, skočí na konec blikání.
	jmp blikej 		; Pokud nebyla stisknuta klávesa, pokračuje další blikání.
bl1: 			; Konec blikací smyčky.
	call zpomal 		; Udělá ještě jednu krátkou prodlevu.
	ret 			; Vrátí se zpět do programu.
	
klavesa: 		; Podprogram pro načtení hodnoty z klávesnice.
	mov a,klv 		; Načte stav portu P1 (klávesnice) do registru A.
	cpl a 			; Obrátí všechny bity v registru A, protože klávesnice posílá opačný (negovaný) signál.
	mov r4,a 		; Uloží načtenou a upravenou hodnotu klávesy do registru R4.
	ret 			; Vrátí se zpět do programu.

zobraz1: 		; Podprogram pro zobrazení čísla z R5 na první pozici displeje.
	mov a,r5 		; Přesune hodnotu z registru R5 do registru A.
	anl a,#00001111b 	; Pomocí AND ponechá pouze spodní 4 bity, které obsahují číslici 0-9.
	orl a,#00000000b 	; Nastaví bity určující první pozici displeje.
	mov disp,a 		; Pošle výslednou hodnotu na port displeje P3.
	ret 			; Návrat zpět do programu.

zobraz2: 		; Podprogram pro zobrazení čísla z R5 na druhou pozici displeje.
	mov a,r5 		; Přesune hodnotu z R5 do registru A.
	anl a,#00001111b 	; Oddělí pouze hodnotu číslice.
	orl a,#00010000b 	; Přidá nastavení pro druhou pozici displeje.
	mov disp,a 		;Odešle hodnotu na port displeje.
	ret 			; Návrat zpět.

zobraz3: 		; Podprogram pro zobrazení čísla z R5 na třetí pozici displeje.
	mov a,r5 		; Přesune hodnotu z R5 do registru A.
	anl a,#00001111b 	; Ponechá pouze spodní 4 bity s číslem.
	orl a,#00100000b 	; Přidá nastavení pro třetí pozici displeje.
	mov disp,a 		; Odešle hodnotu na displej.
	ret 			; Návrat zpět.

zobraz4: 		; Podprogram pro zobrazení čísla z R5 na čtvrtou pozici displeje.
	mov a,r5 		; Přesune hodnotu z R5 do registru A.
	anl a,#00001111b 	; Vybere pouze hodnotu číslice.
	orl a,#00110000b 	; Přidá nastavení pro čtvrtou pozici displeje.
	mov disp,a 		; Odešle hodnotu na displej.
	ret 			; Návrat zpět.

zpomal: 		; Podprogram vytvářející časové zpoždění.
	djnz r7,zpomal 		; Sníží hodnotu v registru R7 o 1. Pokud není nula, skočí zpět a opakuje smyčku.
	djnz r6,zpomal 		; Po vyčerpání R7 sníží R6 o 1 a znovu opakuje celou smyčku.
	ret 			; Po dokončení zpoždění se vrátí zpět do programu.
end 			; Konec programu.






