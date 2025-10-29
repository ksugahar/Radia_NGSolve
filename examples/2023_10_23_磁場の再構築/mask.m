clear all;

BH = 16;

for I = [130,245,460,620,700,805,900,1000,1150,1200,1265]
	FileName = sprintf('Map_interpolation/I=%d_BH%d.txt',I,BH);
	disp(FileName);
	fid = fopen(FileName,'r');
		data = fscanf(fid,'%f %f %f %f %f %f\r\n',[6,inf]);
	fclose(fid);
	Xx = reshape(data(1,:),173,81,5);
	Yy = reshape(data(2,:),173,81,5);
	Zz = reshape(data(3,:),173,81,5);
	BX = reshape(data(4,:),173,81,5);
	BY = reshape(data(5,:),173,81,5);
	BZ = reshape(data(6,:),173,81,5);

	X = [0:10:40];
	for nx = [1:length(X)]
		x  = X(nx);
		YY = squeeze(Yy(:,:,nx));
		ZZ = squeeze(Zz(:,:,nx));	
		Bx = squeeze(BX(:,:,nx));
		By = squeeze(BY(:,:,nx));
		Bz = squeeze(BZ(:,:,nx));
		close all;
		set(gcf,'Position',[500,100,1400,1200]);
			hold on;
		contourf(ZZ,YY,Bx,100);
		plot(ZZ(:),YY(:),'k.','MarkerSize',3);
			hold on;
		axis equal;
		N = find(YY(:)<0.47*ZZ(:)+170);
		X_ = x*ones(size(N));
		Y_ = YY(N);
		Z_ = ZZ(N);
		Bx_ = Bx(N);
		By_ = By(N);
		Bz_ = Bz(N);
		plot(Z_(:),Y_(:),'ro','MarkerSize',3);
		FileName = sprintf('Map_interpolation/B_map_I=%dA_x=%dmm.mat',I,x);
		save(FileName,'I','x','Bx','By','Bz','X_','Y_','Z_','Bx_','By_','Bz_');
	end
end

