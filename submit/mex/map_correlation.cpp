/*
  c = im_correlation(im, x_im, y_im, vp, xs, ys);

  MEX file to compute correlation arrays of (vp(1,:),vp(2,:),vp(3,:))
  in array im with limits x_im, y_im.

  Daniel D. Lee, 11/2010
  <ddlee@seas.upenn.edu>
*/

#include "mex.h"
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Check arguments */
  if (nrhs < 6)
    mexErrMsgTxt("Need six input arguments.");

  if (!mxIsInt8(prhs[0])) {
    mexErrMsgTxt("Map needs to be int8 array");
  }
  char *im = (char *)mxGetData(prhs[0]);
  int nx = mxGetM(prhs[0]);
  int ny = mxGetN(prhs[0]);

  double *x_im = mxGetPr(prhs[1]);
  double xmin = x_im[0];
  double xmax = x_im[mxGetNumberOfElements(prhs[1])-1];
  double xresolution = (xmax-xmin)/(nx-1);
  //printf("x: %.3f %.3f %.3f\n", xmin, xmax, xresolution);

  double *y_im = mxGetPr(prhs[2]);
  double ymin = y_im[0];
  double ymax = y_im[mxGetNumberOfElements(prhs[2])-1];
  double yresolution = (ymax-ymin)/(ny-1);
  //printf("y: %.3f %.3f %.3f\n", ymin, ymax, yresolution);

  double *vp = mxGetPr(prhs[3]);
  if (mxGetM(prhs[3]) != 3) {
    mexErrMsgTxt("Point array needs to contain 3 rows");
  }
  int np = mxGetN(prhs[3]);

  double *xs = mxGetPr(prhs[4]);
  int nxs = mxGetNumberOfElements(prhs[4]);

  double *ys = mxGetPr(prhs[5]);
  int nys = mxGetNumberOfElements(prhs[5]);

  plhs[0] = mxCreateDoubleMatrix(nxs, nys, mxREAL);
  double *cpr = mxGetPr(plhs[0]);
  for (int i = 0; i < nxs*nys; i++) {
    cpr[i] = 0.0;
  }

  for (int k = 0; k < np; k++) {
    double x0 = vp[3*k];
    double y0 = vp[3*k+1];

    for (int jy = 0; jy < nys; jy++) {
      double y1 = y0 + ys[jy];
      int iy = (int) round((y1-ymin)/yresolution);
      if ((iy < 0) || (iy >= ny)) continue;
      for (int jx = 0; jx < nxs; jx++) {
	double x1 = x0 + xs[jx];
	int ix = (int) round((x1-xmin)/xresolution);
	if ((ix < 0) || (ix >= nx)) continue;

	int index = ix + nx*iy;
	cpr[jx + nxs*jy] += im[index];
      }
    }
  }
}

