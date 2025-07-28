import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 2.15

ColumnLayout {
  id: root
  height: 100
  spacing: 10
  uniformCellSizes: false
  layoutDirection: Qt.LeftToRight

  Layout.fillWidth: true
  Layout.minimumHeight: 40
  Layout.minimumWidth: 100

  property string itemName: "value"
  property alias valueText: valueInput.text
  property alias variationText: variationInput.text
  property alias percentageText: percentageInput.text

  width: 400

  RowLayout {
    id: valueRow
    Layout.preferredWidth: 100
    layoutDirection: Qt.LeftToRight
    uniformCellSizes: false
    Text {
      id: valueLabel
      color: "#ffffff"
      text: itemName
      horizontalAlignment: Text.AlignLeft
      font.pointSize: 12
      Layout.fillWidth: true
    }

    TextField {
      id: valueInput
      width: 50
      text: "200"
      horizontalAlignment: Text.AlignHCenter
      Layout.preferredWidth: 80
      Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
      antialiasing: false
      Layout.fillWidth: false
      font.weight: Font.Medium
      echoMode: TextInput.Normal
      placeholderText: qsTr("Text Field")
      validator: DoubleValidator {
        bottom: 0
        top: 10000
        decimals: 2
      }
    }

    ComboBox {
      id: valueCombo
      width: 100
      Layout.fillWidth: false
      font.pointSize: 10
      focusPolicy: Qt.StrongFocus
      wheelEnabled: true
      currentIndex: 1
      Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
      model: ["Seconds", "Milliseconds", "Microseconds"]
    }
  }

  RowLayout {
    id: variationRow
    Layout.fillWidth: true
    Text {
      id: variationLabel
      color: "#ffffff"
      text: itemName + " variation"
      horizontalAlignment: Text.AlignLeft
      font.pointSize: 12
      Layout.fillWidth: true
    }

    TextField {
      id: variationInput
      width: 30
      text: "50"
      horizontalAlignment: Text.AlignHCenter
      Layout.preferredWidth: 80
      Layout.fillHeight: false
      Layout.fillWidth: false
      Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
      placeholderText: qsTr("Text Field")
      font.weight: Font.Medium
      echoMode: TextInput.Normal
      validator: DoubleValidator {
        bottom: 0
        top: 10000
        decimals: 2
      }
    }

    ComboBox {
      id: variationCombo
      width: 100
      wheelEnabled: true
      model: ["Seconds", "Milliseconds", "Microseconds"]
      font.pointSize: 10
      focusPolicy: Qt.StrongFocus
      currentIndex: 1
      Layout.fillWidth: false
      Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    }
  }

  RowLayout {
    id: percentageRow
    Text {
      id: percentageLabel
      color: "#ffffff"
      text: itemName + " percentage"
      horizontalAlignment: Text.AlignLeft
      font.pointSize: 12
      Layout.fillWidth: true
    }

    TextField {
      id: percentageInput
      width: 50
      text: "10"
      horizontalAlignment: Text.AlignHCenter
      placeholderText: qsTr("Text Field")
      font.weight: Font.Medium
      echoMode: TextInput.Normal
      validator: DoubleValidator {
        bottom: 0
        top: 100
        decimals: 2
      }
    }
  }
}
