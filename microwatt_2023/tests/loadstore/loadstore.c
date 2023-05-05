#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include "console.h"

#define TEST "Test "
#define PASS "PASS\n"
#define FAIL "FAIL\n"

// i < 100
void print_test_number(int i)
{
	puts(TEST);
	putchar(48 + i/10);
	putchar(48 + i%10);
	putchar(':');
}

extern int test_code(void);

int main(void)
{
	int fail = 0;
	console_init();
	print_test_number(1);

	if (test_code() != 0) {
		fail = 1;
		puts(FAIL);
	} else
		puts(PASS);

        while (1) {
		unsigned char c = getchar();
		putchar(c);
		if (c == 13) // if CR send LF
			putchar(10);
	}
}
