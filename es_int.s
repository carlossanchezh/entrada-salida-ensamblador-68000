
* ------------------------------------ PROYECTO DE E/S ------------------------------------

        ORG     $0000
        DC.L    $8000         * Pila
*        DC.L    INICIO        * PC

        ORG     $0400

* Definición de equivalencias
*************************************

MR1A    EQU     $EFFC01       * de modo A (escritura)
MR2A    EQU     $EFFC01       * de modo A (2ª escritura)
SRA     EQU     $EFFC03       * de estado A (lectura)
CSRA    EQU     $EFFC03       * de selección de reloj A (escritura)
CRA     EQU     $EFFC05       * de control A (escritura)
TBA     EQU     $EFFC07       * buffer transmisión A (escritura)
RBA     EQU     $EFFC07       * buffer recepción A (lectura)
ACR     EQU     $EFFC09       * de control auxiliar
IMR     EQU     $EFFC0B       * de máscara de interrupción A (escritura)
ISR     EQU     $EFFC0B       * de estado de interrupción A (lectura)
MR1B    EQU     $EFFC11       * de modo B (escritura)
MR2B    EQU     $EFFC11       * de modo B (2ª escritura)
SRB     EQU     $EFFC13       * de estado B (lectura)
CSRB    EQU     $EFFC13       * de selección de reloj B (escritura)
CRB     EQU     $EFFC15       * de control B (escritura)
TBB     EQU     $EFFC17       * buffer transmisión B (escritura)
RBB     EQU     $EFFC17       * buffer recepción B (lectura)
IVR     EQU     $EFFC19       * Vector de interrupción ambas.
IVR     EQU     $EFFC19       * Vector de interrupción ambas.

IMRC DC.B 0   *copia IMR
CONT_A DC.L 0 *contador caracteres escritos en A
CONT_B DC.L 0 *contador caracteres escritos en B

**************************** PPAL ****************************

*PPAL:

*BUFFER: DS.B 2100 * Buffer para lectura y escritura de caracteres
*PARDIR: DC.L 0 * Direcci´on que se pasa como par´ametro
*PARTAM: DC.W 0 * Tama~no que se pasa como par´ametro
*CONTC: DC.W 0 * Contador de caracteres a imprimir
*DESA: EQU 0 * Descriptor l´ınea A
*DESB: EQU 1 * Descriptor l´ınea B
*DESX: EQU 3 *Descriptor Invalido
*TAMBS: EQU 4 * Tama~no de bloque para SCAN
*TAMBP: EQU 4 * Tama~no de bloque para PRINT


* Manejadores de excepciones
*INICIO: 
*        MOVE.L #BUS_ERROR,8 * Bus error handler
*        MOVE.L #ADDRESS_ER,12 * Address error handler
*        MOVE.L #ILLEGAL_IN,16 * Illegal instruction handler
*        MOVE.L #PRIV_VIOLT,32 * Privilege violation handler
*        MOVE.L #ILLEGAL_IN,40 * Illegal instruction handler
*        MOVE.L #ILLEGAL_IN,44 * Illegal instruction handler
*        BSR INIT
*	MOVE.L #0,A0
*        MOVE.W #$2000,SR * Permite interrupciones
*BUCPR: 
*        MOVE.W #TAMBS,PARTAM * Inicializa par´ametro de tama~no
*        MOVE.L #BUFFER,PARDIR * Par´ametro BUFFER = comienzo del buffer
*OTRAL: 
*
*	BREAK
*	BREAK
*        MOVE.W PARTAM,-(A7) * Tama~no de bloque
*       MOVE.W #DESA,-(A7) * Puerto A
*        MOVE.L PARDIR,-(A7) * Direcci´on de lectura
*ESPL: 
*        BSR SCAN
*        ADD.L #8,A7 * Restablece la pila
*        ADD.L D0,PARDIR * Calcula la nueva direcci´on de lectura
*        SUB.W D0,PARTAM * Actualiza el n´umero de caracteres le´ıdos
*        BNE OTRAL * Si no se han le´ıdo todas los caracteres
        * del bloque se vuelve a leer
