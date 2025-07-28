#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QDebug>
#include <QStringList>
#include <QQmlContext>
#include <QProcess>

#include <networkmanager.h>
#include <networkemulation.h>

#include <iostream>

using namespace std;

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;

  NetworkManager networkManager;
  NetworkEmulation networkEmulation;

  engine.rootContext()->setContextProperty("networkManager", &networkManager);
  engine.rootContext()->setContextProperty("networkEmulation", &networkEmulation);

  QObject::connect(
    &engine,
    &QQmlApplicationEngine::objectCreationFailed,
    &app,
    []() { QCoreApplication::exit(-1); },
    Qt::QueuedConnection
  );

  engine.loadFromModule("NetworkScrambler", "Main");
  return app.exec();
}

