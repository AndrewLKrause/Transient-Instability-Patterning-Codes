clear;
%Value of q, Turing bifurcation point, and initial beta
%q = 0.0433;beta = 0.8087; beta_start=beta;Turing = 0.80861;
q = 0.0196639;beta = 0.4781; beta_start=beta;Turing = 0.478073604;
%q = 0.061122;beta = 1.05; beta_start=beta;Turing = 1.0253;
%q = 0.0804361;beta = 1.26; beta_start=beta;Turing = 1.2423;


%Domain geometry
L = 15;
dimension = 2;m=200;dx=L/(m-1);

%Determine a small parameter step in beta
dbeta = beta/10000; beta = beta+dbeta;

etas = [1e-1, 1e-3, 1e-5, 1e-7, 1e-9];
i_etas = length(etas);
%Loop until the energy is nearly zero (i.e. the solution is nearly
%homogeneous) for each level of the perturbation
E = 10; k=1;
betas = [];

%Iterate until all heterogeneity norms ('energy' E or Es) are small
while(E>1e-6)
    %Decrement beta
    beta = beta-dbeta

    %Iterate through the different values of eta, the size of the initial
    %perturbation
    for i=1:i_etas
        %Always simulate the first time. Stop simulating if a previous
        %value of beta led to the homogeneous equilibrium, as any further
        %simulations also will.
        if(k==1 || Es(k-1,i)>1e-6)
            eta = etas(i)
            tic
            [u,v,x,T] = RunSimEta(dimension,q,beta, L,m, eta);
            toc
            Es(k,i) = Energy(u(end,:),dimension,dx,m);
        else
            Es(k,i) = Es(k-1,i);
        end
    end
    E = max(Es(k,:));
    Es
    k = k+1;
    betas = [betas, beta];
end

beta_final = beta;


%Plot the points of stable solution energies, and the Turing line
close all;
figure; hold on

%This gives different symbols for each perturbation size NOTE IT ONLY WORKS
%FOR 3 VALUES of eta at the moment.
syms = ['+', 'x', 'o', '*','square'];
for i=1:i_etas
    plot(betas,Es(:,i),['--',syms(i)],'linewidth', 2,'markersize',12);
end
xlabel('$\beta$','interpreter','latex')
ylabel('$||\nabla u||_{L^2}$','interpreter','latex')
set(gca,'fontsize',20)
axis tight
plot([Turing, Turing], [0, max(max(Es))],'r','linewidth', 2)
h = legend('$\eta=10^{-1}$', '$\eta=10^{-3}$','$\eta=10^{-5}$','$\eta=10^{-7}$', '$\eta=10^{-9}$');
set(h,'interpreter','latex')
set(h,'location','east')
box on
xticks([0.4771, 0.4775, 0.478])



