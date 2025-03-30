function [u,v,x,T] = RunSim(dimension,q, beta, L, U0)

%parameters in the reaction kinematics
D_u = 0.6; D_v = 0.6;
k_1 = 0.4; k_2 = 0.6; c = 0.8;
%q = 0.0433; beta = 0.81;

%Set the number of dimensions (1D or 2D)
%dims=1;
%Number of gridpoints per dimension
%m=4000;
%L=50;


%Number of gridpoints per dimension
m=100;
%L=15*sqrt(5);

rng(1);

%Total number of gridpoints; varies by dimension as:
%2D make N=m^2; 1D make N=m;
if(dimension==1)
N=m;
elseif(dimension==2)
N=m^2;
end

%Spatial step size
dx=L/(m-1);

%Spatial domain (needed for plotting only)
x=linspace(0,L,m);

%Time interval to solve the equations on
T=linspace(0,1e4,1e3);

% (Sparse) Laplacian matrix
e=ones(m,1);
Lap=spdiags([e,-2*e,e],[1,0,-1],m,m);
Adv=spdiags([e,-e],[1,-1],m,m);

%periodic boundary conditions
%Lap(1,end)=1;
%Lap(end,1)=1;
%Adv(1,end)=-1;
%Adv(end,1)=1;

%Neumann
Lap(1,1)=-1;
Lap(end,end)=-1;
Adv(1,1)=-1;
Adv(end,end)=1;

%Indices corresponding to u variable and v variable. THis lets us stack them both in a vector U and write u = U(ui) and v = U(vi).
ui=1:N;
vi=N+1:2*N;

%Reaction kinetics
f=@(u,v)-k_1*u-q*u.*abs(u)+k_2*v;
g=@(u,v)k_1*u-k_2*v+c;

%Chemotactic sensitivity function
chi = @(U)beta*U;

%beta = 3.9*((1+uss^2)/uss)*beta;
%chi = @(U)beta*U./(1+U.^2);
if(dimension==1)
    %1D Laplacian
    Lap = (1/dx)^2*Lap;
    Adv=(1/(2*dx))*Adv;
    
    F = @(t,U)[f(U(ui),U(vi)) + D_u*Lap*U(ui) -...
    (chi(U(ui)).*(Lap*U(vi)) + (Adv*(chi(U(ui)))).*(Adv*U(vi)));
    g(U(ui),U(vi)) + D_v*Lap*U(vi)];
elseif(dimension==2)
    %2d Laplacian
    I = speye(m);
    Advx = (1/(2*dx))*kron(Adv,I);
    Advy = (1/(2*dx))*kron(I, Adv);
    Lap = (1/dx)^2*(kron(Lap,I) + kron(I, Lap));

    %Put together the reaction kinetics+diffusion terms into a big vector
    F = @(t,U)[f(U(ui),U(vi)) + D_u*Lap*U(ui) -...
    (chi(U(ui)).*(Lap*U(vi)) +...
    (Advx*(chi(U(ui)))).*(Advx*U(vi)) + (Advy*(chi(U(ui)))).*(Advy*U(vi)));
    g(U(ui),U(vi)) + D_v*Lap*U(vi)];
end

rng(1);

%If the initial condition provided is [], then use the homogeneous steady
%state and perturb it randomly.
if(isempty(U0))
    uss = sqrt(c/q); vss = uss*(q*uss+k_1)/k_2;
    sigma=1e-1;
    U0 = [uss*(1+sigma*randn(N,1));vss*(1+sigma*randn(N,1))];
end

%Alternative 'large' initial condition
%BMPu = 0.5*reshape(exp(100*(1-((x-L/4).^2+(x-L/4)'.^2)/L^2))/exp(100),N,1);
%BMPv = 0.5*reshape(exp(100*(1-((x-3*L/4).^2+(x-3*L/4)'.^2)/L^2))/exp(100),N,1);
%U0 = [uss*(1+BMPu); vss*(1+BMPv)];

%Jacobian sparsity pattern
JacSparse=sparse([Lap,Lap;eye(N),Lap]);
odeOptions=odeset('JPattern',JacSparse,'RelTol',1e-9,'AbsTol',1e-9);%,'maxstep',0.1);
[T,U]=ode15s(F,T,U0,odeOptions);


u=U(:,ui);v=U(:,vi);
