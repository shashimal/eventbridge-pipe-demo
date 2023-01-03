export const handler = async (event) => {
    console.log("Original event");
    console.log(event);
    const custom_fields_old = JSON.parse(event[0].custom_fields_old);
    console.log(custom_fields_old);
};

