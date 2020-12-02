%%load dataset COIL20_1440n_1024d_20c.mat
%%and add local noise area
%%Whole Noised

function [X_train, X_test, n, noise_perm, noise_images, side_length1, side_length2] = load_data(dataset)
% dataset = 'ORL_400n_1024d_40c_zscore_uni.mat';
% class = 40;
% load dataset
Struc = load(dataset);
X = Struc.X;
y = Struc.y;
side_length1 = Struc.width;
side_length2 = Struc.height;
class = Struc.class;
ratio = 0.5;
[datapoints,dimention] = size(X);

% Split train & test dataset
[X_train, ~,  X_test, ~] = split_train_test(X, y, class, ratio);
X_train_T = X_train;
X_train = X_train_T';
X_test_T = X_test;
X_test = X_test_T';
train_size = size(X_train,2);

% Add local Noise in Whole Dataset
X = [X_train X_test];
noise_perm = randperm(datapoints);
noise_images = round(0.2*datapoints);
% side_length = sqrt(dimention);
block_length1 = round(0.5*side_length1)-1;
block_length2 = round(0.5*side_length2)-1;
block_range1 = side_length1 - block_length1;
block_range2 = side_length2 - block_length2;
for i = 1:noise_images
    I = reshape(X(:, noise_perm(i)), side_length2, side_length1);
    row_start = randi([1,block_range2]);
    col_start = randi([1,block_range1]);
    for row_i = 0:block_length2
        for col_i = 0:block_length1
            pixel = rand();
            if (pixel >= 0.4)
                I(row_start+row_i, col_start+col_i) = 1;
            end
        end
    end
    X(:,noise_perm(i)) = reshape(I, dimention, 1);
end

X_train = X(:, 1:train_size);
X_test = X(:,train_size+1:datapoints);

n = size(X_train, 2); %num of train samples
% X_train = normc(X_train);
% X_test = normc(X_test);
end