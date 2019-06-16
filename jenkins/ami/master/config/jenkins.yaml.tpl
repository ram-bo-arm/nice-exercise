jenkins:
  numExecutors: 12
  scmCheckoutRetryCount: 2
  mode: NORMAL

  agentProtocols:
  - "JNLP4-connect"
  - "Ping"

  slaveAgentPort: 50000

  securityRealm:
    local:
      allowsSignup: false
      enableCaptcha: false
      users:
      - id: "$${LOCAL_ID}"
        password: "$${LOCAL_PASS}"

  clouds:
    - amazonEC2:
        cloudName: "ec2"
        instanceCapStr: 2
        # this shouldn't be needed, since without explicit creds this should already be used
        # but let's be explicit to avoid issues.
        # Reminder: the following key has multiple lines
        privateKey: "$${EC2_KEY}"
        region: "eu-west-1"
        templates:
        - ami: "${jenkins_slave_ami}"
          amiType:
            unixData:
              sshPort: "22"
          associatePublicIp: false
          connectBySSHProcess: false
          connectionStrategy: PRIVATE_IP
          deleteRootOnTermination: false
          description: "jenkins-t2-small-slaves"
          ebsOptimized: false
          idleTerminationMinutes: "30"
          maxTotalUses: -1
          mode: NORMAL
          monitoring: false
          numExecutors: 3
          t2Unlimited: false
          type: T2Small
          useDedicatedTenancy: false
          useEphemeralDevices: false
          subnetId: "${jenkins_subnet_id}"
          securityGroups: "jenkins_slave_sg"
          labelString: "small-slave"
          remoteAdmin: "ubuntu"
          tags:
          - name: "Name"
            value: "node-jenkins-slave"
          - name: "owner"
            value: "dani-test"
        useInstanceProfileForCredentials: true

