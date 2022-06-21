function   clusterSamples(g, colnames, samplegroups, groupDesc1, groupDesc2, newlabel1, newlabel2)

if ~exist('newlabel1', 'var'); newlabel1 = 'group1';end
if ~exist('newlabel2', 'var'); newlabel2 = 'group2';end


for i=1:numel(colnames)
    if strcmp(samplegroups{i},groupDesc1)     %assign samp to control group
        colnames{i} = newlabel1;
  
    elseif strcmp(samplegroups{i}, groupDesc2) %assign sample to CQ group
            colnames{i} = newlabel2;
    
    else
        colnames{i} = 'NA';
        
    end
end

if(any(strcmp(colnames, 'NA')))  %make sure all columns are assigned
   fprintf("Warning, some groups not in %s or %s\n", groupDesc1, groupDesc2);
end

treeNames = colnames;
% for i=1:numel(colnames)
%     treeNames{i} = [colnames{i} ' - Col' num2str(i)];
% end
tree = linkage(g.double()','average');
dendrogram(tree,'Labels',treeNames);
h=gca;
h.XTickLabelRotation=45;
end

