include Kafka::Topic

property :topic,      String, name_property: true
property :partitions, Fixnum, default: 3
property :replicas,   Fixnum, default: 3
property :zookeeper,  String, default: "localhost:2181"
property :directory,  String, default: "/kafka"

load_current_value do
  current_partitions, current_replicas = list(directory, zookeeper, topic)
                                         .values_at *%w(partitions replicas)

  current_value_does_not_exist! unless current_partitions

  partitions current_partitions
  replicas current_replicas
end

action :create do
  converge_if_changed do
    if current_resource
      action_update
    else
      converge_by "Create topic #{new_resource.topic}" do
        create! new_resource.directory,
                new_resource.zookeeper,
                new_resource.topic,
                new_resource.partitions,
                new_resource.replicas
      end
    end
  end
end

action :update do
  alter! new_resource.directory,
         new_resource.zookeeper,
         new_resource.topic,
         new_resource.partitions
end
