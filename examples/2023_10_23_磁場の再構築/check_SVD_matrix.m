clear all
close all

set(gcf,'Units','Pixels','Position',[0,30,2000,1000],'PaperSize',[1000/96*2.54,1000/96*2.54]);
a1 = axes('Units','Pixels','Position',[ 100, 100, 850, 850],'FontName','Times New Roman','FontSize',20);
a2 = axes('Units','Pixels','Position',[1100, 100, 850, 850],'FontName','Times New Roman','FontSize',20);
	box on;	hold on; grid on;
	xlim([-20,20]);
%	ylim([0.00001,1.0]);
%	set(gca,'YScale','log');

	xlabel('{\it z} (mm)','FontName','Times New Roman','FontSize',20);
	ylabel('{\it x} (mm)','FontName','Times New Roman','FontSize',20);

	Mx = 0;
	My = 0;
	Mz = 1;
	x = linspace(-20,20,100);
	y = linspace(-20,20,100);
	z = 0;
	MBz = [];
	for ny = [1:length(y)]
		mBz = pyrunfile("Magnets.py", "Bz", Mx=Mx, My=My, Mz=Mz, x1=x(1), y1=y(ny), z1=z, x2=x(end), y2=y(ny), z2=z, np=length(x));
		mBz = double(mBz);
		MBz = [MBz;mBz];
	end

	[xx,yy] = meshgrid(x,y);
	rr = sqrt(xx.^2+yy.^2);
	Bz0 = 1-tanh(rr./3-5);

	[U,S,V]=svd(MBz);
	Ut=transpose(U);
	S = [diag(1./diag(S)),zeros(size(V,1),size(U,1)-size(V,1))];
	S_Ut_B = S*Ut*Bz0(:);
	modes = 60;
	M = V(:,1:modes)*S_Ut_B(1:modes,:);

	MBz = [];
	z = 0;
	for ny = [1:length(y)]
		mBz = pyrunfile("Magnets.py", "Bz", Mx=Mx, My=My, Mz=Mz, x1=x(1), y1=y(ny), z1=z, x2=x(end), y2=y(ny), z2=z, np=length(x));
		mBz = double(mBz);
		MBz = [MBz;mBz];
	end
	Bz1 = MBz*M;

	Bz0 = reshape(Bz0,100,100);
	Bz1 = reshape(Bz1,100,100);

	axes(a1);
		[c,h] = contourf(xx,yy,Bz0,linspace(-0.5,4,30));
		caxis([-0.2,3.2])
	axes(a2);
		[c,h] = contourf(xx,yy,Bz1,linspace(-0.5,4,30));
		caxis([-0.2,3.2])
	print('-dpng','figure.png');

