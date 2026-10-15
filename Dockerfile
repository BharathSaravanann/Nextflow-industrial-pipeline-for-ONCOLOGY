FROM condaforge/miniforge3:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl unzip procps bsd-mailx msmtp-mta util-linux ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/miniconda3/envs \
    && mamba create -y -p /root/miniconda3/envs/bioinfo -c conda-forge -c bioconda \
    python=3.10 \
    openjdk=17 \
    nextflow=24.04 \
    bwa=0.7.18 \
    samtools=1.23 \
    htslib \
    bedtools \
    lofreq=2.1 \
    pindel=0.2 \
    pandas \
    numpy \
    pysam \
    && mamba clean -afy

ENV PATH="/root/miniconda3/envs/bioinfo/bin:${PATH}"
ENV JAVA_HOME="/root/miniconda3/envs/bioinfo"

RUN mkdir -p /home/Tools/gatk/build/libs /tmp/gatk \
    && curl -L -o /tmp/gatk/gatk.zip https://github.com/broadinstitute/gatk/releases/download/4.5.0.0/gatk-4.5.0.0.zip \
    && unzip -q /tmp/gatk/gatk.zip -d /tmp/gatk \
    && cp /tmp/gatk/gatk-4.5.0.0/gatk-package-4.5.0.0-local.jar /home/Tools/gatk/build/libs/gatk.jar \
    && rm -rf /tmp/gatk

COPY context/refs/hg38/ /home/Resources/References/hg38/
COPY context/refs/Hg19_Dragen/ /home/Resources/References/Hg19_Dragen/
COPY context/refs/Onco/ /home/Resources/References/Onco/

COPY context/BED_ankur/ /home/ankur/Coverage/BED/
COPY context/BED_Unity/ /Unitystorage/BED_FIles/

COPY context/scripts/python_script/ /home/vaibhav/scripts/python_script/
COPY context/scripts/Onco_opration/ /home/meghavarshney/Onco_opration/
COPY main.nf /pipeline/main.nf

RUN chmod -R +x /home/vaibhav/scripts/python_script /home/meghavarshney/Onco_opration \
    && chmod +x /pipeline/main.nf \
    && mkdir -p /root/Onco /data /tmp/nxf_work

ENV NXF_HOME=/root/.nextflow
ENV NXF_WORK=/tmp/nxf_work
ENV NXF_OPTS="-Xms512m -Xmx2g"

WORKDIR /data

ENTRYPOINT ["nextflow", "run", "/pipeline/main.nf"]
