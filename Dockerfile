FROM confluentinc/cp-kafka-connect:6.2.0

RUN apt-get update && apt-get install -y zip

RUN mkdir -p /usr/share/java/kafka-salesforce-connect
  && mkdir -p /usr/share/java/kafka-connect-jdbc
  && mkdir -p /usr/share/java/kafka-connect-s3

RUN echo "===> Collecting Salesforce connector" \
  && curl -O https://d1i4a15mxbxib1.cloudfront.net/api/plugins/confluentinc/kafka-connect-salesforce/versions/1.8.4/confluentinc-kafka-connect-salesforce-1.8.4.zip \
  && unzip confluentinc-kafka-connect-salesforce-1.8.4.zip 

RUN mv confluentinc-kafka-connect-salesforce-1.8.4/lib /usr/share/java/kafka-salesforce-connect

RUN echo "===> Installing MySQL connector" \
  && curl https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.19/mysql-connector-java-8.0.19.jar  --output /usr/share/java/kafka-connect-jdbc/mysql-connector-java-8.0.19.jar

RUN echo "===> Installing Oracle connector" \
  && wget https://repo1.maven.org/maven2/com/oracle/ojdbc/ojdbc8/19.3.0.0/ojdbc8-19.3.0.0.jar -O /usr/share/java/kafka-connect-jdbc/ojdbc8.jar

RUN echo "===> Installing SQL Server connector" \
  && wget https://repo1.maven.org/maven2/com/microsoft/sqlserver/mssql-jdbc/6.4.0.jre8/mssql-jdbc-6.4.0.jre8.jar -O /usr/share/java/kafka-connect-jdbc/mssql-jdbc-6.4.0.jre8.jar

RUN echo "===> Installing Redshift connector" \
  && wget https://s3.amazonaws.com/redshift-downloads/drivers/jdbc/1.2.43.1067/RedshiftJDBC4-no-awssdk-1.2.43.1067.jar -O /usr/share/java/kafka-connect-jdbc/RedshiftJDBC4-no-awssdk-1.2.43.1067.jar

RUN echo "====> Installing Snowflake connector" \
 && wget https://repo1.maven.org/maven2/net/snowflake/snowflake-jdbc/3.13.3/snowflake-jdbc-3.13.3.jar -O /usr/share/java/kafka-connect-jdbc/snowflake-jdbc-3.13.3.jar

RUN echo "===> Collecting Jsch" \
  && wget -O /usr/share/java/kafka-connect-jdbc/jsch-0.1.51.jar https://repo1.maven.org/maven2/com/jcraft/jsch/0.1.55/jsch-0.1.55.jar

RUN echo "===> Collecting SNS" \
  && wget -O /usr/share/java/kafka-connect-jdbc/aws-java-sdk-sns-1.11.725.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-sns/1.11.725/aws-java-sdk-sns-1.11.725.jar

RUN echo "===> Collecting S3" \
  && wget -O /usr/share/java/kafka-connect-jdbc/aws-java-sdk-s3-1.11.725.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.11.725/aws-java-sdk-s3-1.11.725.jar

RUN echo "===> Collecting AWS core" \
  && wget -O /usr/share/java/kafka/aws-java-sdk-core-1.11.725.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.725/aws-java-sdk-core-1.11.725.jar

RUN echo "===> Collecting AWS STS" \
  && wget -O /usr/share/java/kafka/aws-java-sdk-sts-1.11.725.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-sts/1.11.725/aws-java-sdk-sts-1.11.725.jar

RUN echo "===> Collecting Simple JSON" \
  && wget -O /usr/share/java/kafka-connect-jdbc/json-simple-1.1.1.jar https://repo1.maven.org/maven2/com/googlecode/json-simple/json-simple/1.1.1/json-simple-1.1.1.jar

COPY ./target/kafka-connect-jdbc-5.5.1.jar /usr/share/java/kafka-connect-jdbc/

COPY ./kafka-connect-storage-cloud/kafka-connect-s3/target/kafka-connect-s3-5.5.1.jar /usr/share/java/kafka-connect-s3/
