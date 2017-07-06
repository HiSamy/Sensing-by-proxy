function out_val = draw_distribution(distr,vec)
num_class = length(vec);
num_elem = size(distr,2);
out_val = nan(1,num_elem);
for i = 1:num_elem
    dist_vec = distr(:,i);
    rand_num = rand(1);
    book_val = dist_vec(1);
    for j = 1:num_class
        if rand_num<=book_val
            out_val(i)=vec(j);
            break;
        elseif j<num_class
            book_val = book_val+dist_vec(j+1);
        else
            out_val(i)=vec(num_class);
            break;
        end
    end
end