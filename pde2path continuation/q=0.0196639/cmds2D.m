%% 1 - initialising the problem
changedir = 1;

if changedir==1
    sleep()
end

    close all
    clear all
    clc
    keep pphome;
    p = [];
    modd = 'hom';
    % k1, k2, c, q, beta, D1, D2
    if strcmp(modd, 'hom')
        par = [0.4, 0.6, 0.8, 0.0196639, 0.47, 0.6, 0.6]; 
    else
        par = [0.4, 0.6, 0.8, 0.0433, 0.8, 0.6, 0.6]; 
    end
    lx = 7.5;
    ly = lx;
    npoints = 90;
    p.sw.jac = 0;
    p = MOMOS2Dinit(p, lx, ly, npoints, par, modd); % also use nper=80, 120, 160, 200

%% 2 - continue trivial branch to find BP 
    tic;
    if strcmp(modd, 'hom')
        p.nc.dsmax = 1e-4;
        p.file.smod = 1;
        p.sw.bifcheck = 1;
        p = cont(p, 90);
    else
        p.nc.tol = 2e-3;
        p.nc.neig = 10;
        p = cont(p, 5);
    end
    toc

    sleep()

%% 3 - switch to periodic branch and continue. For comparison of \ and 
    % lssbel, switch off stuff not related to lss 
    p = swibra('hom', 'bpt3', 'homb3', - 0.01);
    p.nc.dsmax = 1e-2;
    p.nc.dsmin = 1e-10;
    p.sw.jac = 0;
    p.sw.spcalc = 1;
    p.sw.foldcheck = 1;
    p.sw.bifcheck = 2; 
    p.sw.verb = 2;
    p0 = p;
    t1 = tic;
    p = cont(p, 350);
    t1 = toc(t1); % cont with default settings

    p = swibra('homb3', 'bpt1', 'homb31', - 0.01);
    p.nc.dsmax = 1e-2;
    p.nc.dsmin = 1e-10;
    p.sw.jac = 0;
    p.sw.spcalc = 1;
    p.sw.foldcheck = 1;
    p.sw.bifcheck = 2; 
    p.sw.verb = 2;
    p0 = p;
    t1 = tic;
    p = cont(p, 350);
    t1 = toc(t1); % cont with default settings

%% plots    
    lw = 4;
    lwst = 4;
    lwun = 4;
    
    ps = 100;
    fs = 40;
    figure(3)
    plotbra('hom', 'pt80', 3, 0, 'tyun', ':k', 'tyst', '-k', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    plotbra('homb3', 'pt350', 3, 0, 'tyun', '-b', 'tyst', '-r', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    plotbra('homb31', 'pt300', 3, 0, 'tyun', '-b', 'tyst', '-r', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    xlabel('$\beta$', 'Interpreter', 'latex')
    ylabel('$||\nabla u||_{L^2}$', 'Interpreter', 'latex')
    set(gca, 'fontsize', fs)
    xlim([0.469, 0.5])