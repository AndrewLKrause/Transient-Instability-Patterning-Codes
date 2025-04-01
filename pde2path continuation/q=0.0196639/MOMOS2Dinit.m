function p=MOMOS2Dinit(p, lx, ly, npoints, par, modd)
    p = stanparam(p);
    screenlayout(p);
    p.mod = modd;
    if strcmp(p.mod, 'hom')
        p = setfn(p, 'hom');
    else
        p = setfn(p, 'p');
    end
    p.nc.lammin = 0.0;
    p.nc.lammax = 1.5;
    p.nc.bisecmax = 50;
    p.nc.neq = 2;
    p.sw.sfem = - 1;
    p.fuha.sG = @sG;
    p.fuha.sGjac = @sGjac; 
    % sw.sym = 2;
    p.pdeo = stanpdeo2D(lx, ly, npoints, npoints);
    p.np = p.pdeo.grid.nPoints;
    p.nu = p.np*p.nc.neq; 
    p = setfemops(p);
    p.nc.ilam = 5;
    p.sol.xi = 1/p.nu;
    if strcmp(p.mod, 'hom')
        p.sol.ds = 1e-4;
    else
        p.sol.ds = - 1e-4;
    end
    p.nc.dsmax = 1e-2; 
    if strcmp(p.mod, 'hom')
        u = sqrt(par(3)/par(4))*ones(p.np, 1);
        v = (par(1)/par(2)*sqrt(par(3)/par(4)) + par(3)/par(2))*ones(p.np, 1); % hom.soln 
    else
        load U.mat
        [po, tr, e] = getpte(p);
        p.mesh.bp = po;
        p.mesh.bt = tr;
        p.mesh.be = e;
        x = linspace(- 5, 5, 200);
        U = interp2(x, x, reshape(u_end_2, 200, 200), po(1, :), po(2, :));
        V = interp2(x, x, reshape(v_end_2, 200, 200), po(1, :), po(2, :));
        u = reshape(U, npoints^2, 1);
        v = reshape(V, npoints^2, 1);
    end
    p.u = [u; v; par'];
    p.nc.nsteps = 200;
    p.plot.pmod = 0;
    p.file.smod = 5;
end