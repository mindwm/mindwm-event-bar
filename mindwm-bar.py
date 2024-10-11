from os import write
from jinja2 import Environment, FileSystemLoader
import shutil
import asyncio
import json
import re
from nats.aio.client import Client as NATS
import base64
import os

events = []
relationship_pattern = r"^org\.mindwm\.v1\.graph\.relationship\..*"

def event_icon(headers, event):
    icon = "images/icons/apps/terminal.png"
    if ("type" in event): 
        if event["type"] == "org.mindwm.v1.graph.created":
            icon = "images/icons/graph/node.png"
            if "obj" in event and "type" in event["obj"]: 
                if re.match(relationship_pattern, event["obj"]["type"]):
                    icon = "images/icons/graph/relationship.png"
                
                if event["obj"]["type"] == "org.mindwm.v1.graph.node.clipboard":
                    icon = "images/icons/apps/notes.png"
        
        if event["type"] == "org.mindwm.v1.pong":
            icon = "images/icons/pong.png"

    return icon

async def update_eww_config():
    print("update_eww_config")

    template_loader = FileSystemLoader(searchpath="./")
    env = Environment(loader=template_loader)
    template = env.get_template("buttons.jinja2")
    output = template.render(events=events[-23:])
    rendered_file_path = "_buttons.yuck"
    with open(rendered_file_path, "w") as rendered_file:
        rendered_file.write(output)
    destination_file_path = "buttons.yuck"
    shutil.copy(rendered_file_path, destination_file_path)
    print(f"Rendered content has been saved to {destination_file_path}") 

NATS_SERVER = os.getenv('NATS_SERVER')
SUBJECT = os.getenv('SUBJECT')



async def run():
    # Create NATS client
    nc = NATS()

    # Connect to the NATS server
    await nc.connect(NATS_SERVER)
    print(f"Connected to NATS server: {NATS_SERVER}")

    async def message_handler(msg):
        # Decode and parse the JSON message
        data = json.loads(msg.data.decode())
        data_encoded = base64.b64encode(json.dumps(data).encode("utf-8"))
        data_encoded_str = data_encoded.decode("utf-8")
        
        cmd_encoded = base64.b64encode(f'echo -n {data_encoded_str} | base64 -d | jq | nvim -c "set filetype=json" -R -'.encode("utf-8"))
        cmd_str = cmd_encoded.decode("utf-8")

        class_name = "show_event_xxx"

        events.append({
            "name": "Code", 
            "icon": event_icon({}, data),
            "action": f'lxterminal -e sh -c \'echo {cmd_str} | base64 -d | sh -\' &'
            #"action": f"kitty -e sh -c 'echo {data_encoded} | base64 -d | jq |  nvim -R -c set\\ filetype=json -'"
        })
        print(f"Received message on '{msg.subject}': {json.dumps(data, indent=4)}")
        await update_eww_config()

    # Subscribe to the specified subject
    await nc.subscribe(SUBJECT, cb=message_handler)
    print(f"Subscribed to topic: {SUBJECT}")

    # Keep the client running
    try:
        while True:
            await asyncio.sleep(1)
    finally:
        # Close the NATS connection
        await nc.close()
        print("Disconnected from NATS.")

# Run the async function
if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(run())

