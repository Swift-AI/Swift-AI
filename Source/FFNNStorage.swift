// MARK:- Storage protocol
extension FFNN: Storage {

    /// Reads a FFNN from file.
    /// - Parameter filename: The name of the file, located in the default Documents directory.
    public static func fromFile(filename: String) -> FFNN? {
        return self.read(self.getFileURL(filename))
    }

    /// Reads a FFNN from file.
    /// - Parameter url: The `NSURL` for the file to read.
    public static func fromFile(url: NSURL) -> FFNN? {
        return self.read(url)
    }

    /// Writes the FFNN to file.
    /// - Parameter filename: The name of the file to write to. This file will be written to the default Documents directory.
    public func writeToFile(filename: String) {
        self.write(FFNN.getFileURL(filename))
    }

    /// Writes the FFNN to file.
    /// - Parameter url: The `NSURL` to write the file to.
    public func writeToFile(url: NSURL) {
        self.write(url)
    }

}
