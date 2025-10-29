clear all
close all

delete('*.png');

for hgap = [50:50:300];
for modes = [200:100:600];

	load('Map_interpolation/B_map_I=130A_x=0mm.mat');

	Ny = 2*10+1;
	Nz = 2*15+1;
	Y = linspace(-100,850,Ny)/1000;
	Z = linspace(-450,1420,Nz)/1000;
	[Y,Z] = meshgrid(Y,Z);
	X = hgap*ones(size(Y))/1000;

	QUAD = [];
	for ny = [1:Ny-1]
		for nz = [1:Nz-1]
			QUAD = [QUAD,[(ny-1)*Nz+nz; (ny-1)*Nz+nz+1; (ny-0)*Nz+nz+1; (ny-0)*Nz+nz]];
		end
	end

	for n = [1:size(QUAD,2)]
		X1(n) = X(QUAD(1,n));
		X2(n) = X(QUAD(2,n));
		X3(n) = X(QUAD(3,n));
		X4(n) = X(QUAD(4,n));

		Y1(n) = Y(QUAD(1,n));
		Y2(n) = Y(QUAD(2,n));
		Y3(n) = Y(QUAD(3,n));
		Y4(n) = Y(QUAD(4,n));

		Z1(n) = Z(QUAD(1,n));
		Z2(n) = Z(QUAD(2,n));
		Z3(n) = Z(QUAD(3,n));
		Z4(n) = Z(QUAD(4,n));
	end

	if 0
		plot(Z_/1000,Y_/1000,'k.');
			hold on;
		plot(Z1,Y1,'r.');
		return
	end

	for n = [1:size(QUAD,2)]
		Gx(n,1) = mean(X(QUAD(:,n)));
		Gy(n,1) = mean(Y(QUAD(:,n)));
		Gz(n,1) = mean(Z(QUAD(:,n)));
	end

	Ox = X_/1000;
	Oy = Y_/1000;
	Oz = Z_/1000;

	if 0
		set(gcf,'Units','pixels','Position',[150,0,1100,1100]);
		set(gca,'Units','pixels','Position',[150,200,800,800]);

		for n = [1:length(X1)]
			h = patch([X1(n),X2(n),X3(n),X4(n)]*1000,[Y1(n),Y2(n),Y3(n),Y4(n)]*1000,[Z1(n),Z2(n),Z3(n),Z4(n)]*1000,'r');
			set(h,'LineWidth',0.1);
		end
			hold on;
		plot3(Ox*1000,Oy*1000,Oz*1000,'k.');

		axis equal;
		xlim([-hgap,hgap]);
		ylim([min(Y_),max(Y_)]);
		zlim([min(Z_),max(Z_)]);
		view(30,40);
		return
	end

	tic;
		[hx01,hy01,hz01] = Biot_Savart(Ox,Oy,Oz,-X1,-Y1, Z1,-X4,-Y4, Z4);
		[hx02,hy02,hz02] = Biot_Savart(Ox,Oy,Oz,-X4,-Y4, Z4,-X3,-Y3, Z3);
		[hx03,hy03,hz03] = Biot_Savart(Ox,Oy,Oz,-X3,-Y3, Z3,-X2,-Y2, Z2);
		[hx04,hy04,hz04] = Biot_Savart(Ox,Oy,Oz,-X2,-Y2, Z2,-X1,-Y1, Z1);

		[hx05,hy05,hz05] = Biot_Savart(Ox,Oy,Oz, X1,-Y1, Z1, X4,-Y4, Z4);
		[hx06,hy06,hz06] = Biot_Savart(Ox,Oy,Oz, X4,-Y4, Z4, X3,-Y3, Z3);
		[hx07,hy07,hz07] = Biot_Savart(Ox,Oy,Oz, X3,-Y3, Z3, X2,-Y2, Z2);
		[hx08,hy08,hz08] = Biot_Savart(Ox,Oy,Oz, X2,-Y2, Z2, X1,-Y1, Z1);

		[hx09,hy09,hz09] = Biot_Savart(Ox,Oy,Oz,-X1, Y1, Z1,-X2, Y2, Z2);
		[hx10,hy10,hz10] = Biot_Savart(Ox,Oy,Oz,-X2, Y2, Z2,-X3, Y3, Z3);
		[hx11,hy11,hz11] = Biot_Savart(Ox,Oy,Oz,-X3, Y3, Z3,-X4, Y4, Z4);
		[hx12,hy12,hz12] = Biot_Savart(Ox,Oy,Oz,-X4, Y4, Z4,-X1, Y1, Z1);

		[hx13,hy13,hz13] = Biot_Savart(Ox,Oy,Oz, X1, Y1, Z1, X2, Y2, Z2);
		[hx14,hy14,hz14] = Biot_Savart(Ox,Oy,Oz, X2, Y2, Z2, X3, Y3, Z3);
		[hx15,hy15,hz15] = Biot_Savart(Ox,Oy,Oz, X3, Y3, Z3, X4, Y4, Z4);
		[hx16,hy16,hz16] = Biot_Savart(Ox,Oy,Oz, X4, Y4, Z4, X1, Y1, Z1);

		Hx = hx01+hx02+hx03+hx04+hx05+hx06+hx07+hx08+hx09+hx10+hx11+hx12+hx13+hx14+hx15+hx16;
		Hy = hy01+hy02+hy03+hy04+hy05+hy06+hy07+hy08+hy09+hy10+hy11+hy12+hy13+hy14+hy15+hy16;
		Hz = hz01+hz02+hz03+hz04+hz05+hz06+hz07+hz08+hz09+hz10+hz11+hz12+hz13+hz14+hz15+hz16;

	disp(sprintf('SVD CPU time = %.1f sec',toc));

	tic;
		[U,S,V] = svd([Hx]);
		Ut = transpose(U);
		if size(V,1)>=size(U,1)
			St = [diag(1./diag(S));zeros(size(V,1)-size(U,1),size(U,1))];
		else
			St = [diag(1./diag(S)),zeros(size(V,1),size(U,1)-size(V,1))];
		end
	disp(sprintf('SVD CPU time = %.1f sec',toc));

