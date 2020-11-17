load organizations.mat
load dados.mat

%%

id_org = [dados.org];


[count_org, bin_org] = hist(id_org,1:182);

[~,id_sorted] = sort(count_org);

count_org = count_org(id_sorted);
bin_org = bin_org(id_sorted);
clf
barh(count_org)


%%

figure(1)
set(1,'windowstyle','docked')
plot(bin_org,count_org)

figure(2)
set(2,'windowstyle','docked')
plot(bin_org,log10(count_org))


figure(3)
set(2,'windowstyle','docked')
plot(bin_org(id_sorted),(count_org(id_sorted)))

