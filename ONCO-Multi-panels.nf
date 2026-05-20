nextflow.enable.dsl=2
params.outdir = ''
params.panels = ''
params.base_path = ''
params.max_parallel = 4
params.run_number = ''
params.email_recipients = ''

def getBedFile(panelName) {
    def bedFiles = [
        'Roche-Solid': '/home/ankur/Coverage/BED/Roche-Addon-Onco-GRCH38_Chr.bed',
        'Roche-Hemat': '/home/ankur/Coverage/BED/Hemat_Chr.bed',
        '8GP-NEW': '/home/ankur/Coverage/BED/8GP-CHP2-New_Chr.bed',
        '8GP': '/home/ankur/Coverage/BED/ONCO_Chr.bed',
        'TCP-ONCO': '/Unitystorage/BED_FIles/ONCO-TCP_Chr.bed',
        '12GP': '/Unitystorage/BED_FIles/12GP-CHP2-new_Chr.bed',
        'Roche-Solid-Priority': '/home/ankur/Coverage/BED/Roche-Addon-Onco-GRCH38_Chr.bed',
        'Roche-Hemat-Priority': '/home/ankur/Coverage/BED/Hemat_Chr.bed',
        '8GP-NEW-Priority': '/home/ankur/Coverage/BED/8GP-CHP2-New_Chr.bed',
        '8GP-Priority': '/home/ankur/Coverage/BED/ONCO_Chr.bed',
        'TCP-ONCO-Priority': '/Unitystorage/BED_FIles/ONCO-TCP_Chr.bed',
        '12GP-Priority': '/Unitystorage/BED_FIles/12GP-CHP2-new_Chr.bed',
        'CHP': '/Unitystorage/BED_FIles/CHP_Chr.bed',
        'CHP-Priority': '/Unitystorage/BED_FIles/CHP_Chr.bed'
    ]
    return bedFiles[panelName]
}

def getRefFile(panelName) {
    def refFiles = [
        'Roche-Solid': '/home/Resources/References/hg38/hg38.fa',
        'Roche-Hemat': '/home/Resources/References/hg38/hg38.fa',
        '8GP-NEW': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        '8GP': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        'TCP-ONCO': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        '12GP': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        'Roche-Solid-Priority': '/home/Resources/References/hg38/hg38.fa',
        'Roche-Hemat-Priority': '/home/Resources/References/hg38/hg38.fa',
        '8GP-NEW-Priority': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        '8GP-Priority': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        'TCP-ONCO-Priority': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        '12GP-Priority': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        'CHP': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa',
        'CHP-Priority': '/home/Resources/References/Hg19_Dragen/Hg19_Dragen.fa'

    ]
    return refFiles[panelName]
}

def getRefDir(panelName) {
    def refDirs = [
        'Roche-Solid': '/home/Resources/References/hg38/',
        'Roche-Hemat': '/home/Resources/References/hg38/',
        '8GP-NEW': '/home/Resources/References/Hg19_Dragen/',
        '8GP': '/home/Resources/References/Hg19_Dragen/',
        'TCP-ONCO': '/home/Resources/References/Hg19_Dragen/',
        '12GP': '/home/Resources/References/Hg19_Dragen/',
        'Roche-Solid-Priority': '/home/Resources/References/hg38/',
        'Roche-Hemat-Priority': '/home/Resources/References/hg38/',
        '8GP-NEW-Priority': '/home/Resources/References/Hg19_Dragen/',
        '8GP-Priority': '/home/Resources/References/Hg19_Dragen/',
        'TCP-ONCO-Priority': '/home/Resources/References/Hg19_Dragen/',
        '12GP-Priority': '/home/Resources/References/Hg19_Dragen/',
        'CHP': '/home/Resources/References/Hg19_Dragen/',
        'CHP-Priority': '/home/Resources/References/Hg19_Dragen/'

    ]
    return refDirs[panelName]
}

