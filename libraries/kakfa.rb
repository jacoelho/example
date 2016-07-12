require "chef/log"

include Chef::Mixin::ShellOut

module Kafka
  module Topic
    def list(directory, zookeeper, topic)
      cmd = %W(
        #{directory}/bin/kafka-topics.sh
        --zookeeper #{zookeeper}
        --describe
        --topic #{topic}
      ).join(" ")

      result = shell_out(cmd).stdout
      extract = ->(a) { a && a.to_i }

      {
        partitions: extract.call(result[/PartitionCount:\s*(\d+)/, 1]),
        replicas: extract.call(result[/ReplicationFactor:\s*(\d+)/, 1])
      }
    end

    def create!(directory, zookeeper, topic, partitions, replicas)
      cmd = %W(
        #{directory}/bin/kafka-topics.sh
        --zookeeper #{zookeeper}
        --create
        --topic #{topic}
        --replication-factor #{replicas}
        --partitions #{partitions}
      ).join(" ")

      result = shell_out(cmd)
      Chef::Log.error(result.stderr) unless result.stdout =~ /Created topic/
    end

    def alter!(directory, zookeeper, topic, partitions)
      cmd = %W(
        #{directory}/bin/kafka-topics.sh
        --zookeeper #{zookeeper}
        --alter
        --topic #{topic}
        --partitions #{partitions}
      ).join(" ")

      result = shell_out(cmd)
      Chef::Log.error(result.stderr) unless result.stdout =~ /Adding partitions succeeded!/
    end
  end
end
