import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
  id: window
  width: 600
  height: 380
  visible: true
  color: "#353333"
  maximumHeight: 380
  maximumWidth: 600
  minimumHeight: 380
  minimumWidth: 600
  modality: Qt.WindowModal
  flags: Qt.Window
  title: qsTr("Network Device Scrambler")

  function refreshDevices() {
    var devices = networkManager.getNetworkDevices();
    devicesComboBox.model = devices;
  }

  function applyNetworkEmulation() {
    if (devicesComboBox.currentText === "") {
      console.log("No device selected");
      return;
    }

    networkEmulation.invokeExecuteNetEm(devicesComboBox.currentText, parseFloat(
                                          delaySection.getDelayValue()),
                                        parseFloat(
                                          delaySection.getDelayVariation()),
                                        parseFloat(
                                          delaySection.getDelayPercentage()),
                                        parseFloat(
                                          packetLossSection.getPacketLossValue(
                                            )), parseFloat(
                                          packetLossSection.getPacketLossVariation(
                                            )), parseFloat(
                                          packetLossSection.getPacketLossPercentage(
                                            )));
  }

  function removeNetworkEmulation() {
    if (devicesComboBox.currentText === "") {
      console.log("No device selected");
      return;
    }

    networkEmulation.invokeResetNetEm(devicesComboBox.currentText);
  }

  Component.onCompleted: {
    refreshDevices();

    // Connect to network emulation signals
    networkEmulation.networkCommandSuccess.connect(function (message) {
      console.log("Success:", message);
    });

    networkEmulation.networkCommandFailed.connect(function (error) {
      console.log("Error:", error);
    });
  }

  ColumnLayout {
    id: column1
    anchors.fill: parent
    spacing: 3
    anchors {
      margins: 20
    }
    ColumnLayout {
      Layout.preferredWidth: 430
      Layout.fillHeight: true
      Layout.fillWidth: false
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      uniformCellSizes: false
      spacing: 20

      RowLayout {
        Layout.fillWidth: true
        Text {
          Layout.fillWidth: true
          color: "#ffffff"
          text: "Select device: "
          font.pointSize: 12
        }
        ComboBox {
          id: devicesComboBox
          model: []
        }
        Button {
          text: "Refresh"
          onClicked: refreshDevices()
        }
      }

      InputSection {
        id: delaySection
        itemName: "Delay"

        function getDelayValue() {
          return children[0].children[1].text;
        }
        function getDelayVariation() {
          return children[1].children[1].text;
        }
        function getDelayPercentage() {
          return children[2].children[1].text;
        }
      }

      PacketLossInput {
        id: packetLossSection
        itemName: "Packet loss"

        function getPacketLossValue() {
          return children[0].children[1].text;
        }
        function getPacketLossVariation() {
          return children[1].children[1].text;
        }
        function getPacketLossPercentage() {
          return children[2].children[1].text;
        }
      }

      RowLayout {
        Layout.alignment: Qt.AlignRight
        Button {
          id: remove
          text: "Remove"
          onClicked: removeNetworkEmulation()
        }
        Button {
          id: apply
          text: "Apply"
          onClicked: applyNetworkEmulation()
        }
      }
    }
  }
}