def getOutputDir(panelName, runNumber) {
    def basePaths = [
        'Roche-Solid': "/root/Onco/Roche-Solid_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        'Roche-Hemat': "/root/Onco/Roche-Hemat_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        '8GP-NEW': "/root/Onco/8GP-Lungs_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        '8GP': "/root/Onco/8GP_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        'TCP-ONCO': "/root/Onco/TCP_RawData_Lifecell/TCP_MGI_${runNumber}/gatk",
        '12GP': "/root/Onco/12GP_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        'Roche-Solid-Priority': "/root/Onco/Roche-Solid_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        'Roche-Hemat-Priority': "/root/Onco/Roche-Hemat_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        '8GP-NEW-Priority': "/root/Onco/8GP-Lungs_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        '8GP-Priority': "/root/Onco/8GP_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        'TCP-ONCO-Priority': "/root/Onco/TCP_RawData_Lifecell/TCP_Run${runNumber}/gatk",
        '12GP-Priority': "/root/Onco/12GP_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        'CHP': "/root/Onco/CHP_RawData_Lifecell/MGI_Run${runNumber}/gatk",
        'CHP-Priority': "/root/Onco/CHP_RawData_Lifecell/MGI_Run${runNumber}/gatk"

    ]
    return basePaths[panelName]
}

process BAM_PROCESSING {
    maxForks params.max_parallel
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    cpus 20
    tag "${id}-${panel_name}"

    input:
    tuple val(id), path(read1), path(read2), val(panel_name), path(bedfile), path(ref_dir)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.GATK.sorted.bam"), path("${id}/${id}.GATK.sorted.bam.bai"), emit: bam_output

    script:
    def ref_file = getRefFile(panel_name)
    """
    mkdir -p ${id}
    bwa mem -M -t ${task.cpus} -R "@RG\\tID:${id}\\tPL:ILLUMINA\\tSM:${id}" ${ref_file} ${read1} ${read2} | samtools view -bh -@ 12 - | samtools sort -O BAM -o ${id}/${id}.GATK1.sorted.bam -@ 12 -
    samtools index -@ 12 ${id}/${id}.GATK1.sorted.bam
    bedtools intersect -wa -a ${id}/${id}.GATK1.sorted.bam -b ${bedfile} > ${id}/${id}.GATK.bam
    samtools sort -O BAM -o ${id}/${id}.GATK.sorted.bam -@ 12 ${id}/${id}.GATK.bam
    samtools index -@ 12 ${id}/${id}.GATK.sorted.bam
    rm ${id}/${id}.GATK1.sorted.bam ${id}/${id}.GATK1.sorted.bam.bai ${id}/${id}.GATK.bam
    """
}

process LOFREQ_ANALYSIS {
    maxForks 4
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    errorStrategy 'retry'
    maxRetries 3
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(bam), path(bai), path(bedfile)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}_modified.lofreq.vcf.gz"), path("${id}/${id}.lofreq_ontarget.vcf"), path("${id}/${id}.lofreq.vcf"), path("${id}/${id}.lofreq.vcf.gz.tbi"), path("${id}/${id}.lofreq_ontarget_header.vcf.gz"), path("${id}/${id}.lofreq_ontarget_header.vcf.gz.tbi"), emit: lofreq_output

    script:
    def ref_file = getRefFile(panel_name)
    """
    mkdir -p ${id}
    lofreq call -f ${ref_file} -o ${id}/${id}.lofreq.vcf.gz ${bam}
    gunzip -c ${id}/${id}.lofreq.vcf.gz | bedtools intersect -a - -b ${bedfile} > ${id}/${id}.lofreq_ontarget.vcf
    gzip -d ${id}/${id}.lofreq.vcf.gz
    cat ${id}/${id}.lofreq.vcf | grep '^#' >> ${id}/${id}.temp_header
    cat ${id}/${id}.lofreq_ontarget.vcf >> ${id}/${id}.temp_header
    mv ${id}/${id}.temp_header ${id}/${id}.lofreq_ontarget_header.vcf
    bgzip ${id}/${id}.lofreq_ontarget_header.vcf
    tabix -p vcf ${id}/${id}.lofreq_ontarget_header.vcf.gz
    python /home/vaibhav/scripts/python_script/lofreq_vcf_editor.py ${id}/${id}.lofreq_ontarget_header.vcf.gz
    """
}

