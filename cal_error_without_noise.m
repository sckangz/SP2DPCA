function error_test = cal_error_without_noise(X_train, X_test, U, V, noise_perm, noise_images)

% Train Error
% error_train = 0;
train_samples = size(X_train,3);
N = 0;
% Test Error
error_test = 0;
test_samples = size(X_test,3);
for i = 1 : test_samples-1
    if any(noise_perm(1:noise_images)-train_samples == i) == 0
%         I = reshape(X_test(:,i),30,40);
%         figure();
%         imshow(I);
%         error_test = error_test + norm(X_test(:,:, i)-(U*U')*X_test(:,:, i)*(V*V'),'fro');
%         error_test = error_test + norm((X_test(:,:, i)-M)-((U*U')*(X_test(:,:, i)-M)*(V*V')),'fro');
        error_test = error_test + norm((X_test(:,:, i))-(U*U'*(X_test(:,:, i))*V*V'),'fro');
        N=N+1;
    end
end
error_test = (1/N)*error_test;


