# app/main.py
from dotenv import load_dotenv
load_dotenv()  # ← PREMIÈRE ligne, avant tout le reste

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.routers import auth, sessions, oaa, chat

app = FastAPI(
    title=settings.app_name,
    description="Backend OARA — EdTech Burkina Faso",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # restreindre en prod → ["https://ton-frontend.vercel.app"]
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router,     prefix="/auth",     tags=["Auth"])
app.include_router(sessions.router, prefix="/sessions", tags=["Sessions"])
app.include_router(oaa.router,      prefix="/oaa",      tags=["OAA"])
app.include_router(chat.router,     prefix="/chat",     tags=["Chat IA"])

@app.get("/")
def health_check():
    return {
        "status": "OARA backend opérationnel",
        "version": "1.0.0",
        "modules": ["auth", "sessions", "oaa", "chat"]
    }