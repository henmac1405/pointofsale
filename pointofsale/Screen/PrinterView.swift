import SwiftUI
import CoreBluetooth
 
struct BluetoothDevice: Identifiable {
    let id: UUID
    let name: String
    let macAddress: String
}

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var discoveredDevices: [BluetoothDevice] = []
    @Published var isScanning = false
    
    var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        if centralManager.state == .poweredOn {
            discoveredDevices.removeAll()
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            isScanning = true
             
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.stopScanning()
            }
        }
    }
    
    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
    }
     
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Bluetooth tidak aktif")
        }
    }
     
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi NSNumber: NSNumber) {
        let name = peripheral.name ?? "Unknown Device"
         
        if !discoveredDevices.contains(where: { $0.id == peripheral.identifier }) {
            let newDevice = BluetoothDevice(id: peripheral.identifier, name: name, macAddress: peripheral.identifier.uuidString)
            discoveredDevices.append(newDevice)
        }
    }
}

struct PrinterView: View {
    @StateObject var btManager = BluetoothManager()
    @State private var selectedDevice: UUID?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                 
                HStack {
                    Text("Printer")
                        .font(.title2).fontWeight(.medium)
                    if btManager.isScanning {
                        ProgressView().padding(.leading, 10)
                    }
                    Spacer()
                }
                .padding()
                 
                List(btManager.discoveredDevices, selection: $selectedDevice) { device in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(device.name)
                            .font(.system(size: 18))
                        Text(device.macAddress)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
                 
                VStack(spacing: 12) {
                    Button("Connect") {  }
                        .buttonStyle(PrimaryButtonStyle(color: .purple.opacity(0.1), textColor: .purple))
                    
                    Button(action: {dismiss()}) {
                        Text("TUTUP")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }
                .padding()
            }
            
            
            Button(action: {
                btManager.startScanning()
            }) {
                Image(systemName: btManager.isScanning ? "stop.fill" : "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.purple.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding(.trailing, 20)
            .padding(.bottom, 100)
        }
    }
}
 
struct PrimaryButtonStyle: ButtonStyle {
    var color: Color
    var textColor: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 160, height: 45)
            .background(color)
            .foregroundColor(textColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
#Preview {
    PrinterView()
}
