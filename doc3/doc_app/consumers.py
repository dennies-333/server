import asyncio
import json
from channels.generic.websocket import AsyncWebsocketConsumer

class DataConsumer(AsyncWebsocketConsumer):

    async def connect(self):
        if len(self.channel_layer.groups.get("data_clients", set())) >= 2:
            # Maximum two clients allowed, reject connection
            await self.close()
        else:
            await self.channel_layer.group_add("data_clients", self.channel_name)
            await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard("data_clients", self.channel_name)

    async def receive(self, text_data):
        # Process received data here
        data = json.loads(text_data)

        # Broadcast the received data to all clients in the group
        await self.channel_layer.group_send(
            "data_clients",
            {
                "type": "data_message",
                "data": data,
            }
        )

    async def data_message(self, event):
        # Send data to the client
        data = event["data"]
        await self.send(text_data=json.dumps(data))

