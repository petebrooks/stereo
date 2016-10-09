defmodule NameTest do
  use ExUnit.Case
  doctest Stereo.Name

  import Stereo.Name

  # Stereo.Name.ffmpeg_pattern
  test "with four-digit padding" do
    path = "~/Documents/testing/image_0004.tif"
    assert "~/Documents/testing/image_%04d.tif" == Stereo.Name.ffmpeg_pattern(path)
  end

  test "with three-digit padding" do
    path = "~/Documents/testing/image_004.tif"
    assert "~/Documents/testing/image_%03d.tif" == Stereo.Name.ffmpeg_pattern(path)
  end

  test "with 2-digit padding" do
    path = "~/Documents/testing/image_04.tif"
    assert "~/Documents/testing/image_%02d.tif" == Stereo.Name.ffmpeg_pattern(path)
  end

  test "with other numbers in path" do
    path = "~/Documents/testing_123/image_0004.tif"
    assert "~/Documents/testing_123/image_%04d.tif" == Stereo.Name.ffmpeg_pattern(path)
  end
end