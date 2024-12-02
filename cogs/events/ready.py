from discord.ext import commands

class Ready(commands.Cog):
    def __init__(self, bot: commands.Bot):
        self.bot = bot 

    @commands.Cog.listener()
    async def on_ready(self):
        if self.bot.user is None:
            return

        name = self.bot.user.display_name 
        
        print(f'Client ready in {name}')

async def setup(bot: commands.Bot):
    await bot.add_cog(Ready(bot))

