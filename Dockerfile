# --- Giai đoạn 1: Build ứng dụng ---
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml và tải dependencies trước để tận dụng Docker cache
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy toàn bộ mã nguồn và tiến hành đóng gói (bỏ qua bước test để build nhanh hơn)
COPY src ./src
RUN mvn clean package -DskipTests

# --- Giai đoạn 2: Chạy ứng dụng ---
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy file jar được tạo từ giai đoạn 1
COPY --from=builder /app/target/shop-0.0.1-SNAPSHOT.jar app.jar

# Mở cổng ứng dụng
EXPOSE 8080

# Chạy ứng dụng Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]