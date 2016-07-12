require "spec_helper"

context "test_example" do
  let(:chef_conf) do
    ChefSpec::SoloRunner.new cookbook_path: %w(./test/cookbooks ../),
                             step_into: %w(example_topic)
  end

  let(:shellout) { double("shellout") }

  before do
    allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
    allow(shellout).to receive(:run_command)
    allow(shellout).to receive(:error!)
    allow(shellout).to receive(:live_stream)
    allow(shellout).to receive(:live_stream=)
  end

  describe "topic create" do
    let(:chef_run) { chef_conf.converge("test_example::create") }

    it "converges successfully" do
      allow(shellout).to receive(:stdout)
        .and_return("", "Created topic")

      expect { chef_run }.to_not raise_error
      expect(chef_run).to create_example_topic("test")
    end
  end

  describe "topic create - idempotent" do
    let(:chef_run) { chef_conf.converge("test_example::create_2") }

    it "converges successfully" do
      allow($stdout).to receive(:write)
      allow(shellout).to receive(:stderr)
      allow(shellout).to receive(:stdout)
        .and_return("Topic:something PartitionCount:1 ReplicationFactor:1 Configs:",
                    "Adding partitions succeeded!")

      expect { chef_run }.to_not raise_error
      expect(chef_run).to create_example_topic("test").with(partitions: 5)
    end
  end

  describe "topic update" do
    let(:chef_run) { chef_conf.converge("test_example::update") }

    it "converges successfully" do
      allow($stdout).to receive(:write)
      allow(shellout).to receive(:stderr)
      allow(shellout).to receive(:stdout)
        .and_return("Topic:something PartitionCount:1 ReplicationFactor:1 Configs:",
                    "Adding partitions succeeded!")

      expect { chef_run }.to_not raise_error
      expect(chef_run).to update_example_topic("test").with(partitions: 5)
    end
  end
end
