#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define YUBIKEY_NAME "YubiKey"
#define CHECK_INTERVAL 2
#define HELP_TEXT                                                              \
  "yubilock - Lock macOS on YubiKey detachment.\n"                             \
  "\n"                                                                         \
  "Usage: yubilock [options]\n"                                                \
  "\n"                                                                         \
  "Automatically locks your macOS screen when a YubiKey is detached.\n"        \
  "This script is designed to run as a background service. When run without "  \
  "options,\n"                                                                 \
  "it will start monitoring for YubiKey detachment immediately.\n"             \
  "\n"                                                                         \
  "Options:\n"                                                                 \
  "  -h, --help    Show this help message and exit.\n"                         \
  "\n"                                                                         \
  "Installation (via Homebrew):\n"                                             \
  "  brew tap felix-kaesnter/yubilock "                                        \
  "https://github.com/felix-kaesnter/yubilock\n"                               \
  "  brew install yubilock\n"                                                  \
  "  brew services start yubilock\n"

void SACLockScreenImmediate();

bool is_yubikey_connected() {
  char command[256];
  snprintf(command, sizeof(command),
           "system_profiler SPUSBDataType 2>/dev/null | grep -q '%s'",
           YUBIKEY_NAME);
  return (system(command) == 0);
}

int main(int argc, char *argv[]) {
  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
      printf("%s", HELP_TEXT);
      exit(0);
    }
  }

  printf("Starting YubiKey lock monitor...\n");

  bool is_connected = is_yubikey_connected();

  if (is_connected) {
    printf("YubiKey is connected. Monitoring for detachment.\n");
  } else {
    printf("YubiKey is not connected. Waiting for connection...\n");
  }

  while (true) {
    bool currently_connected = is_yubikey_connected();

    if (currently_connected) {
      if (!is_connected) {
        printf("YubiKey re-connected.\n");
        is_connected = true;
      }
    } else {
      if (is_connected) {
        printf("YubiKey detached! Locking screen.\n");
        SACLockScreenImmediate();
        is_connected = false;
      }
    }

    sleep(CHECK_INTERVAL);
  }

  return 0;
}
