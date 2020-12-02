clear
close all
clc

%% Datasets
loadmat = 'ORL_400n_1024d_40c_range_uni.mat';
folder = 'ORL';

%% Param Settings
NITER = 10;
fea = 225;
esp_mm = [ 50 100 200 500 700 1000];
c_mm = [ 300 500 1000 3000 4000 5000];
prompt = 'Output Folder No.: ';
OFN = input(prompt,'s');
Output_Folder = ['Result_', OFN];
if ~exist(Output_Folder,'dir')
    mkdir(Output_Folder);
end

%% Training & Testing
%%%%%% Load Data %%%%%%%
cd Processed_Data
[X_train, X_test, ~, noise_perm, noise_images, side_length1, side_length2] = load_data(loadmat);
[~,train_samples] = size(X_train);
[~, test_samples] = size(X_test);
A_train = reshape(X_train, side_length1, side_length2, train_samples);
A_test = reshape(X_test, side_length1, side_length2, test_samples);
cd ..

feature_num_sqr = sqrt(fea);
% SP2DPCA_s with c
disp('************** SP2DPCA with c ***************')
for j = 1:size(esp_mm,2)
    for i = 1:size(c_mm,2)
        [U4_with_c, V4_with_c, loss_with_c(i,j),loss_each_it(:,i,j)] = SP2DPCA_s(A_train, feature_num_sqr, NITER, esp_mm(j), c_mm(i));
        error_with_c(i,j) = cal_error_without_noise(A_train, A_test, U4_with_c, V4_with_c, noise_perm, noise_images);
        error_with_c_noise(i,j) = cal_error_with_noise(A_test,U4_with_c,V4_with_c);
    end        
end

% Draw Bar
disp('************** Drawing 3d bar of reconstruction error ***************')
h1 = figure();
b = bar3(error_with_c);
colorbar
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
set(gca,'XTickLabel',{'50','100','200','500','700','1000'});
set(gca,'YTickLabel',{'300','500','1000','3000','4000','5000'});
xlabel('$\zeta$','Interpreter','latex');
zlabel('Reconstruction Error');
ylabel('$c$','Interpreter','latex');
title('Reconstruction Error');

% Draw Convergence Curve
disp('************** Drawing Convergence Curve ***************\n')
h2 = figure();
ind = 1:(NITER/2);
plot(ind,loss_each_it(:,1,1),'b-o');
set(gca,'xtick',1:1:5)
xlabel('No. of Iteration');
ylabel('Training Loss');
title('Convergence Curve');

%%%%%% Output %%%%%%%
cd(Output_Folder);
if ~exist(folder,'dir')
    mkdir(folder);
end
cd(folder);
savemat = [num2str(feature_num_sqr),'x', num2str(feature_num_sqr),'fts.mat'];
savefig(h1,'Error Bar');
savefig(h2,'Convergence Curve');
save(savemat);
cd ../..;



