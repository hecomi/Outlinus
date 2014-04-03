#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include "ovrvision.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QtQuick2ApplicationViewer viewer;

    qmlRegisterType<OVRVisionItem>("OVRVision", 1, 0, "OVRVision");

    viewer.setMainQmlFile(QStringLiteral("qml/OVRVisionOpenCV/main.qml"));
    viewer.showFullScreen();

    return app.exec();
}
