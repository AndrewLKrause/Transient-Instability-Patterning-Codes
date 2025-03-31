
tic
%Value of q, Turing bifurcation point, and initial beta
q = 0.0433;beta = 0.84; beta_start=beta;Turing = 0.80861;
%q = 0.0196639;beta = 0.5; beta_start=beta;Turing = 0.47719;
%q = 0.061122;beta = 1.05; beta_start=beta;Turing = 1.0253;
%q = 0.0804361;beta = 1.26; beta_start=beta;Turing = 1.2423;


%Domain geometry
L = 15;
dimension = 2;m=200;dx=L/(m-1);

%Run an initial simulation
[u,v,x,T] = RunSim(dimension,q,beta, L,m, []);

%Extract the final solution for t=10^5 time units
U0 = [u(end,:),v(end,:)]';

%Compute the initial norm of this solution
E = Energy(u(end,:),dimension,dx,m)
Es = E;

%Determine a small parameter step in beta
dbeta = beta/5000;
k = 2;

%Loop until the energy is nearly zero (i.e. the solution is nearly
%homogeneous)
while(E>1e-6)
    beta = beta-dbeta
    [u,v,x,T] = RunSim(dimension,q,beta, L,m, U0);
    E = Energy(u(end,:),dimension,dx,m)
    Es(k) = E;
    k = k+1;
    U0 = [u(end,:),v(end,:)]';
end

%Remove the last energy and value of beta
beta_final = beta+dbeta;
Es = Es(1:end-1);

%Plot the curve of stable solution energies, and the Turing line
close all;
plot(linspace(beta_start,beta_final,length(Es)),Es,'linewidth', 2);
xlabel('$\beta$','interpreter','latex')
ylabel('$||\nabla u||_{L^1}$','interpreter','latex')
set(gca,'fontsize',22)
axis([beta_final beta_start 0 max(Es)])
hold on
plot([Turing, Turing], [0, max(Es)],'r','linewidth', 2)