% SP2DPCA_s
function [U, V, loss, loss_each_it] = SP2DPCA_s(A, k, NITER, zeta, c)
% A:m*n*L, m*n is the size of images, L is the number of images;
% k: reduced dimension. The reduced image would be k*k;
% NITER: iteration number;
% zeta: self-paced learning param, control the increasing speed of
% w w.r.t loss
% U: m*k, learned projection matrix
% V: n*k, learned projection matrix

[m, n, L] = size(A);
w = ones(L,1);
V = eye(n,k);
U = eye(m,k);
M = zeros(m,n);
P1 = zeros(m,m);
P2 = zeros(n,n);

for t=1:NITER/2
    %Update w while not converge
    lag = cal_loss_2d(A, U, V, M);
    loss_each_it(t) = sum(lag);
    disp(['Training Loss:' num2str(loss_each_it(t))]);
    if nargin == 5
        ell = c*(lag/max(lag));
        v = exp(-ell/zeta)+eps;
    elseif nargin == 4
        v = exp(-lag/zeta);
    end
%     sortlag = sort(lag);
%     disp(['Min loss = ', num2str(sortlag(1)), ...
%     'Max loss = ', num2str(sortlag(L))])
    for iter = 1:NITER
        for i = 1:L
            w(i) = v(i)*0.5/norm((A(:,:,i)-M)-(U*U')*(A(:,:,i)-M)*(V*V'), 'fro');
        end
        for i = 1:L
            M = M + w(i)*A(:,:,i);
        end
        M = M./sum(w);
        for i = 1:L
            P1 = P1 + w(i)*(A(:,:,i)-M)*(V*V')*(A(:,:,i)-M)';
        end
        [U,~, ~] = svds(P1, k);
        for i = 1:L
            P2 = P2 + w(i)*(A(:,:,i)-M)'*(U*U')*(A(:,:,i)-M);
        end 
        [V, ~, ~] = svds(P2, k);
    end
end
loss = sum(lag)/L;

