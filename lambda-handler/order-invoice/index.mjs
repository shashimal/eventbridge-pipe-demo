export const handler = async(event) => {
    console.log("Original event");
    console.log(event);
    return event;
};
