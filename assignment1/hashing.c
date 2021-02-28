#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"

#define SIZE 100

typedef struct hashcell {
    char *word;
    struct hashcell *next;
} HASHCELL;

HASHCELL* hashtable[SIZE];

unsigned int hash_string(char *ptr) {
    unsigned int hash = 1;

    while(*ptr != '\0') {
        hash = (hash * 7) + *ptr;
        ptr++;
    }

    return (hash % SIZE);
}

void insert_hash_cell(char *strptr) {
    unsigned int index = hash_string(strptr);

    // Create new hashcell
    HASHCELL* new_hashcell = (HASHCELL*) malloc(sizeof(HASHCELL));
    char* string_holder = malloc(sizeof(strlen(strptr)) + 1);
    new_hashcell->word = string_holder;
    new_hashcell->next = NULL;

    //Copy given string to new hashcell
    strcpy(string_holder, strptr);

    HASHCELL* head = (HASHCELL *) hashtable[index];

    if (head != NULL && strcmp(head->word, new_hashcell->word) == 0) {
        return;
    } else {
        HASHCELL* current = head;
        if (hashtable[index] == NULL) {
            hashtable[index] = new_hashcell;
        } else {
            while (current != NULL) {
                if (current->next == NULL) {
                    current->next = new_hashcell;
                    return;
                }
                current = current->next;
            }
        }
    }
}

void print_hash_table() {
    for(int i = 0; i < SIZE - 1; i++) {
        if(hashtable[i] != NULL) {
            printf("%d:", i);
            printf("%s ", hashtable[i]->word);

            HASHCELL* ptr = (HASHCELL *) hashtable[i]->next;

            while(ptr != NULL) {
                printf("%s ", ptr->word);
                ptr = ptr->next;
            }

            printf("\n");
        }
    }
}

int main() {
    char str[SIZE];

    while (scanf("%s", str) != EOF) {
        insert_hash_cell(str);
    }

    for (int i = 0; i < SIZE - 1; i++) {
        HASHCELL* head = (HASHCELL *) hashtable[i];

        while (head != NULL) {
            insert_node(head->word);
            head = head->next;
        }
    }

    print_tree(root);

//    print_hash_table();
}