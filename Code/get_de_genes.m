function [sigfc] = get_de_genes(g, samplegroups, treatmentGroupName, controlGroupName,nPerms, pval_cutoff, LFC_cutoff, write)
if ~exist('nPerms','var')
    nPerms = 1000;
end
if ~exist('pval_cutoff','var')
    pval_cutoff = 0.05;
end
if ~exist('LFC_cutoff','var')
    LFC_cutoff = 0.58;  % 50% modulation
end
if ~exist('write','var')
    write = 0;
end
treatment_cols = strcmp(samplegroups, treatmentGroupName);
control_cols = strcmp(samplegroups, controlGroupName);
[gpvals]=mattest(g(:,control_cols), g(:,treatment_cols), 'permute',nPerms);  %non parametric mattest


log2fc = mean(g(:,treatment_cols),2) - mean(g(:, control_cols),2);

gpvals=[gpvals bioma.data.DataMatrix(log2fc,'ColNames',{'log2fc'})];
gpvals =[gpvals bioma.data.DataMatrix(abs(log2fc),'ColNames',{'abs_log2fc'})];

% Select the genes with pvalue and FC cutoff;
keep = gpvals(:,'p-values')<=double(pval_cutoff) &...
    gpvals(:,'abs_log2fc')>= double(LFC_cutoff) & ...
    ~strcmp(gpvals.rownames, '') &...
    ~strcmp(gpvals.rownames, '---');
% if write == 1
%     write_to_excel(gpvals, double(pval_cutoff));      %write out the significantly modulated genes for GSEA
% end
if(sum(keep) > 1)
    sigfc = gpvals(keep,:);
    sigfc = sigfc.sortrows('abs_log2fc', 'descend');
    fprintf('Found %d genes with pvalue<=%0.2f and FC>=%0.2f.\n',size(sigfc,1), pval_cutoff, LFC_cutoff);
else
    keep = ~strcmp(gpvals.rownames, '') &...
    ~strcmp(gpvals.rownames, '---');

    fprintf("Warning: no genes matched your cutoff criteria.");
    sigfc = gpvals(keep,:);
    sigfc = sigfc.sortrows('p-values', 'ascend');
end

end