%	modes = size(V,2);
	coff = St*(Ut*[Bx_]);
	I_svd = V(:,1:modes)*coff(1:modes,1);

	set(gcf,'Units','pixels','Position',[150,100,800,600]);
	set(gca,'Units','pixels','Position',[80,80,680,500],'FontName','times new roman','FontSize',20);
	hold on; box on; grid on;
	X = [0:10:40];
	for nx = [1:5]
		x = X(nx);
		load(sprintf('Map_interpolation/B_map_I=130A_x=%dmm.mat',x));
		disp(x);

		N = 173;
		Ox = x*ones(N,1)/1000;
		Oy = Y_(1:173)/1000;
		Oz = Z_(1:173)/1000;
		Bx = Bx(1:173,1);
		By = By(1:173,1);
		Bz = Bz(1:173,1);

		plot(Oz*1000,Bx,'r-');
		plot(Oz*1000,By,'r-');
		plot(Oz*1000,Bz,'r-');

		tic;
			[hx01,hy01,hz01] = Biot_Savart(Ox,Oy,Oz,-X1,-Y1, Z1,-X4,-Y4, Z4);
			[hx02,hy02,hz02] = Biot_Savart(Ox,Oy,Oz,-X4,-Y4, Z4,-X3,-Y3, Z3);
			[hx03,hy03,hz03] = Biot_Savart(Ox,Oy,Oz,-X3,-Y3, Z3,-X2,-Y2, Z2);
			[hx04,hy04,hz04] = Biot_Savart(Ox,Oy,Oz,-X2,-Y2, Z2,-X1,-Y1, Z1);

			[hx05,hy05,hz05] = Biot_Savart(Ox,Oy,Oz, X1,-Y1, Z1, X4,-Y4, Z4);
			[hx06,hy06,hz06] = Biot_Savart(Ox,Oy,Oz, X4,-Y4, Z4, X3,-Y3, Z3);
			[hx07,hy07,hz07] = Biot_Savart(Ox,Oy,Oz, X3,-Y3, Z3, X2,-Y2, Z2);
			[hx08,hy08,hz08] = Biot_Savart(Ox,Oy,Oz, X2,-Y2, Z2, X1,-Y1, Z1);

			[hx09,hy09,hz09] = Biot_Savart(Ox,Oy,Oz,-X1, Y1, Z1,-X2, Y2, Z2);
			[hx10,hy10,hz10] = Biot_Savart(Ox,Oy,Oz,-X2, Y2, Z2,-X3, Y3, Z3);
			[hx11,hy11,hz11] = Biot_Savart(Ox,Oy,Oz,-X3, Y3, Z3,-X4, Y4, Z4);
			[hx12,hy12,hz12] = Biot_Savart(Ox,Oy,Oz,-X4, Y4, Z4,-X1, Y1, Z1);

			[hx13,hy13,hz13] = Biot_Savart(Ox,Oy,Oz, X1, Y1, Z1, X2, Y2, Z2);
			[hx14,hy14,hz14] = Biot_Savart(Ox,Oy,Oz, X2, Y2, Z2, X3, Y3, Z3);
			[hx15,hy15,hz15] = Biot_Savart(Ox,Oy,Oz, X3, Y3, Z3, X4, Y4, Z4);
			[hx16,hy16,hz16] = Biot_Savart(Ox,Oy,Oz, X4, Y4, Z4, X1, Y1, Z1);

			Hx = hx01+hx02+hx03+hx04+hx05+hx06+hx07+hx08+hx09+hx10+hx11+hx12+hx13+hx14+hx15+hx16;
			Hy = hy01+hy02+hy03+hy04+hy05+hy06+hy07+hy08+hy09+hy10+hy11+hy12+hy13+hy14+hy15+hy16;
			Hz = hz01+hz02+hz03+hz04+hz05+hz06+hz07+hz08+hz09+hz10+hz11+hz12+hz13+hz14+hz15+hz16;

		disp(sprintf('SVD CPU time = %.1f sec',toc));
		plot(Oz*1000,Hx*I_svd,'k--');
		plot(Oz*1000,Hy*I_svd,'k--');
		plot(Oz*1000,Hz*I_svd,'k--');

	end
	set(gca,'YLim',[-0.2,0.4]);
	xlabel('{\it Z} (mm)','FontName','times new roman','FontSize',20);
	ylabel('{\it B_x} (T)','FontName','times new roman','FontSize',20);
	print('-dpng',sprintf('hgap=%d_modes=%d.png',hgap,modes));
	close all;
end
end