process PINDEL_ANALYSIS_19 {
    maxForks 2
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    errorStrategy 'retry'
    maxRetries 2
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(bam), path(bai)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.new.edited_pindel.vcf"), path("${id}/${id}.new.pindel.vcf"), emit: pindel_vcf

    script:
    def ref_file = getRefFile(panel_name)
    def temp_dir = "${getOutputDir(panel_name, params.run_number)}"
    """
    mkdir -p ${id}
    sleep \$((RANDOM % 20))
    sh /home/meghavarshney/Onco_opration/pindel.sh ${id} ${temp_dir} ${ref_file}
    if [ -f "${temp_dir}/${id}/${id}.new.pindel.vcf.gz" ]; then
        gzip -dc ${temp_dir}/${id}/${id}.new.pindel.vcf.gz > ${id}/${id}.new.pindel.vcf
        python /home/meghavarshney/Onco_opration/modify_pindel.py ${id}/${id}.new.pindel.vcf ${id}/${id}.new.edited_pindel.vcf
    else
        touch ${id}/${id}.new.edited_pindel.vcf
        echo "##fileformat=VCFv4.2" > ${id}/${id}.new.edited_pindel.vcf
        echo "#No variants found" >> ${id}/${id}.new.edited_pindel.vcf
    fi
    """
}

process PINDEL_ANALYSIS_38 {
    maxForks 2
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    errorStrategy 'retry'
    maxRetries 2
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(bam), path(bai)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.new.edited_pindel.vcf"), path("${id}/${id}.new.pindel.vcf"), emit: pindel_vcf

    script:
    def ref_file = getRefFile(panel_name)
    def temp_dir = "${getOutputDir(panel_name, params.run_number)}"
    """
    mkdir -p ${id}
    sleep \$((RANDOM % 20))
    sh /home/meghavarshney/Onco_opration/pindel-hg38.sh ${id} ${temp_dir} ${ref_file}
    if [ -f "${temp_dir}/${id}/${id}.new.pindel.vcf.gz" ]; then
        gzip -dc ${temp_dir}/${id}/${id}.new.pindel.vcf.gz > ${id}/${id}.new.pindel.vcf
        python /home/meghavarshney/Onco_opration/modify_pindel.py ${id}/${id}.new.pindel.vcf ${id}/${id}.new.edited_pindel.vcf
    else
        touch ${id}/${id}.new.edited_pindel.vcf
        echo "##fileformat=VCFv4.2" > ${id}/${id}.new.edited_pindel.vcf
        echo "#No variants found" >> ${id}/${id}.new.edited_pindel.vcf
    fi
    """
}

process HAPLOTYPE_CALLER {
    maxForks 6
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    errorStrategy 'retry'
    maxRetries 2
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(bam), path(bai)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.g.vcf"), path("${id}/${id}.g.vcf.idx"), emit: haplotype_vcf

    script:
    def ref_file = getRefFile(panel_name)
    """
    mkdir -p ${id}
    java -jar -Xmx12g /home/Tools/gatk/build/libs/gatk.jar HaplotypeCaller -I ${bam} -O ${id}/${id}.g.vcf -R ${ref_file} -ERC GVCF -A DepthPerAlleleBySample -A AlleleFraction -RF MappingQualityNotZeroReadFilter -G StandardAnnotation -G StandardHCAnnotation
    """
}

process SELECT_VARIANTS {
    maxForks params.max_parallel
    errorStrategy 'retry'
    maxRetries 3
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(gvcf), path(idx), path(bedfile)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.on_target_g.vcf"), path("${id}/${id}.on_target_g.vcf.idx"), emit: selected_vcf

    script:
    """
    mkdir -p ${id}
    java -jar /home/Tools/gatk/build/libs/gatk.jar SelectVariants -V ${gvcf} -L ${bedfile} -O ${id}/${id}.on_target_g.vcf
    """
}

