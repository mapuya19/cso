typedef struct node {
    char *word;
    struct node *left;
    struct node *right;
} NODE;

extern NODE *root;

struct node* rec_insert_node(NODE* n, NODE* r);
void insert_node(char *nodeptr);
void print_tree(NODE* r);