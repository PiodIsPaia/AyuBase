import discord, os
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()

class Ayu(commands.Bot):
    def __init__(self):
        intents = discord.Intents.all()
        prefix = commands.when_mentioned_or(str(os.getenv('PREFIX')))
        activity = discord.CustomActivity(name='In development.')
        super().__init__(command_prefix=prefix, intents=intents, activity=activity)

    async def setup_hook(self):
        await self.load_cogs()
        await self.tree.sync()

    async def load_cogs(self):
        for dirpath, _, filenames in os.walk('./cogs'):
            for filename in filenames:
                if filename.endswith('.py'):
                    relative_path = os.path.relpath(dirpath, './cogs')
                    if relative_path == '.':
                        module_name = f'cogs.{filename[:-3]}'
                    else:
                        module_name = f'cogs.{relative_path.replace(os.sep, ".")}.{filename[:-3]}'

                    try:
                        await self.load_extension(module_name)

                        #print(f'{module_name} Loaded successfully')
                    except Exception as e:
                        print(f'Failed to load {module_name}: {e}')

if __name__ == "__main__":
    ayu = Ayu()

    ayu.run(str(os.getenv("AYU_CANARY_TOKEN")))

