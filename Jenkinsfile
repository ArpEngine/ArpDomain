pipeline {

    agent any

    stages {
        stage('prepare') {
            steps {
                githubNotify(context: 'swf', description: '', status: 'PENDING');
                githubNotify(context: 'js', description: '', status: 'PENDING');
                sh "haxelib newrepo"
                sh "haxelib git arp_ci https://github.com/ArpEngine/Arp-ci master --always"
                sh "haxelib run arp_ci sync"
            }
        }

        stage('swf') {
            steps {
                sh "ARPCI_PROJECT=ArpDomain ARPCI_TARGET=swf haxelib run arp_ci test"
            }
            post {
                success { githubNotify(context: "${STAGE_NAME}", description: '', status: 'SUCCESS'); }
                unsuccessful { githubNotify(context: "${STAGE_NAME}", description: '', status: 'FAILURE'); }
            }
        }

        stage('js') {
            steps {
                sh "ARPCI_PROJECT=ArpDomain ARPCI_TARGET=js haxelib run arp_ci test"
            }
            post {
                success { githubNotify(context: "${STAGE_NAME}", description: '', status: 'SUCCESS'); }
                unsuccessful { githubNotify(context: "${STAGE_NAME}", description: '', status: 'FAILURE'); }
            }
        }
    }

    post {
        always { junit(testResults: 'bin/report/*.xml', keepLongStdio: true); }
    }
}
