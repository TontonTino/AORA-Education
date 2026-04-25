from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    supabase_url: str
    supabase_key: str
    gemini_api_key: str
    app_name: str = "OARA Backend"
    debug: bool = True

    class Config:
        env_file = ".env"

settings = Settings()