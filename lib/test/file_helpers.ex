defmodule EncodingBits.Test.FileHelpers do  
  def write(path, body) do
    {:ok, file} = File.open(path, [:write])
    IO.binwrite(file, body)
    File.close(file)
  end

  def read(path) do
    {:ok, file} = File.open(path, [:read])
    contents = IO.binread(file, 99999)
    File.close(file)
    contents
  end

  def cleanup([file | files]) do
    File.rm_rf(file)
    cleanup(files)
  end

  def cleanup([]) do end
end