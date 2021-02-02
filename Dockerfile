FROM jupyter/all-spark-notebook

LABEL maintainer="Shawn Hermans <shermans@bellevue.edu>"

# Set when building on Travis so that certain long-running build steps can
# be skipped to shorten build time.
ARG TEST_ONLY_BUILD

USER $NB_UID

# Install Tensorflow
RUN pip install --quiet --no-cache-dir \
    'tensorflow==2.4.1' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Install Keras
RUN pip install --quiet --no-cache-dir \
    'keras==2.4.3' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

 # Install s3fs
RUN conda install --quiet --yes \
    's3fs==0.5.2' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Install pygal
RUN conda install --quiet --yes \
    'pygal==2.4.0' \
    'cairosvg==2.5.1' \
    'tinycss==0.4' \
    'cssselect==1.1.0' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Install Kafka Python
RUN conda install --quiet --yes \
    'kafka-python==2.0.2' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Install pydgraph
RUN pip install --quiet --no-cache-dir \
    'pydgraph==20.7.0' && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Install TinyDB
RUN conda install --quiet --yes \
    'tinydb==4.3.0' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Install schema and data packages
RUN conda install --quiet --yes \
    'fastavro==1.3.0' \
    'fastparquet==0.5.0' \
    'pygeohash==1.2.0' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Install python snappy
RUN conda install --quiet --yes \
    'python-snappy==0.5.4' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

## Move Jars to the Spark library
USER root
WORKDIR /tmp

RUN curl https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.0.1/spark-sql-kafka-0-10_2.12-3.0.1.jar \
    --output $SPARK_HOME/jars/spark-sql-kafka-0-10_2.12-3.0.1.jar && \
    curl https://repo1.maven.org/maven2/org/apache/spark/spark-token-provider-kafka-0-10_2.12/3.0.1/spark-token-provider-kafka-0-10_2.12-3.0.1.jar \
    --output $SPARK_HOME/jars/spark-token-provider-kafka-0-10_2.12-3.0.1.jar && \
    curl https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/2.4.1/kafka-clients-2.4.1.jar \
    --output $SPARK_HOME/jars/kafka-clients-2.4.1.jar && \
    curl https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.6.2/commons-pool2-2.6.2.jar \
    --output $SPARK_HOME/jars/commons-pool2-2.6.2.jar && \
    curl https://repo1.maven.org/maven2/org/spark-project/spark/unused/1.0.0/unused-1.0.0.jar \
    --output $SPARK_HOME/jars/unused-1.0.0.jar && \
    curl https://repo1.maven.org/maven2/com/github/luben/zstd-jni/1.4.4-3/zstd-jni-1.4.4-3.jar \
    --output $SPARK_HOME/jars/zstd-jni-1.4.4-3.jar && \
    curl https://repo1.maven.org/maven2/org/lz4/lz4-java/1.7.1/lz4-java-1.7.1.jar \
    --output $SPARK_HOME/jars/lz4-java-1.7.1.jar && \
    curl https://repo1.maven.org/maven2/org/xerial/snappy/snappy-java/1.1.7.5/snappy-java-1.1.7.5.jar \
    --output $SPARK_HOME/jars/snappy-java-1.1.7.5.jar && \
    curl https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.30/slf4j-api-1.7.30.jar \
    --output $SPARK_HOME/jars/slf4j-api-1.7.30.jar && \
    curl https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar \
    --output $SPARK_HOME/jars/hadoop-aws-3.2.0.jar && \
    curl https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.375/aws-java-sdk-bundle-1.11.375.jar \
    --output $SPARK_HOME/jars/aws-java-sdk-bundle-1.11.375.jar

USER $NB_UID
WORKDIR $HOME
