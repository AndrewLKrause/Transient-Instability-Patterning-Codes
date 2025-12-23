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
        par = [0.4, 0.6, 0.8, 0.0433, 0.805, 0.6, 0.6]; 
    else
        par = [0.4, 0.6, 0.8, 0.0433, 0.8, 0.6, 0.6]; 
    end
    lx = 30.0;
    h = 0.03;
    p.sw.jac = 0;
    p = MOMOS1Dinit(p, lx, h, par, modd); % also use nper=80, 120, 160, 200

%% 2 - continue trivial branch to find BP 
    tic;
    if strcmp(modd, 'hom')
        p.nc.dsmax = 3e-4;
        p.file.smod = 1;
        p = cont(p, 150);
    else
        p.nc.tol = 2e-3;
        p.nc.neig = 10;
        p = cont(p, 5);
    end
    toc

    % sleep()

%% 3 - switch to periodic branch and continue. For comparison of \ and 
    % lssbel, switch off stuff not related to lss 
    p = swibra('hom', 'bpt4', 'homb4', 1e-2);
    p.nc.dsmax = 1e-2;
    p.nc.dsmin = 1e-10;
    p.sw.jac = 0;
    p.sw.spcalc = 1;
    p.sw.foldcheck = 1;
    p.sw.bifcheck = 2; 
    p.sw.verb = 2;
    p0 = p;
    t1 = tic;
    p = cont(p, 200);
    t1 = toc(t1); % cont with default settings

    p = swibra('hom', 'bpt9', 'homb9', - 1e-3);
    p.nc.dsmax = 1e-2;
    p.nc.dsmin = 1e-10;
    p.sw.jac = 0;
    p.sw.spcalc = 1;
    p.sw.foldcheck = 1;
    p.sw.bifcheck = 2; 
    p.sw.verb = 2;
    p0 = p;
    t1 = tic;
    p = cont(p, 200);
    t1 = toc(t1); % cont with default settings

    p = swibra('hom', 'bpt12', 'homb12', - 1e-3);
    p.nc.dsmax = 1e-2;
    p.nc.dsmin = 1e-10;
    p.sw.jac = 0;
    p.sw.spcalc = 1;
    p.sw.foldcheck = 1;
    p.sw.bifcheck = 2; 
    p.sw.verb = 2;
    p0 = p;
    t1 = tic;
    p = cont(p, 200);
    t1 = toc(t1); % cont with default settings

    p = swibra('hom', 'bpt19', 'homb19', -1e-3);
    p.nc.dsmax = 1e-2;
    p.nc.dsmin = 1e-10;
    p.sw.jac = 0;
    p.sw.spcalc = 1;
    p.sw.foldcheck = 1;
    p.sw.bifcheck = 2; 
    p.sw.verb = 2;
    p0 = p;
    t1 = tic;
    p = cont(p, 200);
    t1 = toc(t1); % cont with default settings

    p = swibra('hom', 'bpt29', 'homb29', - 1e-3);
    p.nc.dsmax = 1e-2;
    p.nc.dsmin = 1e-10;
    p.sw.jac = 0;
    p.sw.spcalc = 1;
    p.sw.foldcheck = 1;
    p.sw.bifcheck = 2; 
    p.sw.verb = 2;
    p0 = p;
    t1 = tic;
    p = cont(p, 200);
    t1 = toc(t1); % cont with default settings

    % p = p0;
    % bw = 0;
    % beltol = 1e-4;
    % belmaxit = 5;
    % p = setbel(p, bw, beltol, belmaxit, @lss); % lssbel 
    % t2 = tic;
    % p = cont(p, 50);
    % t2 = toc(t2); 
    % fprintf('t1 = %g, t2 = %g\n', t1, t2);
    % plotsol(p, 1, 1, 1); 

%% plots    
    lw = 4;
    lwst = 4;
    lwun = 4;
    
    ps = 100;
    fs = 40;
    figure(3)
    plotbra('hom', 'pt150', 3, 0, 'tyun', ':k', 'tyst', '-k', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', 3);
    plotbra('homb4', 'pt200', 3, 0, 'tyun', '-b', 'tyst', '-r', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    % plotbra('homb9', 'pt200', 3, 0, 'tyun', '-b', 'tyst', '-r', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    plotbra('homb12', 'pt200', 3, 0, 'tyun', '-b', 'tyst', '-r', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    % plotbra('homb19', 'pt200', 3, 0, 'tyun', '-b', 'tyst', '-r', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    plotbra('homb29', 'pt200', 3, 0, 'tyun', '-b', 'tyst', '-r', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    % plotbra('homb31', 'pt300', 3, 0, 'tyun', '-b', 'tyst', '-r', 'ms', 0, 'fms', 0, 'lwst', lwst, 'lwun', lwun);
    xlabel('$\beta$', 'Interpreter', 'latex')
    ylabel('$||\nabla u||_{L^2}$', 'Interpreter', 'latex')
    box on
    set(gca, 'fontsize', fs)
    xlim([0.805, 0.84])