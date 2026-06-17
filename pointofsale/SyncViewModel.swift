import SwiftUI
import SwiftData

@MainActor
class SyncViewModel: ObservableObject {
    
    private let syncService = SyncService()
      
    func startSync(context: ModelContext, controller: Controller) {
        controller.isLoading = true
        
        syncService.syncCategory(
            controller : controller,
            modelContext: context
        ) { success, message in
            controller.responseMessage = message
            controller.messageSyncronize = message
            if success {
                print("Sinkronisasi Berhasil \(message)")
            } else {
                print("Sinkronisasi Gagal: \(message)")
            }
            
            
            self.syncService.syncSetting(
                controller : controller,
                modelContext: context
            ) { success, message in
                
                controller.responseMessage = message
                controller.messageSyncronize = message
                if success {
                    print("Sinkronisasi Berhasil \(message)")
                } else {
                    print("Sinkronisasi Gagal: \(message)")
                }
                
                
                self.syncService.syncDiscount(
                    controller : controller,
                    modelContext: context
                ) { success, message in
                    controller.responseMessage = message
                    controller.messageSyncronize = message
                    if success {
                        print("Sinkronisasi Berhasil \(message)")
                    } else {
                        print("Sinkronisasi Gagal: \(message)")
                    }
                    
                    self.syncService.syncTender(
                        controller : controller,
                        modelContext: context
                    ) { success, message in
                        controller.responseMessage = message
                        controller.messageSyncronize = message
                        if success {
                            print("Sinkronisasi Berhasil \(message)")
                        } else {
                            print("Sinkronisasi Gagal: \(message)")
                        }
                        
                        self.syncService.syncSalestype(
                            controller : controller,
                            modelContext: context
                        ) { success, message in
                            controller.responseMessage = message
                            controller.messageSyncronize = message
                            if success {
                                print("Sinkronisasi Berhasil \(message)")
                            } else {
                                print("Sinkronisasi Gagal: \(message)")
                            }
                            
                            self.syncService.syncHeaderFooter(
                                controller : controller,
                                modelContext: context
                            ) { success, message in
                                controller.responseMessage = message
                                controller.messageSyncronize = message
                                if success {
                                    print("Sinkronisasi Berhasil \(message)")
                                } else {
                                    print("Sinkronisasi Gagal: \(message)")
                                }
                                
                                self.syncService.syncVoidreason(
                                    controller : controller,
                                    modelContext: context
                                ) { success, message in
                                    controller.responseMessage = message
                                    controller.messageSyncronize = message
                                    if success {
                                        print("Sinkronisasi Berhasil \(message)")
                                    } else {
                                        print("Sinkronisasi Gagal: \(message)")
                                    }
                                    
                                    self.syncService.syncItemadd(
                                        controller : controller,
                                        modelContext: context
                                    ) { success, message in
                                        controller.responseMessage = message
                                        controller.messageSyncronize = message
                                        if success {
                                            print("Sinkronisasi Berhasil \(message)")
                                        } else {
                                            print("Sinkronisasi Gagal: \(message)")
                                        }
                                        
                                        self.syncService.syncItemSize(
                                            controller : controller,
                                            modelContext: context
                                        ) { success, message in
                                            controller.responseMessage = message
                                            controller.messageSyncronize = message
                                            if success {
                                                print("Sinkronisasi Berhasil \(message)")
                                            } else {
                                                print("Sinkronisasi Gagal: \(message)")
                                            }
                                            
                                            self.syncService.syncSalesman(
                                                controller : controller,
                                                modelContext: context
                                            ) { success, message in
                                                controller.responseMessage = message
                                                controller.messageSyncronize = message
                                                if success {
                                                    print("Sinkronisasi Berhasil \(message)")
                                                } else {
                                                    print("Sinkronisasi Gagal: \(message)")
                                                }
                                                
                                                self.syncService.syncCalender(
                                                    controller : controller,
                                                    modelContext: context
                                                ) { success, message in 
                                                    controller.responseMessage = message
                                                    controller.messageSyncronize = message
                                                    if success {
                                                        print("Sinkronisasi Berhasil \(message)")
                                                    } else {
                                                        print("Sinkronisasi Gagal: \(message)")
                                                    }
                                                    
                                                    self.syncService.syncProduct(
                                                        controller : controller,
                                                        modelContext: context
                                                    ) { success, message in
                                                        controller.isLoading = false
                                                        controller.responseMessage = message
                                                        if success {
                                                            print("Sinkronisasi Berhasil \(message)")
                                                            controller.messageSyncronize = "Syncroniz Success"
                                                        } else {
                                                            print("Sinkronisasi Gagal: \(message)")
                                                            controller.messageSyncronize = "Product Not Found"
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                
            }
        }
       
        
    }
}
