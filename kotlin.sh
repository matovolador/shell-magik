#!/bin/bash
echo "This script sets up a basic Kotlin project with gradle build tools to use with VSC or Scripting Editors."
read -p "Make sure you are inside the project folder. Press enter to proceed." continue

echo "Creating file build.gradle ..."
cat <<EOF >build.gradle
buildscript {
    repositories {
        mavenCentral()
        maven {
            url "https://dl.bintray.com/jetbrains/kotlin-native-dependencies"
        }
    }
    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-native-gradle-plugin:+"
    }
}

apply plugin: 'konan'

konan.targets = ['linux']

konanArtifacts {
    program('hello')
}
EOF

echo "Creating src/main/kotlin/hello.tk (project main)..."
mkdir -p src/main/kotlin
cd src/main/kotlin
cat <<EOF >hello.kt
fun main(args: Array<String>) {
    println("Hello Gradle!")
}
EOF

cd ../../..
echo "Retreiving kotlin-native binaries from github..."
mkdir -p kotlin-native
wget https://github.com/JetBrains/kotlin-native/archive/v1.3.0.zip && unzip v1.3.0.zip -d kotlin-native && rm v1.3.0.zip

echo "Adding .gitignore, and initializing git components."
cat <<EOF >.gitignore
kotlin-native
.vscode
kotlin.sh
# check for more of those massive folders that need to be ignored
EOF

git init

read -p "Done! Press any key to exit script." continue