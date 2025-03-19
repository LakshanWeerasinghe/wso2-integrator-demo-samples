import ballerina/http;
import ballerina/log;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service / on httpDefaultListener {

    resource function post result(@http:Payload LabResult labResult) returns error|http:Accepted {
        do {
            log:printInfo(labResult.toString());
            check rabbitmqClient->publishMessage({
                content: labResult,
                routingKey: "lab.result.completed",
                exchange: "lab_events"
            });
            return http:ACCEPTED;
        } on fail error err {
            // handle error
            return error("Not implemented", err);
        }
    }
}