*        MOVE.W #TAMBS,CONTC * Inicializa contador de caracteres a imprimir
*        MOVE.L #BUFFER,PARDIR * Par´ametro BUFFER = comienzo del buffer
*OTRAE: 
*        MOVE.W #TAMBP,PARTAM * Tama~no de escritura = Tama~no de bloque
*ESPE: 
*       MOVE.W PARTAM,-(A7) * Tama~no de escritura
*        MOVE.W #DESB,-(A7) * Puerto B
*        MOVE.L PARDIR,-(A7) * Direcci´on de escritura
*        BSR PRINT
*        ADD.L #8,A7 * Restablece la pila
*        ADD.L D0,PARDIR * Calcula la nueva direcci´on del buffer
*        SUB.W D0,CONTC * Actualiza el contador de caracteres
*        BEQ SALIR * Si no quedan caracteres se acaba
*        SUB.W D0,PARTAM * Actualiza el tama~no de escritura
*        BNE ESPE * Si no se ha escrito todo el bloque se insiste
*        CMP.W #TAMBP,CONTC * Si el no de caracteres que quedan es menor que
        * el tama~no establecido se imprime ese n´umero
*        BHI OTRAE * Siguiente bloque
*        MOVE.W CONTC,PARTAM
*        BRA ESPE * Siguiente bloque
*SALIR: 
*        BRA BUCPR
*BUS_ERROR: 
*        BREAK * Bus error handler
*        NOP
*ADDRESS_ER: 
*        BREAK * Address error handler
*        NOP
*ILLEGAL_IN: 
*        BREAK * Illegal instruction handler
*        NOP
*PRIV_VIOLT: 
*        BREAK * Privilege violation handler
*        NOP

**************************** TAMAÑO PRINT 0 *************************************************************
*INICIO:
*        BSR INIT
* 	MOVE.L #0,A0
*        MOVE.W #$2000,SR * Permite interrupciones

*        MOVE.W #0,PARTAM * Inicializa par´ametro de tama~no
*        MOVE.L #BUFFER,PARDIR * Par´ametro BUFFER = comienzo del buffer

*	BREAK	

*        MOVE.W PARTAM,-(A7) * Tama~no de bloque
*        MOVE.W #DESA,-(A7) * DescriptorA
*        MOVE.L PARDIR,-(A7) * Direcci´on de lectura

*        BSR PRINT

*        ADD.L #8,A7 * Restablece la pila

*        RTS


**************************** PRUEBA DESCRIPTOR INVALIDO *************************************************************
*INICIO:
*        BSR INIT
* 	MOVE.L #0,A0
*        MOVE.W #$2000,SR * Permite interrupciones

*        MOVE.W #TAMBS,PARTAM * Inicializa par´ametro de tama~no
*        MOVE.L #BUFFER,PARDIR * Par´ametro BUFFER = comienzo del buffer

*        MOVE.W PARTAM,-(A7) * Tama~no de bloque
*        MOVE.W #DESX,-(A7) * Descriptor inavlido
*        MOVE.L PARDIR,-(A7) * Direcci´on de lectura

*        BSR PRINT

*        ADD.L #8,A7 * Restablece la pila

*        RTS

**************************** PRUEBA SCANA *************************************************************
*INICIO:
*PSCANA:
*        BSR INIT
* 	MOVE.L #0,A0
*        MOVE.W #$2000,SR * Permite interrupciones

*        MOVE.W #TAMBS,PARTAM * Inicializa par´ametro de tama~no
*        MOVE.L #BUFFER,PARDIR * Par´ametro BUFFER = comienzo del buffer

*	BREAK *para escribir por la entrada

*	MOVE.W PARTAM,-(A7) * Tama~no de bloque
*       MOVE.W #DESA,-(A7) * Puerto A
*        MOVE.L PARDIR,-(A7) * Direcci´on de lectura

*        BSR SCAN

*        ADD.L #8,A7 * Restablece la pila

*        RTS

**************************** PRUEBA SCANB *************************************************************
*INICIO:
*PSCANB:
  *      BSR INIT
 *	MOVE.L #0,A0
 *       MOVE.W #$2000,SR * Permite interrupciones

 *       MOVE.W #TAMBS,PARTAM * Inicializa par´ametro de tama~no
 *       MOVE.L #BUFFER,PARDIR * Par´ametro BUFFER = comienzo del buffer

*	BREAK 

 *       MOVE.W PARTAM,-(A7) * Tama~no de bloque
  *      MOVE.W #DESB,-(A7) * Puerto A
   *     MOVE.L PARDIR,-(A7) * Direcci´on de lectura

   *     BSR SCAN

    *    ADD.L #8,A7 * Restablece la pila

     *   RTS

