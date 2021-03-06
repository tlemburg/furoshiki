require 'spec_helper'
require 'fileutils'
require 'furoshiki/zip'

describe Furoshiki::Zip::Directory do
  subject { Furoshiki::Zip::Directory.new input_dir, output_file }

  context "output file" do
    include_context 'zip'

    before :all do
      zip_directory = Furoshiki::Zip::Directory.new input_dir, @output_file
      zip_directory.write
      @zip = ::Zip::File.open @output_file
    end

    it "exists" do
      expect(@output_file).to exist
    end

    it "includes input directory without parents" do
      expect(@zip.entries.map(&:name)).to include(add_trailing_slash input_dir.basename)
    end

    relative_input_paths(input_dir.parent).each do |path|
      it "includes all children of input directory" do
        expect(@zip.entries.map(&:name)).to include(path)
      end
    end

    it "doesn't include extra files" do
      number_of_files = Dir.glob("#{input_dir}/**/*").push(input_dir).length
      expect(@zip.entries.length).to eq(number_of_files)
    end
  end
end
