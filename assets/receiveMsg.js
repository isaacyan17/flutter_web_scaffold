export function receiveMessage(jsonStr) {
    if(jsonStr !== undefined && jsonStr !== "") {
        let data = JSON.parse(JSON.stringify(jsonStr));
        console.log(`来自Native的消息----> ${data.api}`);
        window.jsBridgeHelper.receiveMessage(data);
    }
}