FROM confluentinc/cp-kafka-connect:5.5.1

RUN echo "===> Installing MySQL connector" \
  && curl https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.19/mysql-connector-java-8.0.19.jar  --output /usr/share/java/kafka-connect-jdbc/mysql-connector-java-8.0.19.jar

RUN echo "===> Installing Oracle connector" \
  && wget https://repo1.maven.org/maven2/com/oracle/ojdbc/ojdbc8/19.3.0.0/ojdbc8-19.3.0.0.jar -O /usr/share/java/kafka-connect-jdbc/ojdbc8.jar

RUN echo "===> Installing SQL Server connector" \
  && wget https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/6.4.0.jre8/mssql-jdbc-6.4.0.jre8.jar -O /usr/share/java/kafka-connect-jdbc/mssql-jdbc-6.4.0.jre8.jar

RUN echo "===> Collecting Jsch" \
  && wget -O /usr/share/java/kafka-connect-jdbc/jsch-0.1.51.jar https://repo1.maven.org/maven2/com/jcraft/jsch/0.1.55/jsch-0.1.55.jar

RUN echo "===> Collecting SNS" \
  && wget -O /usr/share/java/kafka-connect-jdbc/aws-java-sdk-sns-1.11.725.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-sns/1.11.725/aws-java-sdk-sns-1.11.725.jar

RUN echo "===> Collecting AWS core" \
  && wget -O /usr/share/java/kafka/aws-java-sdk-core-1.11.725.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.725/aws-java-sdk-core-1.11.725.jar

RUN echo "===> Collecting AWS STS" \
  && wget -O /usr/share/java/kafka/aws-java-sdk-sts-1.11.725.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-sts/1.11.725/aws-java-sdk-sts-1.11.725.jar

RUN echo "===> Collecting Simple JSON" \
  && wget -O /usr/share/java/kafka-connect-jdbc/json-simple-1.1.1.jar https://repo1.maven.org/maven2/com/googlecode/json-simple/json-simple/1.1.1/json-simple-1.1.1.jar

RUN echo "===> Collecting JSON schema serializer" \
  && wget -O /usr/share/java/kafka-connect-s3/storage-common/kafka-json-schema-serializer-5.5.1.jar http://packages.confluent.io/maven/io/confluent/kafka-json-schema-serializer/5.5.1/kafka-json-schema-serializer-5.5.1.jar

RUN echo "===> Collecting JSON schema provider" \
  && wget -O /usr/share/java/kafka-connect-s3/storage-common/kafka-json-schema-provider-5.5.1.jar http://packages.confluent.io/maven/io/confluent/kafka-json-schema-provider/5.5.1/kafka-json-schema-provider-5.5.1.jar

RUN echo "===> Collecting JSON serializer" \
  && wget -O /usr/share/java/kafka-connect-s3/storage-common/kafka-json-serializer-5.5.1.jar http://packages.confluent.io/maven/io/confluent/kafka-json-serializer/5.5.1/kafka-json-serializer-5.5.1.jar


RUN echo "===> Updating JDBC jar" \
  && rm -rf /usr/share/java/kafka-connect-jdbc/kafka-connect-jdbc-5.5.1.jar \
  && rm -rf /usr/share/java/kafka-connect-s3/kafka-connect-s3-5.5.1.jar \
  && rm -rf /usr/share/java/kafka/connect-api-5.5.1-ccs.jar \
  && rm -rf /usr/share/java/kafka/connect-json-5.5.1-ccs.jar \
  && rm -rf /usr/share/java/kafka/connect-transforms-5.5.1-ccs.jar \
  && rm -rf /usr/share/java/kafka-connect-s3/storage-common/kafka-schema-registry-client-5.5.1.jar

COPY ./target/kafka-connect-jdbc-5.5.1.jar /usr/share/java/kafka-connect-jdbc/

COPY ./kafka-connect-storage-cloud/kafka-connect-s3/target/kafka-connect-s3-5.5.1.jar /usr/share/java/kafka-connect-s3/

COPY ./kafka/connect/api/build/libs/connect-api-6.2.0-0-ccs.jar /usr/share/java/kafka/

COPY ./kafka/connect/json/build/libs/connect-json-6.2.0-0-ccs.jar /usr/share/java/kafka

COPY ./kafka/connect/transforms/build/libs/connect-transforms-6.2.0-0-ccs.jar /usr/share/java/kafka/

COPY ./schema-registry/json-schema-converter/target/kafka-connect-json-schema-converter-5.5.1.jar /usr/share/java/kafka-connect-jdbc/

COPY ./schema-registry/json-schema-converter/target/kafka-connect-json-schema-converter-5.5.1.jar /usr/share/java/kafka-connect-s3/storage-common/

COPY ./schema-registry/json-schema-converter/target/kafka-connect-json-schema-converter-5.5.1.jar /usr/share/java/kafka-serder-tools/kafka-connect-json-schema-converter-5.5.1.jar
