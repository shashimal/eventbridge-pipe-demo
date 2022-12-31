export const handler = async (event) => {
    console.log("Original event");
    console.log(event);

    const item = event[0].item;
    const qty = event[0].qty;
    const price = event[0].price;
    let discount = 0;

    if (qty >= 100) {
        discount = "50%";
    } else if (qty >= 50 && qty < 100) {
        discount = "30%";
    } else {
        discount = "10%";
    }

    const response = {
        date: new Date(),
        item,
        qty,
        price,
        discount
    };

    console.log("Enriched event");
    console.log(response);

    return response;
};