**************************** PRUEBA SCANA PRINTA *************************************************************
*INICIO:
      *  BSR PSCANA

      *  MOVE.W #TAMBP,PARTAM * Tama~no de escritura = Tama~no de bloque

      *  MOVE.W PARTAM,-(A7) * Tama~no de escritura
      *  MOVE.W #DESA,-(A7) * Puerto A
      *  MOVE.L PARDIR,-(A7) * Direcci´on de escritura

      *  BSR PRINT
      *  ADD.L #8,A7 * Restablece la pila

      *  RTS

**************************** PRUEBA SCANB PRINTA *************************************************************
*INICIO:
     *   BSR PSCANB

     *   MOVE.W #TAMBP,PARTAM * Tama~no de escritura = Tama~no de bloque

     *   MOVE.W PARTAM,-(A7) * Tama~no de escritura
     *   MOVE.W #DESA,-(A7) * Puerto A
     *   MOVE.L PARDIR,-(A7) * Direcci´on de escritura

     *   BSR PRINT
     *   ADD.L #8,A7 * Restablece la pila

      *  RTS

**************************** PRUEBA SCANA PRINTB *************************************************************
*INICIO:
*        BSR PSCANA

*        MOVE.W #TAMBP,PARTAM * Tama~no de escritura = Tama~no de bloque

*        MOVE.W PARTAM,-(A7) * Tama~no de escritura
*        MOVE.W #DESB,-(A7) * Puerto A
*        MOVE.L PARDIR,-(A7) * Direcci´on de escritura

*        BSR PRINT
*        ADD.L #8,A7 * Restablece la pila

*        RTS
**************************** PRUEBA SCANB PRINTB *************************************************************
*INICIO:
     *   BSR PSCANB

     *   MOVE.W #TAMBP,PARTAM * Tama~no de escritura = Tama~no de bloque

     *   MOVE.W PARTAM,-(A7) * Tama~no de escritura
     *   MOVE.W #DESB,-(A7) * Puerto A
     *   MOVE.L PARDIR,-(A7) * Direcci´on de escritura

     *   BSR PRINT
     *   ADD.L #8,A7 * Restablece la pila

     *   RTS

**************************** INIT *************************************************************

INIT:

        MOVE.B #%00000000,ACR   * Velocidad = 38400 bps

        * Configuración línea A

        MOVE.B #%00010000,CRA   * Reinicia el puntero MR1
        MOVE.B #%00000011,MR1A  * 8 bits por carácter
        MOVE.B #%00000000,MR2A  * Eco desactivado
        MOVE.B #%11001100,CSRA  * Velocidad = 38400 bps
        MOVE.B #%00000101,CRA   * Transmisión y recepción activadas

        * Configuración línea B

        MOVE.B #%00010000,CRB   * Reinicia el puntero MR1B
        MOVE.B #%00000011,MR1B  * 8 bits por carácter
        MOVE.B #%00000000,MR2B  * Eco desactivado
        MOVE.B #%11001100,CSRB  * Velocidad = 38400 bps
        MOVE.B #%00000101,CRB   * Habilita transmisión y recepción

        * Configurar la máscara de interrupción y su copia para modificarla

        MOVE.B #%00100010,IMR   * interrupciones habilitadas
        MOVE.B #%00100010,IMRC  * copia IMR

        *Configuarar los contadores para la escritura de print en el buffer de transmision
        MOVE.B #0,(CONT_A) *caracteres leidos de A =0
        MOVE.B #0,(CONT_B) *caracteres liedos de B = 0

        * Configurar el vector de interrupción en la tabla (dirección 0x100)

        MOVE.L #RTI,$100  * Dirección del manejador de interrupciones
        MOVE.B #$40,IVR   * Vector de interrupción entrada

        BSR     INI_BUFS          * Inicializa los buffers internos

        RTS
**************************** FIN INIT *********************************************************


