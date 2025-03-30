close all;

if(dimension==1)
    plot(x,u(end,:),'linewidth',2); hold on
    ylabel('$u$',Interpreter='latex')
    xlabel('$x$',Interpreter='latex')

    set(gca,'fontsize',24);
    axis tight;
    

elseif(dimension==2)

    figure; imagesc(x,x,reshape(u(end,:),m,m));  colorbar;
    set(gca,'YDir','normal')
    xlabel('$x$',Interpreter='latex')
    ylabel('$y$',Interpreter='latex')
    set(gca,'fontsize',24);
    %clim([0 32]); hold on
    
    %axis off
end