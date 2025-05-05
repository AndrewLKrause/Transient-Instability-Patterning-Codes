## Direct simulation codes
To simulate the system, you call `[u,v,x,T] = RunSim(dimension,q, beta, L, m,U0)` with the given parameters, where `U0` is a $2m$ dimensional vector of initial data. Running `PlotSim.m` will then plot the solution appropriately in 1D or 2D. The two other codes in the top-level directory are used to perform direct continuation runs to trace stable branches in order to explore routes towards the bistable regime in different settings (i.e. varying parameters and dimensions). The `.mat` files contain data from previous simulations, as well as data from these direct continuation runs (i.e. plots only tracking stable branches). By default, Neumann boundary conditions are used throughout, but this can be changed by uncommenting the lines underneath the comment "periodic boundary conditions". 

## Numerical Continuation via pde2path
To run the files for continuation, you first have to download pde2path (see [https://pde2path.uol.de/index.html](https://pde2path.uol.de/index.html)) and load it into the current path in Matlab.

In the folder `pde2path continuation`, there are two folders. Both of them work in the same way so the process will be explained for the folder called `q=0.0196639` only.

We focus on continuing along one spatially homogeneous equilibria.

You can run the file `cmds2D.m` in order to obtain the continuation for this steady state.
