pipeline {

    agent any

    options {
        ansiColor('xterm')
    }

    environment {
        HAXELIB_CACHE = '../../.haxelib_cache/ArpDomain/.haxelib'
    }

    stages {
        stage('prepare') {
            steps {
                githubNotify(context: 'swf', description: '', status: 'PENDING');
                githubNotify(context: 'js', description: '', status: 'PENDING');
                githubNotify(context: 'neko', description: '', status: 'PENDING');
                sh "haxelib newrepo"
                sh "haxelib git arp_ci https://github.com/ArpEngine/Arp-ci master --always"
                sh "haxelib run arp_ci sync"
            }
        }

        stage('swf') {
            steps {
                catchError {
                    sh "ARPCI_PROJECT=ArpDomain ARPCI_TARGET=swf haxelib run arp_ci test"
                }
            }
            post {
                always { junit(testResults: "bin/junit/swf.xml", keepLongStdio: true); }
                success { githubNotify(context: "${STAGE_NAME}", description: '', status: 'SUCCESS'); }
                unsuccessful { githubNotify(context: "${STAGE_NAME}", description: '', status: 'FAILURE'); }
            }
        }

        stage('js') {
            steps {
                catchError {
                    sh "ARPCI_PROJECT=ArpDomain ARPCI_TARGET=js haxelib run arp_ci test"
                }
            }
            post {
                always { junit(testResults: "bin/junit/js.xml", keepLongStdio: true); }
                success { githubNotify(context: "${STAGE_NAME}", description: '', status: 'SUCCESS'); }
                unsuccessful { githubNotify(context: "${STAGE_NAME}", description: '', status: 'FAILURE'); }
            }
        }

        stage('neko') {
            steps {
                catchError {
                    sh "ARPCI_PROJECT=ArpDomain ARPCI_TARGET=neko haxelib run arp_ci test"
                }
            }
            post {
                always { junit(testResults: "bin/junit/neko.xml", keepLongStdio: true); }
                success { githubNotify(context: "${STAGE_NAME}", description: '', status: 'SUCCESS'); }
                unsuccessful { githubNotify(context: "${STAGE_NAME}", description: '', status: 'FAILURE'); }
            }
        }
    }
}
