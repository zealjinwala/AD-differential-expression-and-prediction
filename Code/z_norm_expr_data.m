function normed = z_norm_expr_data(g)
normed = g;
for i= 1:size(g, 2)
    normed(:, i) = (g(:, i) - mean(g(:, i)))/std(g(:, i));
end
end

