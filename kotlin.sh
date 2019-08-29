#!/bin/bash
echo "This script sets up a basic Kotlin project with gradle build tools to use with VSC or Scripting Editors."
read -p "Enter project path (leave blank for current location):" project_path
read -p "Make sure you are inside the project folder. Press enter to proceed." continue
read -p "This setup script requires SDKMAN. Do you wish to install it? (y|n):" install_sdkman

if [[ "$project_path" = "" ]]
then
    project_path = "./"
fi
mkdir -p $project_path
cd $project_path

if [[ "$install_sdkman" = "y" || "$install_sdkman" = "Y" ]]
then
    curl -s https://get.sdkman.io | bash
fi

echo "Creating file build.gradle ..."
cat <<EOF >build.gradle
apply plugin: 'java'
apply plugin: 'konan'


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

sourceSets {
    main.java.srcDirs += 'src/main/kotlin/'
    test.java.srcDirs += 'src/test/kotlin/'
}

konan.targets = ['linux']

konanArtifacts {
    program('hello')
}
EOF

cat <<EOF >build.sh
#!/bin/bash
gradle clean build
EOF
chmod +x ./build.sh

cat <<EOF >run.sh
#!/bin/bash
gradle run
EOF
chmod +x ./run.sh

echo "Creating src/main/kotlin/hello.tk (project main)..."
mkdir -p src/main/kotlin
cd src/main/kotlin
cat <<EOF >hello.kt
fun main(args: Array<String>) {
    println("Hello Gradle!")
}
EOF

cd ../../..

read -p "Do you wish to install Gradle SDK with SDKMAN? (y|n):" install_gradle
if [[ "$install_gradle" = "y" || "$install_gradle" = "Y" ]]
then
    sdk install gradle
fi

read -p "Do you wish to install Kotlin SDK with SDKMAN? (y|n):" install_kotlin
if [[ "$install_kotlin" = "y" || "$install_kotlin" = "Y" ]]
then
    sdk install kotlin
fi
mkdir -p kotlin-native
wget https://github.com/JetBrains/kotlin-native/archive/v1.3.0.zip && unzip v1.3.0.zip -d kotlin-native && rm v1.3.0.zip

echo "Adding .gitignore, and initializing git components."
cat <<EOF >.gitignore
.vscode
kotlin.sh
.settings
.project
build.sh
run.sh
# check for more of those massive folders that need to be ignored
EOF

git init
echo "Make sure you reload your IDE. (Gradle and Kotlin installations require so if you use a scripting IDE)."
echo "Build your project with build.sh script. Run it with run.sh."
read -p "Done! Press any key to exit script." continue