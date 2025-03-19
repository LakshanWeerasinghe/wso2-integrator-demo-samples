import ballerinax/rabbitmq;

final rabbitmq:Client rabbitmqClient = check new (rabbitmaHost, rabbitmqPort, username = rabbitmqUsername, password = rabbitmqPassword, virtualHost = rabbitmqVHost);
