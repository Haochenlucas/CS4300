function plot_Ut(Ut_name)
load("Uts.mat");
Ut = eval(Ut_name);
figure;
for i = 1:16
    Ct = Ut(:,i);
    plot(Ct);
    hold on;
end
legend('Cell(1,1)','Cell(2,1)','Cell(3,1)','Cell(4,1)'...
      ,'Cell(1,2)','Cell(2,2)','Cell(3,2)','Cell(4,2)'...
      ,'Cell(1,3)','Cell(2,3)','Cell(3,3)','Cell(4,3)'...
      ,'Cell(1,4)','Cell(2,4)','Cell(3,4)','Cell(4,4)');
title('Utilities for Each Cell Calculated Over Iterations')
xlabel('Iteration')
ylabel('Utilities (gamma = 0.999999)')
xlim(xlim * 1.25)
set(gcf, 'Position', [100, 100, 700, 500])
saveas(gcf, strcat(Ut_name,'.png'));