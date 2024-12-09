# Stage 1: Build
FROM ubuntu:latest AS build
WORKDIR /app

# Cài đặt JDK và các công cụ cần thiết
RUN apt-get update && apt-get install -y openjdk-17 maven

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Thiết lập JAVA_HOME và PATH cho JDK
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Build ứng dụng bằng Maven Wrapper
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:17-jdk-slim
WORKDIR /app

# Expose port ứng dụng
EXPOSE 8081

# Sao chép file jar từ giai đoạn build
COPY --from=build /app/target/demo-1.jar app.jar

# Lệnh chạy ứng dụng
ENTRYPOINT ["java", "-jar", "app.jar"]
