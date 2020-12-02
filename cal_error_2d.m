function error = cal_error_2d(X_test, U, V, X_train, noise_perm, noise_images)

switch nargin
    case 6
        error = cal_error_without_noise(X_train, X_test, U, V, noise_perm, noise_images);
    case 3
        error = cal_error_with_noise(X_test, U, V);
end