process MUTECT2_HG38 {
    maxForks 4
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    errorStrategy 'retry'
    maxRetries 2
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(bam), path(bai)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.Mutect2.Somatic.vcf"), path("${id}/${id}.Mutect2.Somatic.vcf.idx"), path("${id}/${id}.Mutect2.Somatic.vcf.stats"), emit: mutect_vcf

    script:
    def ref_file = getRefFile(panel_name)
    def germline_resource = '/home/Resources/References/Onco/hg38_v0_somatic-hg38_af-only-gnomad.hg38.vcf.gz'
    def panel_normals = '/home/Resources/References/Onco/1000g_pon.hg38.vcf.gz'
    """
    mkdir -p ${id}
    java -jar /home/Tools/gatk/build/libs/gatk.jar Mutect2 -I ${bam} -O ${id}/${id}.Mutect2.Somatic.vcf -R ${ref_file} -A AlleleFraction -A AS_QualByDepth -A BaseQuality -A QualByDepth -G StandardAnnotation -tumor-sample ${id} --germline-resource ${germline_resource} --panel-of-normals ${panel_normals}
    """
}

process MUTECT2_HG19 {
    maxForks 4
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    errorStrategy 'retry'
    maxRetries 2
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(bam), path(bai)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.Mutect2.Somatic.vcf"), path("${id}/${id}.Mutect2.Somatic.vcf.idx"), path("${id}/${id}.Mutect2.Somatic.vcf.stats"), emit: mutect_vcf

    script:
    def ref_file = getRefFile(panel_name)
    def germline_resource = '/home/Resources/References/Onco/somatic-b37_af-only-gnomad.raw.sites-hg19.vcf'
    def panel_normals = '/home/Resources/References/Onco/somatic-b37_Mutect2-WGS-panel-b37-hg19.vcf'
    """
    mkdir -p ${id}
    java -jar /home/Tools/gatk/build/libs/gatk.jar Mutect2 -I ${bam} -O ${id}/${id}.Mutect2.Somatic.vcf -R ${ref_file} -A AlleleFraction -A AS_QualByDepth -A BaseQuality -A QualByDepth -G StandardAnnotation -tumor-sample ${id} --germline-resource ${germline_resource} --panel-of-normals ${panel_normals}
    """
}

process MODIFY_GVCF {
    maxForks params.max_parallel
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    errorStrategy 'retry'
    maxRetries 3
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(vcf), path(idx)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.edited_g.vcf"), emit: modified_vcf

    script:
    """
    mkdir -p ${id}
    python /home/meghavarshney/Onco_opration/modify_gvcf.py ${vcf} ${id}/${id}.edited_g.vcf
    """
}

process GVCF_REF_REMOVAL {
    maxForks params.max_parallel
    publishDir "${getOutputDir(panel_name, params.run_number)}", mode: 'copy'
    errorStrategy 'retry'
    maxRetries 3
    tag "${id}-${panel_name}"

    input:
    tuple val(id), val(panel_name), path(vcf)

    output:
    tuple val(id), val(panel_name), path("${id}/${id}.edited_geneyx_g.vcf"), emit: final_vcf

    script:
    """
    mkdir -p ${id}
    bash /home/meghavarshney/Onco_opration/gVcfRefRemoval.sh ${vcf} ${id}/${id}.edited_geneyx_g.vcf
    """
}

process COUNT_AND_EMAIL {
    executor 'local'
    tag "${panel_name}-${sample_id}"

    input:
    tuple val(panel_name), val(sample_id)

    script:
    def output_path = getOutputDir(panel_name, params.run_number)
    def run_lock_dir = "/tmp/gatk_run_${params.run_number}"
    def count_file = "${run_lock_dir}/.sample_count_${panel_name}"
    """
    mkdir -p ${run_lock_dir}
    mkdir -p ${output_path}

    (
        flock -x 200

        count=\$(cat ${count_file} 2>/dev/null || echo 0)
        count=\$((count + 1))
        echo \$count > ${count_file}

        total=\$(ls ${params.base_path}/${panel_name}/*_1.fq.gz 2>/dev/null | wc -l)

        echo "Panel ${panel_name}: \${count}/\${total} samples completed"

        if [ "\$count" -eq "\$total" ]; then
            mail -s "Analysis Update:MGIRun${params.run_number}" ${params.email_recipients} << EOF

GATK analysis Update:
Panel_folder:${panel_name}
Samples_count:\${total}
Output_path:${output_path}

All samples for ${panel_name} have completed successfully.
EOF
            echo "Mail sent for ${panel_name} - All \${total} samples completed"
        fi

    ) 200>${run_lock_dir}/.lock
    """
}

