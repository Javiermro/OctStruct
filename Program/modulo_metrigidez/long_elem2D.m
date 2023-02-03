function lelem = long_elem2D(xnodi,ynodi,xnodf,ynodf)
cx=xnodf-xnodi;
cy=ynodf-ynodi;
lelem=sqrt(cx^2 + cy^2);
