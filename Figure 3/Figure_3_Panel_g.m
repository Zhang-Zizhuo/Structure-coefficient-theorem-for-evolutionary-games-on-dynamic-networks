function Figure_3_Panel_g

filename = 'C:\Users\Lenovo\Desktop\CP_Parameter_k (t=10).txt';
L = dlmread(filename);

k = 2:1:80;

dense_sample = 2:2:79;
k = k(dense_sample);
L = L(:, dense_sample);


Lambda_static = L(1:3, :);
Lambda_dynamic = L(4:6, :);


%%  Calculate the derivative of the indicators \bar{p} with respect to \delta
dPs_Dic = ( -2 * Lambda_static(2,:) - Lambda_static(3,:) ) / 12;
dPd_Dic = ( -2 * Lambda_dynamic(2,:) - Lambda_dynamic(3,:) ) / 12;


delta = 0.0025;   %% Selection intensity


%%  Calculate $\bar{p} 
Ps_Dic = 0.5 + delta * dPs_Dic;
Pd_Dic = 0.5 + delta * dPd_Dic;


red = [213, 94, 0]/256;
blue = [0, 92, 171] / 256;
tick_font_size=21;
label_font_size=21;
Marker_Size = 18;




figure;
plot(k, Pd_Dic, '.', 'Color', blue, 'MarkerSize', Marker_Size);
hold on;
plot(k, Ps_Dic, '.', 'Color', red, 'MarkerSize', Marker_Size);

axis([0 80 0.383 0.50]);
ytickformat('%.2f');

set(gca, 'FontSize', tick_font_size);

xlabel('Periphery size, $N_p$', 'Interpreter', 'latex', 'FontSize', label_font_size); 
ylabel('Altruism, $\bar{p}$', 'Interpreter', 'latex', 'FontSize', label_font_size); 

set(gcf, 'Color', 'w');  
set(gca, 'Color', 'w');  

pbaspect([1 1 1]);

xtickangle(0);




