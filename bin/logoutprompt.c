#if 0

# Bash code

CC="gcc"
CFLAGS="-O2"

if ! [ -e "$HOME/bin/logoutprompt" ] || [ "$HOME/bin/logoutprompt.c" -nt "$HOME/bin/logoutprompt" ]
then
    "$CC" $CFLAGS $HOME/bin/logoutprompt.c -o $HOME/bin/logoutprompt
fi

if [ "$1" == "DEBUG" ]
then
    $HOME/bin/logoutprompt $HOME/bin/debugitems
else
    $HOME/bin/logoutprompt $HOME/bin/promptitems
fi

exit

#endif

// C code

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

#include <sys/wait.h>

#define DA_IMPLEMENTATION
#include "da.h"

#define ARR_SIZE  sizeof(arr_t)
#define CHAR_SIZE sizeof(char)

#define RX 0
#define TX 1

// This is so retarded but I can't help it
// Zero thought given about the practicality of this approach
// Zero expectations on quality of code
//
// I should have used Python, but this is funnier.

int main(int argc, char **argv)
{
    arr_t items = {0};
    createarr(&items, 12 * ARR_SIZE);

    // ...safe?
    FILE *fpromptitems = fopen(argv[1], "rb");
    if(!fpromptitems)
    {
        fprintf(stderr, "could not open file \"%s\": %s\n", argv[1], strerror(errno));
        return 1;
    }

    fprintf(stderr, "reading...\n");

    int c;
    while((c = fgetc(fpromptitems)) != EOF)
    {
        //fprintf(stderr, "pushing new string builder to array\n");

        arr_t sb = {0};
        createarr(&sb, 32 * CHAR_SIZE);

        // is any kind of optimisation possible?
        do
        {
            if(c == EOF) break;
            //fprintf(stderr, "pushing character `%c` to string builder\n", c);
            pushback(&sb, &c, CHAR_SIZE);
        } while((c = fgetc(fpromptitems)) != '\n');
        pushback(&sb, "\0", CHAR_SIZE); // ???

        pushback(&items, &sb, ARR_SIZE);
    }

    fclose(fpromptitems);

    arr_t dmenusb = {0};
    createarr(&dmenusb, 32*6*CHAR_SIZE);

    for(int i = 0; i < getitemcount(&items, ARR_SIZE); i+=2)
    {
        arr_t *itemstring = (arr_t*)getitem(&items, i, ARR_SIZE);
        fprintf(stderr, "appending to dmenusb: %s\n", (char*)itemstring->array);
        join(&dmenusb, itemstring);
        setitem(&dmenusb, "\n", getitemcount(&dmenusb, CHAR_SIZE) - 1, CHAR_SIZE); // ???
    }
    setitem(&dmenusb, "\0", getitemcount(&dmenusb, CHAR_SIZE) - 1, CHAR_SIZE); // ???

    int tochild[2];
    int toparent[2];
    if(pipe(tochild))
    {
        fprintf(stderr, "could not create pipe `tochild`: %s\n", strerror(errno));
        return 1;
    }
    if(pipe(toparent))
    {
        fprintf(stderr, "could not create pipe `toparent`: %s\n", strerror(errno));
        return 1;
    }

    fprintf(stderr, "forking...\n");
    pid_t child = fork();
    if(child < 0)
    {
        fprintf(stderr, "could not fork: %s\n", strerror(errno));
        return 1;
    }
    else if(child == 0)
    {
        if(dup2(tochild[RX], STDIN_FILENO) < 0)
        {
            fprintf(stderr, "CHILD: could not dup2: %s\n", strerror(errno));
            return 1;
        }
        if(dup2(toparent[TX], STDOUT_FILENO) < 0)
        {
            fprintf(stderr, "CHILD: could not dup2: %s\n", strerror(errno));
            return 1;
        }

        close(tochild[TX]);
        close(toparent[RX]);

        fprintf(stderr, "CHILD: execing dmenu...\n");
        if(execlp("dmenu", "dmenu", "-i", NULL))
        {
            fprintf(stderr, "CHILD: could not execlp: %s\n", strerror(errno));
            return 1;
        }

        assert(0 && "Unreachable");
    }

    close(tochild[RX]);
    close(toparent[TX]);

    fprintf(stderr, "writing to child...\n");
    fprintf(stderr, "sending to dmenu:\n==================\n%s\n==================\n", (char*)dmenusb.array);
    if(write(tochild[TX], dmenusb.array, dmenusb.count) < 0)
    {
        fprintf(stderr, "could not write to pipe: %s\n", strerror(errno));
        return 1;
    }

    close(tochild[TX]);

    deletearr(&dmenusb);

    fprintf(stderr, "waiting for child...\n");
    int status = 0;
    if(waitpid(child, &status, 0) < 0)
    {
        fprintf(stderr, "could not wait for child: %s\n", strerror(errno));
        return 1;
    }
    if(WIFEXITED(status))
    {
        int exit_status = WEXITSTATUS(status);
        if(exit_status)
        {
            fprintf(stderr, "child exited with code %d\n", exit_status);
            return 1;
        }
    }
    if(WIFSIGNALED(status))
    {
        fprintf(stderr, "child got terminated by %s\n", strsignal(WTERMSIG(status)));
        return 1;
    }

    // Go on, use a dynamic array for this.
    char buf[1024] = {0};
    if(read(toparent[RX], buf, sizeof(buf)) < 0)
    {
        fprintf(stderr, "could not read from child: %s\n", strerror(errno));
        return 1;
    }
    close(toparent[RX]);

    // weird hack
    size_t buflen = strnlen(buf, sizeof(buf));
    for(int i = 0; i < buflen; i++)
    {
        if(buf[i] == '\n')
        {
            buf[i] = 0;
            break;
        }
    }

    int index = -1;
    for(int i = 0; i < getitemcount(&items, ARR_SIZE); i+=2)
    {
        char *str = (char*)((arr_t*)getitem(&items, i, ARR_SIZE))->array;
        fprintf(stderr, "comparing `%s` against `%s`\n", buf, str);
        if(strcmp(buf, str) == 0)
        {
            index = i;
            break;
        }
    }
    index++;

    // no I am NOT separating the string by whitespaces
    system((char*)((arr_t*)getitem(&items, index, ARR_SIZE))->array);

    for(int i = 0; i < getitemcount(&items, ARR_SIZE); i++)
    {
        arr_t *string = (arr_t*)getitem(&items, i, ARR_SIZE);
        deletearr(string);
    }
    deletearr(&items);

    return 0;
}

