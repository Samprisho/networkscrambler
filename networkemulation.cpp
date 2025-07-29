#include "networkemulation.h"
#include <QProcess>
#include <QDebug>
#include <iostream>

using namespace std;

NetworkEmulation::NetworkEmulation(QObject *parent)
  : QObject{parent}
{}

bool NetworkEmulation::executeNetworkEmulationCommand(
  const QString& device,
  const NetworkEmulationConditions& conditions)
{
  /* For production
  QString helperPath = "/usr/libexec/networkscrambler/network-helper.sh";

  QStringList arguments;
  arguments << helperPath
            << "apply_netem"
            << device
            << QString::number(conditions.delayBase)
            << QString::number(conditions.delayVariation)
            << QString::number(conditions.delayVariationPercentage)
            << QString::number(conditions.packetLossBase)
            << QString::number(conditions.packetLossVariation)
            << QString::number(conditions.packetLossPercentage);
*/

  // Development version - direct tc command
  QStringList arguments;
  arguments << "tc" << "qdisc" << "add" << "dev" << device << "root" << "netem";

  // Add delay if specified
  if (conditions.delayBase > 0) {
    arguments << "delay" << QString("%1ms").arg(conditions.delayBase);
    if (conditions.delayVariation > 0) {
      arguments << QString("%1ms").arg(conditions.delayVariation);
      if (conditions.delayVariationPercentage > 0) {
        arguments << QString("%1%").arg(conditions.delayVariationPercentage);
      }
    }
  }

  // Add packet loss if specified
  if (conditions.packetLossBase > 0) {
    arguments << "loss" << QString("%1%").arg(conditions.packetLossBase);
    if (conditions.packetLossVariation > 0) {
      arguments << QString("%1%").arg(conditions.packetLossVariation);
    }
  }

  QProcess process;
  process.start("pkexec", arguments);
  process.waitForFinished(10000); // 10 second timeout

  QString output = process.readAllStandardOutput();
  QString error = process.readAllStandardError();

  if (process.exitCode() != 0) {
    qDebug() << "Error executing network command:" << error;
    emit networkCommandFailed(error);
    return false;
  }

  qDebug() << "Network command executed successfully:" << output;
  emit networkCommandSuccess(output);
  return true;
}

bool NetworkEmulation::resetNetworkEmulation(const QString& device)
{
  /*
  QString helperPath = "/usr/libexec/networkscrambler/network-helper.sh";

  QStringList arguments;
  arguments << helperPath << "reset" << device;
  */

  QStringList arguments;
  arguments << "tc" << "qdisc" << "del" << "dev" << device << "root";

  QProcess process;
  process.start("pkexec", arguments);
  process.waitForFinished(10000);

  QString output = process.readAllStandardOutput();
  QString error = process.readAllStandardError();

  if (process.exitCode() != 0) {
    qDebug() << "Error resetting network:" << error;
    emit networkCommandFailed(error);
    return false;
  }

  qDebug() << "Network reset successfully:" << output;
  emit networkCommandSuccess("Network conditions reset successfully");
  return true;
}

void NetworkEmulation::invokeExecuteNetEm(
  QString device,
  float delay, float delayVar, float delayVarPct,
  float pcktLoss, float pcktLossVar)
{
  NetworkEmulationConditions conditions;
  conditions.delayBase = delay;
  conditions.delayVariation = delayVar;
  conditions.delayVariationPercentage = delayVarPct;
  conditions.packetLossBase = pcktLoss;
  conditions.packetLossVariation = pcktLossVar;

  qDebug() << "Applying network emulation to device:" << device;
  qDebug() << "Delay:" << delay << "±" << delayVar << "ms (" << delayVarPct << "%)";
  qDebug() << "Packet Loss:" << pcktLoss << "±" << pcktLossVar << "%";

  executeNetworkEmulationCommand(device, conditions);
}

void NetworkEmulation::invokeResetNetEm(QString device)
{
  qDebug() << "Resetting network emulation for device:" << device;
  resetNetworkEmulation(device);
}
