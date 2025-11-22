### ---- STAGE 1 : Build ----
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copier le wrapper Maven correctement
COPY mvnw .
COPY .mvn .mvn

# Copier uniquement la config
COPY pom.xml .

RUN chmod +x mvnw

# Télécharger les dépendances (optimise Docker)
RUN ./mvnw dependency:go-offline

# Copier le code source
COPY src src

# Compiler
RUN ./mvnw clean package -DskipTests

### ---- STAGE 2 : Run ----
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
