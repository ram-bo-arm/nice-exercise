#!groovy

import jenkins.model.*
import hudson.util.*;
import jenkins.install.*;

def instance = Jenkins.getInstance()


if (!instance.installState.isSetupComplete()) {
  println '--> Neutering SetupWizard'
  InstallState.INITIAL_SETUP_COMPLETED.initializeState()
}


instance.save()


