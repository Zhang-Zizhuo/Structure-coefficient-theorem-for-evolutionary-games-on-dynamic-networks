function Extended_Data_Figure_1_Panel_f

blue = [0, 92, 171] / 256;
red = [200, 40, 40] / 256;
tick_font_size = 21;
Marker_Size = 18;


filepath_s_dictator = "Data\simu_static_Dictator_delta=0.5.txt";
filepath_d_dictator = "Data\simu_dynamic_Dictator_delta=0.5.txt";

M_s_dictator = readmatrix(filepath_s_dictator);
M_d_dictator = readmatrix(filepath_d_dictator);

x = M_s_dictator(1,:);
ys = M_s_dictator(2,:);
yd = M_d_dictator(2,:);

figure;
plot(x, yd, 's', 'MarkerSize',Marker_Size, 'MarkerFaceColor', blue, 'MarkerEdgeColor', 'none');
hold on;
plot(x, ys, 's', 'MarkerSize',Marker_Size, 'MarkerFaceColor', red, 'MarkerEdgeColor', 'none');



set(gca,'FontSize',tick_font_size);

set(gcf,'Color','w');
set(gca,'Color','w');

% axis([100 160 0.10 0.16]);
box on;
pbaspect([1 1 1]);
ytickformat('%.2f');

title('$\delta=0.5$', 'FontSize', 21, 'Interpreter','latex');
xlabel('Core periphery, $N_p$', 'FontSize', 21, 'Interpreter','latex');
ylabel('Altruism, $\bar{p}$', 'FontSize', 21, 'Interpreter','latex');
