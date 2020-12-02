function lag = cal_loss_2d(X_train, U, V, M)
[~, ~, n] = size(X_train);
lag = zeros(n,1);
% for i = 1:n
%     for j = 1:n
%         lag(i) = lag(i)+norm(W'*(X_train(:,i)-X_train(:,j)))^p;
%     end
% end
for i = 1:n
    lag(i) = norm(X_train(:,:, i)-M-U*U'*(X_train(:,:, i)-M)*V*V','fro');
end
end
