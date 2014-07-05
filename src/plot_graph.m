function plot_graph(A, path_route, path_flow,basic_flow, x, y, cfildp_L, enumL, E_opponent)
 
    [n n]=size(A);
    
    %        w=floor(sqrt(n));       
%        h=floor(n/w);        
%         x=[];
%         y=[];
%         for i=1:h           %使产生的随机点有其范围，使显示分布的更广
%             for j=1:w
%                 x=[x 10*rand(1)+(j-1)*10];
%                 y=[y 10*rand(1)+(i-1)*10];
%             end
%         end
%         ed=n-h*w;
%         for i=1:ed
%            x=[x 10*rand(1)+(i-1)*10]; 
%            y=[y 10*rand(1)+h*10];
%         end
    
    
    figure; 
    pos =  get (gcf,'Position');
    pos(1) = 100;
    pos(2) = 100;
    pos(4) = 1.5 * pos(4);
    pos(3) = 2.8 * pos(3);
    set (gcf,'Position',pos);

    subplot(1, 2, 1);
    plot(x,y,'r*', 'color', 'b', 'MarkerSize', 5,  'LineWidth', 1);       
    hold on;
    title('本文算法结果'); 
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);
    for i = 1:length(cfildp_L)
        plot(x(cfildp_L(i, 1)) ,y(cfildp_L(i, 1)),'ro', 'MarkerSize', cfildp_L(i, 2)/250, 'color', 'r',  'LineWidth', 10);   
        hold on;
    end
    

    for i=1:n
        for j=i:n
            if A(i,j)~=0 && A(i, j) ~= +inf
                c=num2str(A(i,j));                      %将A中的权值转化为字符型              
                text((x(i)+x(j))/2,(y(i)+y(j))/2,c,'Fontsize',10);  %显示边的权值
                line([x(i) x(j)],[y(i) y(j)], 'color', 'k');      %连线
            end
            text(x(i) + 0.01, y(i)+ 0.01 ,num2str(i),'Fontsize',14);   %显示点的序号            
            hold on;
        end
    end
        
    for k = 1: length(path_route)
        for l = 2:length(path_route{k})
            i = path_route{k}(l-1);
            j = path_route{k}(l);
            line([x(i) x(j)],[y(i) y(j)], 'color', 'g', 'LineWidth', path_flow(k) * 3 /basic_flow);
            hold on;
        end
    end
    plot(x,y,'r*', 'color', 'b', 'MarkerSize', 5,  'LineWidth', 1); 
    
    for i = 1:length(E_opponent)
        plot(x(E_opponent(i, 1)) ,y(E_opponent(i, 1)),'rd', 'MarkerSize', E_opponent(i, 2)/500, 'color', 'k',  'LineWidth', 5);   
        hold on;
    end
    legend;
    
    
    
    
    subplot(1, 2, 2);
    plot(x,y,'r*', 'color', 'b', 'MarkerSize', 5,  'LineWidth', 1);         
    hold on;
    title('枚举算法结果'); 
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);
    for i = 1:length(enumL)
        plot(x(enumL(i, 1)) ,y(enumL(i, 1)),'ro', 'MarkerSize', enumL(i, 2)/250, 'color', 'r', 'LineWidth', 10);   
        hold on;
    end
    


    for k = 1: length(path_route)
        for l = 2:length(path_route{k})
            i = path_route{k}(l-1);
            j = path_route{k}(l);
            line([x(i) x(j)],[y(i) y(j)], 'color', 'g', 'LineWidth',  path_flow(k) * 3 /basic_flow);
            hold on;
        end
    end
    for i=1:n
        for j=i:n
            if A(i,j)~=0 && A(i, j) ~= +inf
                c = num2str(A(i,j));                      %将A中的权值转化为字符型              
                text((x(i)+x(j))/2,(y(i)+y(j))/2,c,'Fontsize',10);  %显示边的权值
                line([x(i) x(j)],[y(i) y(j)], 'color', 'k');      %连线
            end
            text(x(i)+ 0.01, y(i) + 0.01, num2str(i),'Fontsize',14,'color','k');   %显示点的序号            
            hold on;
        end
    end
    
    plot(x,y,'r*', 'color', 'b', 'MarkerSize', 5,  'LineWidth', 1); 
    for i = 1:length(E_opponent)
        plot(x(E_opponent(i, 1)) ,y(E_opponent(i, 1)),'rd', 'MarkerSize', E_opponent(i, 2)/500, 'color', 'k',  'LineWidth', 5);    
        hold on;
    end
    

        
end