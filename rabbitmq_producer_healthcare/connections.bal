import ballerinax/rabbitmq;

final rabbitmq:Client rabbitmqClient = check new ("localhost", 5672, username = rabbitmqUsername, password = rabbitmqPassword, virtualHost = rabbitmqVHost);
