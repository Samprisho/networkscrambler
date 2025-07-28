#include "networkmanager.h"

NetworkManager::NetworkManager(QObject *parent)
    : QObject{parent}
{
}

void NetworkManager::extractDeviceNames(
    QStringList &devices, QStringList &lines
    )
{
  for (int i = 0; i < lines.length(); i++) {
    QString &line = lines[i];
    if (i % 2 == 0 && line.contains(':')) {
      QString deviceName = line.split(':')[1].trimmed();
      devices.append(deviceName);
    }
  }
}

QStringList NetworkManager::getNetworkDevices() {
  QProcess process;
  process.start("ip", QStringList() << "link" << "show");
  process.waitForFinished();
  QString output = process.readAllStandardOutput();
  QStringList lines = output.split('\n');

  QStringList devices;

  extractDeviceNames(devices, lines);

  return devices;
}
