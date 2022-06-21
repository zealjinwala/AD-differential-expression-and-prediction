function write_to_excel(gpvals, pval)
if ~exist("pval", "var")
    pval = 0.01;
end
%Code adapted from Ahmet Sacan
%https://sacan.biomed.drexel.edu/lib/exe/fetch.php?rev=&media=course:qsb:ma:geo_demo.pdf
I=find(gpvals(:,1)<=pval);
nsig=numel(I);
xlsdata = cell(nsig, 3); %each row will contain genesymbol,pvalue,negfc
for i=1:nsig
 gene=gpvals.rownames{I(i)};
 p=gpvals.double(I(i), 1);
 nfc=gpvals.double(I(i), 2);
 xlsdata(i,:) = {gene p nfc};
end
xlsdata=[ {'genesymbol' 'pvalue' 'negfc'}; xlsdata]; %add the headerrow.
writecell(xlsdata, "significant_genes.csv");