workflow {
    def panelList = params.panels.split(',').collect { it.trim() }

    fastq_ch = Channel.empty()

    panelList.each { panel ->
        def panelPath = "${params.base_path}/${panel}"
        def bedFilePath = getBedFile(panel)
        def refDirPath = getRefDir(panel)

        def panel_fastq_ch = Channel.fromFilePairs("${panelPath}/*_{1,2}.fq.gz", checkIfExists: true)
            .map { base, files ->
                def id = base.toString().split('_')[0]
                tuple(id, files[0], files[1], panel, file(bedFilePath), file(refDirPath))
            }

        fastq_ch = fastq_ch.mix(panel_fastq_ch)
    }

    bam_results = BAM_PROCESSING(fastq_ch)

    bam_output_fork = bam_results.bam_output.multiMap { id, panel, bam, bai ->
        lofreq: tuple(id, panel, bam, bai, file(getBedFile(panel)))
        pindel_hg38: tuple(id, panel, bam, bai)
        pindel_hg19: tuple(id, panel, bam, bai)
        mutect_hg38: tuple(id, panel, bam, bai)
        mutect_hg19: tuple(id, panel, bam, bai)
        haplotype: tuple(id, panel, bam, bai)
    }

    lofreq_results = LOFREQ_ANALYSIS(bam_output_fork.lofreq)

    pindel_hg38_panels = bam_output_fork.pindel_hg38.filter { id, panel, bam, bai ->
        panel.startsWith('Roche')
    }

    pindel_hg19_panels = bam_output_fork.pindel_hg19.filter { id, panel, bam, bai ->
        !panel.startsWith('Roche')
    }

    pindel_38_results = PINDEL_ANALYSIS_38(pindel_hg38_panels)
    pindel_19_results = PINDEL_ANALYSIS_19(pindel_hg19_panels)

    mutect_hg38_panels = bam_output_fork.mutect_hg38.filter { id, panel, bam, bai ->
        panel.startsWith('Roche')
    }

    mutect_hg19_panels = bam_output_fork.mutect_hg19.filter { id, panel, bam, bai ->
        !panel.startsWith('Roche')
    }

    mutect_hg38_results = MUTECT2_HG38(mutect_hg38_panels)
    mutect_hg19_results = MUTECT2_HG19(mutect_hg19_panels)

    haplotype_results = HAPLOTYPE_CALLER(bam_output_fork.haplotype)

    select_input = haplotype_results.haplotype_vcf.map { id, panel, gvcf, idx ->
        tuple(id, panel, gvcf, idx, file(getBedFile(panel)))
    }
    select_results = SELECT_VARIANTS(select_input)
    modify_results = MODIFY_GVCF(select_results.selected_vcf)
    final_results = GVCF_REF_REMOVAL(modify_results.modified_vcf)

    all_pindel = pindel_38_results.pindel_vcf.mix(pindel_19_results.pindel_vcf)
    all_mutect = mutect_hg38_results.mutect_vcf.mix(mutect_hg19_results.mutect_vcf)

    final_results.final_vcf.map { id, panel, vcf -> tuple(id, panel, 'gvcf') }
        .mix(
            lofreq_results.lofreq_output.map { id, panel, f1, f2, f3, f4, f5, f6 -> tuple(id, panel, 'lofreq') },
            all_pindel.map { id, panel, f1, f2 -> tuple(id, panel, 'pindel') },
            all_mutect.map { id, panel, f1, f2, f3 -> tuple(id, panel, 'mutect') }
        )
        .groupTuple(by: [0, 1], size: 4)
        .map { id, panel, types -> tuple(panel, id) }
        .set { all_completed }

    COUNT_AND_EMAIL(all_completed)
}

workflow.onComplete {
    file("${workflow.workDir}").deleteDir()
    println "Pipeline completed. Work directory deleted."
}
