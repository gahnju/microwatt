#include <stdint.h>
#include <stdbool.h>

#include "console.h"
#include "io.h"
#include "microwatt_soc.h"

static char mw_logo1[] =
"\n"
"   .oOOo.     \n"
" .\"      \". \n"
" ;  .mw.  ;   Microwatt, it works.\n"
"  . '  ' .    \n"
"   \\ || /     HDL Git SHA1: ";

static char mw_logo2[] =
"\n"
"    ;..;      \n"
"    ;..;      \n"
"    `ww'      \n\n";

int main(void)
{

	console_init();

        //mark start
        volatile uint64_t beef=0xdeadbeefbadeaffe;
        beef++; // make sure a_in, b_in or c_in take the value

	puts(mw_logo1);

	puts(mw_logo2);

        // mark end
        beef=0xdeadaffebadebeef;
        beef++; // make sure a_in, b_in or c_in take the value
          
        while (1) {
		unsigned char c = getchar();
		putchar(c);
		if (c == 13) // if CR send LF
			putchar(10);
	}
}