**************************** SCAN *********************************************************
SCAN:   
        MOVE.L #$FFFFFFFF,D4 *Valor de error
	MOVE.L 4(A7),A3 *Buffer 
	CMP.L #0,A3
	BEQ DIR_NO_VAL *si buffer no valido error

	MOVE.W 8(A7),D2 *Descriptor
        MOVE.W 10(A7),D3 *Tamaño 

	CMP.L #0,D3
	BEQ SCAN_FIN *Si tamaño es 0 fin

	MOVE.L #0,D5 *Contador de caracteres leidos

        CMP_DESC:

	CMP.L #0,D2
	BEQ SCANA *Descriptor 0 -> A

	CMP.L #1,D2
        BEQ SCANB *Descriptor 1 -> B

        BRA DIR_NO_VAL

	SCANA:
		MOVE.L #0,D0 *Buffer BSCAN_A
		BRA BUCLE_SCAN

	SCANB:
		MOVE.L #1,D0 *Buffer BSCAN_B
                BRA BUCLE_SCAN

        BUCLE_SCAN:
                CMP.L D5,D3 
                BEQ SCAN_FIN *si contador == tamaño fin

		BSR LEECAR

		CMP.L D0,D4
		BEQ SCAN_FIN *Si Leecar no lee caracter fin

		MOVE.B D0,(A3) *Almacena byte en el buffer
                ADD.L #1,A3 *Apunta al siguiente byte del buffer

                ADD.L #1,D5 *Contador++

                BRA CMP_DESC


	SCAN_FIN:
                        MOVE.L D5,D0 *returna num de caracteres leidos
			RTS

       DIR_NO_VAL:
                        MOVE.L D4,D0 *retorna valor de error
			RTS


**************************** FIN SCAN ****************************


**************************** PRINT *********************************************************
PRINT:
        MOVE.L 4(A7),A3 *Buffer 
	CMP.L #0,A3
	BEQ PDIR_NO_VAL

	MOVE.W 8(A7),D2 *Descriptor
        MOVE.W 10(A7),D3 *Tamaño 

	CMP.W #0,D3
        BEQ TAM_0

        MOVE.L #0,D5 *Contador de caracteres escritos

	CMP.L #0,D2
	BEQ PRINTA *Descriptor 0 -> A

	CMP.L #1,D2
        BEQ PRINTB *Descriptor 1 -> B

	BRA PDIR_NO_VAL

        PRINTA:
                MOVE.B (A3),D1 *Byte a escribir ESCCAR
                ADD.L #1,A3 *Apunta al siguiente byte del buffer

                MOVE.L #2,D0 *Buffer BPRNT_A

                BSR ESCCAR

                CMP.L #0,D0
		BNE INTERRA *Si Esccar no devuleve 0 no ha ecrito carcter 

                ADD.L #1,D5 *Contador++

                *Contador de programa para tratar el print mediante interrupcion y mandar los bytes leidos al buffer de transmision

                ADD.L #1,(CONT_A) *Contador++

                CMP.L D5,D3 *SI CONTADOR ES IGUAL A TAMAÑO FIN
                BEQ INTERRA

                BRA PRINTA

        INTERRA:
                MOVE.L D5,D0 *retorna caracteres escritos
                CMP.L #0,(CONT_A)
                BEQ PRINT_FIN *Si los caracteres a leer son 0 fin 

                *si quedan caracteres por leer se activan las interrupciones 

                MOVE.B IMRC,D4
                BSET #0,D4 
                MOVE.B D4,IMRC 
                MOVE.B D4,IMR *activan interrupciones linea A pra hacer transferencia por RTI

                BRA PRINT_FIN

        PRINTB:
                MOVE.B (A3),D1 *Byte a escribir ESCCAR
                ADD.L #1,A3 *Apunta al siguiente byte del buffer

                MOVE.L #3,D0 *Buffer BPRNT_B

                BSR ESCCAR

                CMP.L #0,D0
		BNE INTERRB *Si Leecar no lee caracter fin

                ADD.L #1,D5 *Contador++

                *Contador de programa para tratar el print mediante interrupcion y mandar los bytes leidos al buffer de transmision

                ADD.L #1,(CONT_B) *Contador++

                CMP.L D5,D3 *SI CONTADOR ES IGUAL A TAMAÑO FIN
                BEQ INTERRB

                BRA PRINTB

        INTERRB:
                MOVE.L D5,D0 *contador al valor retorno
                CMP.L #0,(CONT_B)
                BEQ PRINT_FIN *Si los caracteres a leer son 0 fin 

                *si quedan caracteres por leer se activan las interrupciones 

                MOVE.B IMRC,D4
                BSET #4,D4 
                MOVE.B D4,IMRC 
                MOVE.B D4,IMR *activan interrupciones linea B para hacer transferencia por le RTI

                BRA PRINT_FIN

        
        PDIR_NO_VAL:
			MOVE.L #$FFFFFFFF,D0
			BRA PRINT_FIN

	TAM_0:
                        MOVE #0,D0
                        BRA PRINT_FIN

	PRINT_FIN:
			RTS

