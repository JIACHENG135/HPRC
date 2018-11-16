function [N,Cb,Cs] = tensegkite()
Cs = [-1 1 0 0;
       0 -1 1 0;
       0 0 -1 1;
       1 0 0 -1];
Cb = [0 -1 0 1;
      -1 0 1 0];
N = [1 0 -1 0;
     0 1 0 -1;
     0 0 0  0];
end