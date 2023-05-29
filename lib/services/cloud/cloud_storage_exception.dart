class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNoteException implements CloudStorageException {} //C

class CouldNotGetAllNoteException implements CloudStorageException {} //R

class CouldNotUpdateNoteException implements CloudStorageException {} //U

class CouldNotDeleteNoteException implements CloudStorageException {} //D