**************************** FIN PRINT *********************************************************


**************************** RTI *********************************************************
RTI:

	LINK     A6,#-24 * marco de pila de 24B para guardar registros de 4B
	MOVE.L   D2,-4(A6)
	MOVE.L   D4,-8(A6)
	MOVE.L   A0,-12(A6)
	MOVE.L   A1,-16(A6)
	MOVE.L   A2,-20(A6)
	MOVE.L   D0,-24(A6)

        MOVE.B IMRC,D2
        MOVE.B ISR,D4
        AND.B D2,D4 * tipo de interrupcion mascara de interrupcion sobre el ISR 

        *(bit=1->recepcion de A) (bit=5->recepcion de B) (bit=0->transmision de A) (bit=4->transmision de A)

        BTST #1,D4
        BNE A_RECEP

        BTST #5,D4
        BNE B_RECEP

        BTST #0,D4
        BNE A_TRANS

        BTST #4,D4
        BNE B_TRANS

        BRA ERROR_BIT

        A_RECEP:
                MOVE.B RBA,D1 *Buffer de recepcion de A
                MOVE.L #0,D0 *ESCCAR en el buffer BSCAN_A
                BSR ESCCAR

                CMP.L #0,D0
                BNE ERROR_BIT *si no lee caracteres desactiva interrupciones

                BSR RTI_FIN

        B_RECEP:
                MOVE.B RBB,D1 *Buffer de recepcion de B
                MOVE.L #1,D0 *ESCCAR en el buffer BSCAN_B
                BSR ESCCAR

                CMP.L #0,D0
                BNE ERROR_BIT *si no lee caracteres desactiva interrupciones

                BSR RTI_FIN

        A_TRANS:

                MOVE.L #2,D0 *lectuara del buffer A print
                BSR LEECAR
                
                CMP #$FFFFFFFF,D0 
                BEQ A *si leecar falla desabilita interrupciones(no datos para transmitir)

                SUB.L #1,(CONT_A) *Caracteres pendientes de transmitir--
                MOVE.B D0,TBA *Si no falla, byte leido al buffer de transmision de A
        
                CMP.L #0,(CONT_A) 
                BNE RTI_FIN *si quedan bytes por imprimir fin para tratar siguiente caracter

                BSR A *Si no quedan por imprimir para las interrupciones

        A:
                BCLR #0,D2 *Bit 0 de IMR a 0 para anular las interrupciones de A
                BSR NO_INTERR

        B_TRANS:

                MOVE.L #3,D0 *lectuara del buffer B 
                BSR LEECAR
                
                CMP #$FFFFFFFF,D0 
                BEQ B *si leecar falla desabilita interrupciones(no datos para transmitir)

                SUB.L #1,(CONT_B) *Caracteres pendientes de transmitir--
                MOVE.B D0,TBB *Si no falla el byte leido al buffer de transmision de B
        
                CMP.L #0,(CONT_B) 
                BNE RTI_FIN *si quedan bytes por imprimir fin para tratar siguiente caracter

                BSR B *Si no quedan por imprimir para las interrupciones

        B:
                BCLR #4,D2 *Bit 4 de IMR a 0 para anular las interrupciones de B
                BSR NO_INTERR

        NO_INTERR:
                MOVE.B D2,IMRC
                MOVE.B D2,IMR
                BSR RTI_FIN

        ERROR_BIT:
                MOVE.B #%00100010,D2 *Restaura el IMR
                MOVE.B D2,IMRC
                MOVE.B D2,IMR
                MOVE.B #0,D4
                BSR RTI_FIN 

        RTI_FIN:
        	MOVE.L   -4(A6),D2  
		MOVE.L   -8(A6),D4
		MOVE.L   -12(A6),A0
		MOVE.L   -16(A6),A1
		MOVE.L   -20(A6),A2
		MOVE.L   -24(A6),D0
		UNLK     A6 *restauran registros y elimina el marco de pila
                RTE

**************************** FIN RTI *********************************************************

INCLUDE bib_aux.s

