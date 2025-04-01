function Gu=sGjac(p,u)
    par = u(p.nu + 1:end); % identify parameters
    n = p.np;
    [f1u, f1v, f2u, f2v] = njac(p, u, par); % loading the non-linear jacobian in nodal form, see below
    Fu = [[spdiags(f1u, 0, n, n), spdiags(f1v, 0, n, n)];
          [spdiags(f2u, 0, n, n), spdiags(f2v, 0, n, n)]]; % nonlinear part of the jacobian
    [Kaux, ~, ~] = p.pdeo.fem.assema(p.pdeo.grid, u(1:p.np), 1, 1);
    Gu = kron([[par(6), 0]; [0, par(7)]], p.mat.K) - (kron([[0, par(5)]; [0, 0]], Kaux) + kron([[0, par(5)]; [0, 0]], p.mat.K)*u(1:p.nu)) - p.mat.M*Fu; % assemble the jacobian
end

function [f1u, f1v, f2u, f2v] = njac(p, u, par) % Jacobian for Schnakenberg, nodal version
    u1 = u(1:p.np); % identify solution component 1
    u2 = u(p.np + 1:2*p.np); % identify solution component 2
    par = u(p.nu + 1:end);
    % entries of the jacobian
    f1u = - par(1) - 2*par(4)*u1;
    f1v = par(2).*ones(size(u2)); 
    f2u = par(1).*ones(size(u2)); 
    f2v = - par(2).*ones(size(u2));
end