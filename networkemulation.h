#ifndef NETWORKEMULATION_H
#define NETWORKEMULATION_H

#include <QObject>
#include <QPermissions>
#include <QProcess>

class NetworkEmulation : public QObject
{
  Q_OBJECT

  public:
  explicit NetworkEmulation(QObject *parent = nullptr);

  struct NetworkEmulationConditions {
    float delayBase = 150.f;
    float delayVariation = 40.f;
    float delayVariationPercentage = 50.f;
    float packetLossBase = 8.f;
    float packetLossVariation = 5.f;
    float packetLossPercentage = 30.f;
  };

  bool executeNetworkEmulationCommand(const QString& device, const NetworkEmulationConditions& conditions);
  bool resetNetworkEmulation(const QString& device);

  Q_INVOKABLE void invokeExecuteNetEm(
    QString device,
    float delay,
    float delayVar,
    float delayVarPct,
    float pcktLoss,
    float pcktLossVar
    );

  Q_INVOKABLE void invokeResetNetEm(QString device);

  signals:
  void networkCommandSuccess(const QString& message);
  void networkCommandFailed(const QString& error);
};

#endif // NETWORKEMULATION_H
