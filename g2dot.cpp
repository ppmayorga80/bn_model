#include <stdio.h>

int main(int argc,char **argv)
{
   /*
      Usar como:
      [g2dot] n m_adj m_cov
      where size(m_adj) = size(m_cov) = n*n
      
      example:
      cat [d2dot]  
      
   */
   int i,j;
   int n;
   int **A;
   float **C;
   
   //LEE EL DATO $n$
   scanf("%d",&n);
   
   //CREA MEMORIA DINAMICA
    A = new int*[n];
   *A = new int[n*n];
    C = new float*[n];
   *C = new float[n*n];
   
   for(i=1;i<n;i++)
   {
      A[i]=A[i-1]+n;
      C[i]=C[i-1]+n;
   }
   
   //LEE LOS DATOS
   for(i=0;i<n;i++)
      for(j=0;j<n;j++)
         scanf("%d",&A[i][j]);
   for(i=0;i<n;i++)
      for(j=0;j<n;j++)
         scanf("%f",&C[i][j]);
   
   // CALCULA LOS MIN,MAX
   float z1,z2;
   z1 = 1.0;        //set to the max value, to update successfully
   z2 = -1.0;       //set to the max value, to update successfully
   
   for(i=0;i<n;i++)
   {
      for(j=0;j<n;j++)
      {
         if(A[i][j]==0) continue;
         if(z1>C[i][j]) z1 = C[i][j];
         if(z2<C[i][j]) z2 = C[i][j];
      }
   }

   //CONVIERTE a anchos 1:10
   float w1=1;
   float w2=10;
   for(i=0;i<n;i++)
   {
      for(j=0;j<n;j++)
      {
         if(A[i][j]==0) continue;
         C[i][j] =  (C[i][j] - z1)/(z2-z1) * (w2-w1) + w1;
      }
   }
   
   //CREA LA ESTRUCTURA
   printf("digraph G {\n");
   printf("   center = 1;\n");
   printf("   size=\"10,10\";\n");

   char labels[2][100]={
      "edad",
      "sexo"
   };
   
   //IMPRIME LOS LABELS
   int k=1;
   for(i=0;i<n;i++)
   {
      printf("\t%d\t[ label = \"",i+1);
      if(i<2) printf("%s",labels[i]);
      else    printf("p%02d",k++);
      printf("\" ];\n");
   }
   
   //IMPRIME LOS ARROWS
   int pw=4;
   int c=0;
   int c1=0x80;   //MIN COLOR GRIS
   int c2=0x00;   //MAX COLOR NEGRO
   for(i=0;i<n;i++)
   {
      for(j=0;j<n;j++)
      {
         if(A[i][j]!=0)
         {
            pw = (int)(C[i][j]+0.5);
            printf("aqui\n");
            c = (int)((float)(pw-w1)/(float)(w2-w1)*(float)(c2-c1)+(float)c1);
            printf("%d -> %d [penwidth=%d,color=\"#%02X%02X%02X\",label=\" %2d\"];\n",i+1,j+1,pw,c,c,c,pw);
         }
      }
   }

   //FIN DEL ARCHIVO
   printf("};\n\n");
      
   //LIBERA MEMORIA   
   delete[] *A;
   delete[]  A;
   delete[] *C;
   delete[]  C;
   return 0;
}

