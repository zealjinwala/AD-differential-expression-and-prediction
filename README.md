Title: Analysis of Alzheimer’s Disease Gene Expression for Diagnostic Applications

Analysis summary: 

<img width="257" alt="image" src="https://user-images.githubusercontent.com/88799351/176286478-c2abdc19-0384-4f7d-8c51-95ba380eacd3.png">

Results summary: This study performs differential expression analysis and classification based on gene expression between patients clinically diagnosed with Alzheimer’s Disease and controls. Gene expression data was microarray-based from the brain and the blood. We find the sets of differentially expressed genes meeting a signifi-cance (p<0.05) and fold change (absolute log fold > 0.32) requirement are disjoint between the datasets from blood and brain. Transcripts from the brain are enriched for inflammation, cellular responses to metal ions, and apoptosis. Transcripts from the blood are enriched for translational processes, rRNA processing, and mitochondrial energetics. The pooled differentially expressed genes from all datasets are enriched for pathways involved in neurodegeneration, including Alzheimer’s disease. For classification, we trained a support vector machine classifier to predict disease diagnosis based on gene expression (control vs mild cognitive impairment and control vs Alzheimer’s dis-ease). After feature selection for each task, we were able to achieve an 83.5% Alzheimer’s vs control accu-racy and an 80.2% mild cognitive impairment vs con-trol accuracy


>RScripts/543_z_norm.R - An r script that takes geo accession numbers, downloads them, and performs z-normalization. It saves the expression output, along with the subject info.
