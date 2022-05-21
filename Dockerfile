FROM maven:3-openjdk-11 as builder
COPY . /iban4j
WORKDIR /iban4j
# Build the library jar and download the dependencies
RUN mvn clean package && mvn dependency:copy-dependencies
# Copy the jar to the fuzz folder and copy the dependencies to the fuzz folder
RUN mkdir ./fuzz/deps && find ./target -name "iban4j*.jar" -exec cp {} "./fuzz/deps/iban4j.jar" \; && cp ./target/dependency/* ./fuzz/deps && python3 fuzz/generate_classpath.py > fuzz/src/Manifest.txt
WORKDIR /iban4j/fuzz/src
# Build the fuzz target
RUN javac -cp "../deps/*" fuzz.java && jar cfme fuzz.jar Manifest.txt fuzz fuzz.class && chmod u+x fuzz.jar && cp fuzz.jar /iban4j/fuzz/deps
WORKDIR /iban4j/fuzz/deps
