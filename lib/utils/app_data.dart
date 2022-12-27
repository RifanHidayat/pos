import 'package:siscom_pos/utils/loca_storage.dart';

class AppData {
  // SET

  static set statusOnboard(bool value) =>
      LocalStorage.saveToDisk('statusOnboard', value);

  static set informasiLoginUser(String value) =>
      LocalStorage.saveToDisk('informasiLoginUser', value);

  static set databaseSelected(String value) =>
      LocalStorage.saveToDisk('databaseSelected', value);

  static set periodeSelected(String value) =>
      LocalStorage.saveToDisk('periodeSelected', value);

  static set sysuserInformasi(String value) =>
      LocalStorage.saveToDisk('sysuserInformasi', value);

  static set cabangSelected(String value) =>
      LocalStorage.saveToDisk('cabangSelected', value);

  static set noFaktur(String value) =>
      LocalStorage.saveToDisk('noFaktur', value);

  static set arsipOrderPenjualan(String value) =>
      LocalStorage.saveToDisk('arsipOrderPenjualan', value);

  static set flagMember(String value) =>
      LocalStorage.saveToDisk('flagMember', value);

  static set includePPN(String value) =>
      LocalStorage.saveToDisk('includePPN', value);

  static set bidUsaha(String value) =>
      LocalStorage.saveToDisk('bidUsaha', value);

  // // GET

  static bool get statusOnboard {
    if (LocalStorage.getFromDisk('statusOnboard') != null) {
      return LocalStorage.getFromDisk('statusOnboard');
    }
    return false;
  }

  static String get informasiLoginUser {
    if (LocalStorage.getFromDisk('informasiLoginUser') != null) {
      return LocalStorage.getFromDisk('informasiLoginUser');
    }
    return "";
  }

  static String get databaseSelected {
    if (LocalStorage.getFromDisk('databaseSelected') != null) {
      return LocalStorage.getFromDisk('databaseSelected');
    }
    return "";
  }

  static String get sysuserInformasi {
    if (LocalStorage.getFromDisk('sysuserInformasi') != null) {
      return LocalStorage.getFromDisk('sysuserInformasi');
    }
    return "";
  }

  static String get periodeSelected {
    if (LocalStorage.getFromDisk('periodeSelected') != null) {
      return LocalStorage.getFromDisk('periodeSelected');
    }
    return "";
  }

  static String get cabangSelected {
    if (LocalStorage.getFromDisk('cabangSelected') != null) {
      return LocalStorage.getFromDisk('cabangSelected');
    }
    return "";
  }

  static String get noFaktur {
    if (LocalStorage.getFromDisk('noFaktur') != null) {
      return LocalStorage.getFromDisk('noFaktur');
    }
    return "";
  }

  static String get arsipOrderPenjualan {
    if (LocalStorage.getFromDisk('arsipOrderPenjualan') != null) {
      return LocalStorage.getFromDisk('arsipOrderPenjualan');
    }
    return "";
  }

  static String get flagMember {
    if (LocalStorage.getFromDisk('flagMember') != null) {
      return LocalStorage.getFromDisk('flagMember');
    }
    return "";
  }

  static String get includePPN {
    if (LocalStorage.getFromDisk('includePPN') != null) {
      return LocalStorage.getFromDisk('includePPN');
    }
    return "";
  }

  static String get bidUsaha {
    if (LocalStorage.getFromDisk('bidUsaha') != null) {
      return LocalStorage.getFromDisk('bidUsaha');
    }
    return "";
  }

  // CLEAR ALL DATA

  static void clearAllData() =>
      LocalStorage.removeFromDisk(null, clearAll: true);
}
