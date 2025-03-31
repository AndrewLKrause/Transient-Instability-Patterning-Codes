function E = Energy(u,dimension,dx,m)

    if(dimension==2)
        u = reshape(u,m,m);
        [Fx, Fy] = gradient(u,dx);
        E = sqrt(trapz(dx*trapz(dx*(Fx.^2+Fy.^2))));
    else
        Fx = gradient(u,dx);
        E = sqrt(trapz(dx*sqrt(Fx.^2)));
    end
end