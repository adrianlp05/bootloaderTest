BITS 16

start:
	mov ax, 07C0h		        ;  Crea un stack de 4K despues de este bootloader 
	add ax, 0x20		        ;  Este Codigo pone en el stack segment el tamano del bootloader dividido por 16 
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		        ; Carga el data segment con la localizacion del bootloader en memoria Dividida por 16
	mov ds, ax


	mov si, text_string	        ; Pone la localizacion del string en si (pointer a la memoria donde esta el string)
	call print_string	        ; Llama a la rutina string-printing 

	jmp $			        ; Lazo infinito

data:
	text_string db 'Este es nuestro bootloader', 0


print_string:			        ; Rutina:  manda el string en si a la pantalla con un interrupt manejado por el Bios
	mov ah, 0Eh		        ; int 10h ' funcion del bios para imprimir un caracter'
.repeat:
	lodsb			        ; obtiene caracter del string
	cmp al, 0
	je .done		        ; si el caracter es cero finaliza el string
	int 10h			        ; si no lo imprime
	jmp .repeat

.done:
	ret


	times 510-($-$$) db 0	        ; llena el resto del sector del bootloader con ceros
	dw 0xAA55		        ; Numero magico del bootloader.