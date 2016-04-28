#include <stdio.h>
#include <string.h>

int main(int argc, char **argv) {
   FILE *fidR, *fidW;
   char line[200], newLine[200], lastName[100], firstName[100];
   int n, fnLen, lnLen;
   
   if (argc < 3) {
      fprintf(stderr, "Not enough input arguments\n");
      return 1;
   }
   
   fidR = fopen(argv[1], "r");
   fidW = fopen(argv[2], "w");
   while (fgets(line, 200, fidR)) {

//printf("Test 1\n");

      n = 0;
      fnLen = 0;
      lnLen = 0;
      
      while (line[n] != ',') {
         lastName[lnLen++] = line[n++];
      }
      n++;
      while (line[n] != ',') {
         firstName[fnLen++] = line[n++];
      }
      for (n = 0; n < fnLen; n++) {
         newLine[n] = firstName[n];
      }
      newLine[n] = ' ';
      for (n = 0; n < lnLen; n++) {
         newLine[n+fnLen+1] = lastName[n];
      }
      n = lnLen + fnLen + 1;
      while (line[n]) {
         newLine[n] = line[n];
         n++;
      }
      newLine[n] = '\0';
      
      fputs(newLine, fidW);
      //puts(newLine);
   }
   
   return 0;
}
