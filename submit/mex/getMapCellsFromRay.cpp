/* Daniel D. Lee and Alex Kushleyev */
#include "mex.h"
#include <string.h>

double * xio = NULL;
double * yio = NULL;

#define MAX_NUM_CELLS 3000000

void mexExit(void)
{
  printf("exiting getMapCellsFromRay\n");
  if (xio) delete [] xio; xio = NULL;
  if (yio) delete [] yio; yio = NULL;
}

//Bresenham's line algorithm
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] ){ 


    if (!xio)
    {
      xio = new double[MAX_NUM_CELLS];
      yio = new double[MAX_NUM_CELLS];
      mexAtExit(mexExit);
    }

    int x0t = *mxGetPr(prhs[0]); 
    int y0t = *mxGetPr(prhs[1]);

    double * xis = mxGetPr(prhs[2]);
    double * yis = mxGetPr(prhs[3]);
    int nPoints = mxGetNumberOfElements(prhs[2]);

    double * pxio = xio;
    double * pyio = yio;

    for (int ii=0; ii<nPoints; ii++)
    {
      int x0 = x0t;
      int y0 = y0t;

      //int x1 = *mxGetPr(prhs[2]);    
      //int y1 = *mxGetPr(prhs[3]);
      int x1 = (int)*xis++;
      int y1 = (int)*yis++;    

      bool steep = abs(y1 - y0) > abs(x1 - x0);
      if(steep){
          int temp = x0;
          x0 = y0;
          y0 = temp;
          temp = x1;
          x1 = y1;
          y1 = temp;
      }
      if(x0 > x1){
          int temp = x0;
          x0 = x1;
          x1 = temp;
          temp = y0;
          y0 = y1;
          y1 = temp;
      }
      int deltax = x1 - x0;
      int deltay = abs(y1 - y0);
      float error = deltax / 2;
      int y = y0;
      int ystep;
      if(y0 < y1)
          ystep = 1;
      else
          ystep = -1;

      //int num_pts = x1-x0-1;
      //plhs[0] = mxCreateDoubleMatrix(num_pts, 2, mxREAL);
      //double* cells = mxGetPr(plhs[0]);
      
      if(steep){
          for(int x=x0; x<(x1); x++){
              *pxio++ = y;
              *pyio++ = x;
              //cells[x-x0] = y;
              //cells[num_pts + x-x0] = x;
              error = error - deltay;
              if(error < 0){
                  y += ystep;
                 error += deltax;
              }
          }
      }
      else{
          for(int x=x0; x<(x1); x++){
              *pxio++ = x;
              *pyio++ = y;
              //cells[x-x0] = x;
              //cells[num_pts + x-x0] = y;
              error = error - deltay;
              if(error < 0){
                  y += ystep;
                 error += deltax;
              }
          }
      }
    }

    int numCells = pxio - xio;

    //printf("generated %d cells\n",numCells);

    plhs[0] = mxCreateDoubleMatrix(numCells,1,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(numCells,1,mxREAL);

    memcpy(mxGetPr(plhs[0]),xio,numCells*sizeof(double));
    memcpy(mxGetPr(plhs[1]),yio,numCells*sizeof(double));
    return;
}
