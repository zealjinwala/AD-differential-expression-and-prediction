function [gpl_col, MAP_GSE_GPL] = translate_probes(gpl, g, col, IDcol)
%code adpated from Ahmet Sacan
%https://sacan.biomed.drexel.edu/lib/exe/fetch.php?rev=&media=course:qsb:ma:geo_demo.pdf
if(~exist('IDcol', 'var'))
    IDcol = 'ID';
end
if any(find(strcmp(gpl.ColumnNames, col)))
    
    gplprobes = gpl.Data(:, strcmp(gpl.ColumnNames, IDcol));   %get probe IDs from gpl
    gplgenes = gpl.Data(:, strcmp(gpl.ColumnNames, col));     %get col of interest
    gseprobes = g.rownames;                                   % probeset from gse
    
    MAP_GSE_GPL = zeros(numel(gseprobes),1); %init vector
    map = containers.Map((gplprobes),1:numel(gplprobes)); %dictionary obj
    
    for i=1:numel(gseprobes)
        if map.isKey((gseprobes{i}))  
            MAP_GSE_GPL(i)=map((gseprobes{i})); %put index of gpl probe into vector
        end
    end
    
    gsegenes = gseprobes; %make a copy, so entries not found will keep the
    % probe name.
    gsegenes(find(MAP_GSE_GPL)) =gplgenes(MAP_GSE_GPL(find(MAP_GSE_GPL)));
    gpl_col = gsegenes;
else
  gpl_col = -1;
  MAP_GSE_GPL = -1;
end