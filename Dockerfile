FROM openjdk:11-jdk AS builder
COPY . .
RUN chmod +x gradlew
RUN ./gradlew bootJar

FROM openjdk:11-slim
# 위에서 빌드한 jar 파일을 실행해 주기 위해 다시 JDK 11 버전을 베이스로 설정합니다.

COPY --from=builder build/libs/*.jar ci_cd-0.0.1-SNAPSHOT.jar
VOLUME /tmp
EXPOSE 8080
# builder를 통해 생성된 jar 파일을 이미지로 가져옵니다.
# 8080 포트를 공개한다고 명시합니다.

ENTRYPOINT ["java", "-jar", "/ci_cd-0.0.1-SNAPSHOT.jar"]
# 가져온 jar 파일을 실행시킵니다.