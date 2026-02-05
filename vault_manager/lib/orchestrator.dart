//Orchestrates storage layer, security layer and domain layer for UI to use
enum AppStates {
  //States represent status not action
  uninitialized,
  needsSetup,
  needsUnlock,
  unlocked,
  error,
}

class Orchestrator {
  AppStates currentstate = AppStates.uninitialized;

  AppStates initialize() {
    return AppStates.needsUnlock;
  }

  AppStates createVault() {}

  AppStates unlockVault() {}
}
