#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QProcess>
#include <QStringList>
#include <QDebug>
#include <QProcess>

class NetworkManager : public QObject
{
  Q_OBJECT
  public:

  explicit NetworkManager(QObject *parent = nullptr);

  Q_INVOKABLE QStringList getNetworkDevices();

  private:

  void extractDeviceNames(QStringList &devices, QStringList &lines);

  signals:
};

#endif // NETWORKMANAGER_H
