export const handler = async(event) => {
    // TODO implement
    console.log(JSON.stringify(event, null, 2));
    console.log(event)
    //console.log(event[0].dynamodb.NewImage.custom_fields["S"])
    //console.log(JSON.parse(event[0].dynamodb.NewImage.custom_fields["S"]).global)

    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
    return response;
};
