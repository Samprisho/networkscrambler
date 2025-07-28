import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

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
      text: "10"
      horizontalAlignment: Text.AlignHCenter
      Layout.fillWidth: false
      font.weight: Font.Medium
      echoMode: TextInput.Normal
      placeholderText: qsTr("Text Field")
      validator: DoubleValidator {
        bottom: 0
        top: 100
        decimals: 2
      }
    }
  }

  RowLayout {
    id: variationRow
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
      width: 50
      text: "5"
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
