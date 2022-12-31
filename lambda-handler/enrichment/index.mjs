export const handler = async (event) => {
    console.log("Original event");
    console.log(event);

    const orderQty = event[0].orderQty;
    const orderPrice = event[0].orderPrice;
    let discountPercentage = 0;

    if (orderQty >= 100) {
        discountPercentage = "50%";
    } else if (orderQty >= 50 && orderQty < 100) {
        discountPercentage = "30%";
    } else {
        discountPercentage = "10%";
    }

    const response = {
        orderDate: new Date(),
        orderQty: orderQty,
        orderPrice: orderPrice,
        discountPercentage: discountPercentage
    };

    console.log("Enriched event");
    console.log(response);

    return response;
};
