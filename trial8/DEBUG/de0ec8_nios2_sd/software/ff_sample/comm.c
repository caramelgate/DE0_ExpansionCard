#include "comm.h"

#include "sys/alt_stdio.h"
#include <stdio.h>

#define BUFFER_SIZE 128
#define BPS 		115200UL

static int TxRun;
static volatile struct
{
	int		rptr;
	int		wptr;
	int		count;
	BYTE	buff[BUFFER_SIZE];
} TxFifo, RxFifo;

int uart_test (void)
{
	return 0;
}

BYTE uart_get (void)
{
    return alt_getchar();
}

void uart_put (BYTE d)
{
	alt_putchar(d);
}

void uart_init (void)
{
}


