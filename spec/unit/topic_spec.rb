require "spec_helper"

describe "topic" do
  context "helpers" do
    let(:shellout) { double("shellout") }
    let(:helpers) { Object.new.extend(Kafka::Topic) }
    before do
      allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
      allow(shellout).to receive(:run_command)
      allow(shellout).to receive(:error!)
      allow(shellout).to receive(:live_stream)
      allow(shellout).to receive(:live_stream=)
    end

    it "list valid topic" do
      allow(shellout).to receive(:stdout)
        .and_return("Topic:something PartitionCount:18	ReplicationFactor:5	Configs:")

      result = helpers.list "directory",
                            "localhost:2181",
                            "something"

      expect(result[:partitions]).to be 18
      expect(result[:replicas]).to be 5
    end

    it "list unknown topic" do
      allow(shellout).to receive(:stdout).and_return("")

      result = helpers.list "directory",
                            "localhost:2181",
                            "something"

      expect(result[:partitions]).to be_nil
      expect(result[:replicas]).to be_nil
    end

    it "create topic with success" do
      allow($stdout).to receive(:write)
      allow(shellout).to receive(:stdout).and_return("Created topic")
      allow(shellout).to receive(:stderr)

      result = helpers.create! "directory",
                               "localhost:2181",
                               "something",
                               1,
                               1
      expect(result).to be_nil
    end

    it "create topic with error - already exists" do
      allow($stdout).to receive(:write)
      allow(shellout).to receive(:stdout).and_return("already exists")
      allow(shellout).to receive(:stderr)

      result = helpers.create! "directory",
                               "localhost:2181",
                               "something",
                               1,
                               1
      expect(result).to_not be_nil
    end

    it "create topic with error - error" do
      allow($stdout).to receive(:write)
      allow(shellout).to receive(:stdout).and_return("Connection refused")
      allow(shellout).to receive(:stderr)

      result = helpers.create! "directory",
                               "localhost:2181",
                               "something",
                               1,
                               1
      expect(result).to_not be_nil
    end

    it "alter topic with success" do
      allow($stdout).to receive(:write)
      allow(shellout).to receive(:stdout).and_return("Adding partitions succeeded")
      allow(shellout).to receive(:stderr)

      result = helpers.alter! "directory",
                              "localhost:2181",
                              "something",
                              1

      expect(result).to_not be_nil
    end

    it "alter topic with error" do
      allow($stdout).to receive(:write)
      allow(shellout).to receive(:stdout).and_return("Connection refused")
      allow(shellout).to receive(:stderr)

      result = helpers.alter! "directory",
                              "localhost:2181",
                              "something",
                              1

      expect(result).to_not be_nil
    end
  end
end
