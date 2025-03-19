import ballerina/lang.value;
import ballerina/log;
import ballerinax/rabbitmq;

listener rabbitmq:Listener rabbitmqListener = new (host = "localhost", port = 5672, username = rabbitmqUsername, password = rabbitmqPassword, virtualHost = rabbitmqVHost);

@rabbitmq:ServiceConfig {
    queueName: "ehr_updates",
    config: {
        durable: true,
        autoDelete: false
    }
}
service rabbitmq:Service "ehr_updates" on rabbitmqListener {
    remote function onMessage(rabbitmq:AnydataMessage message, rabbitmq:Caller caller) returns error? {
        do {
            anydata content = message.content;
            if content is byte[] {
                string contentStr = check string:fromBytes(content);
                LabResult labResult = check value:fromJsonStringWithType(contentStr);
                log:printInfo(labResult.toString());
                check caller->basicAck(true);
            }
        } on fail error err {
            // handle error
            return error("Not implemented", err);
        }
    }
}
