#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"

NODE *root;

struct node* rec_insert_node(NODE* n, NODE* r) {
    if (strcmp(n->word, r->word) < 0) {
        if (r->left == NULL) {
            r->left = n;
        } else {
            r->left = rec_insert_node(n, r->left);
        }
    } else if (strcmp(n->word, r->word) > 0) {
        if (r->right == NULL) {
            r->right = n;
        } else {
            r->right = rec_insert_node(n, r->right);
        }
    }

    return r;
}

void insert_node(char *nodeptr) {
    NODE *temp_node = (NODE*) malloc(sizeof(NODE));
    char* string_holder = malloc(sizeof(strlen(nodeptr)) + 1);
    temp_node->word = string_holder;
    temp_node->left = NULL;
    temp_node->right = NULL;

    strcpy(string_holder, nodeptr);

    if (root == NULL) {
        root = temp_node;
    }

    if (root != NULL) {
        rec_insert_node(temp_node, root);
    }
}

void print_tree(NODE* r) {
    if (r == NULL) {
        return;
    } else {
        print_tree(r->left);
        printf("%s\n", r->word);
        print_tree(r->right);
    }
}
