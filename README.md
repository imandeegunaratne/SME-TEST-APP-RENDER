# SME Loan Appraisal Application (Render-Ready)

A full-stack **SME Scoring and Loan Appraisal Application** prepared for deployment on **Render**.

## Overview

This application enables:
- **Bank admins** to manage SMEs, evaluators, and licenses
- **Evaluators** to score SMEs on defined criteria  
- **SMEs** to register and submit for evaluation
- **Reports** and analytics for bank administrators

## Architecture

### Tech Stack
- **Frontend:** React 19 + Vite + React Router + Tailwind CSS
- **Backend:** Django 5.0 + Django REST Framework
- **Database:** PostgreSQL
- **Deployment:** Render (Static Site + Web Service + PostgreSQL)

### Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                  Render                                     │
├─────────────────┬──────────────────┬────────────────────────┤
│                 │                  │                        │
│  Frontend       │  Backend         │  PostgreSQL            │
│  Static Site    │  Web Service     │  Database              │
│                 │                  │                        │
│  React/Vite    │  Django/DRF      │  sme_scoring           │
│  Port: 443      │  Port: 8000      │  Port: 5432            │
│                 │                  │                        │
│  dist/          │  Python 3.12+    │  Managed by Render    │
└────────┬────────┴────────┬─────────┴────────────────────────┘
         │                 │
         └─────────────────┘
            API Calls
         (REST/JSON)
```

## Project Structure

```
SME-TEST-APP-RENDER/
│
├── backend/                      # Django backend
│   ├── config/                   # Project settings/urls
│   │   ├── settings.py           # Django configuration (production-ready)
│   │   ├── urls.py               # URL routing
│   │   ├── wsgi.py               # WSGI application
│   │   └── asgi.py               # ASGI application
│   │
│   ├── core/                     # Main application logic
│   │   ├── models.py             # Database models
│   │   ├── views.py              # API views/viewsets
│   │   ├── serializers.py        # DRF serializers
│   │   ├── urls.py               # API routes
│   │   └── management/           # Custom management commands
│   │
│   ├── migrations/               # Database migrations
│   ├── requirements.txt          # Python dependencies
│   ├── build.sh                  # Render build script
│   ├── manage.py                 # Django management script
│   └── .gitignore
│
├── frontend/                     # React frontend
│   ├── src/
│   │   ├── App.jsx               # Root component
│   │   ├── main.jsx              # Entry point
│   │   ├── config/
│   │   │   └── api.js            # API configuration
│   │   ├── components/           # Reusable components
│   │   ├── pages/                # Page components
│   │   ├── styles/               # Styling
│   │   └── assets/               # Images, fonts
│   │
│   ├── public/                   # Static assets
│   ├── index.html                # HTML template
│   ├── vite.config.js            # Vite configuration
│   ├── package.json              # Node dependencies
│   ├── tailwind.config.js        # Tailwind CSS config
│   └── .gitignore
│
├── render.yaml                   # Render Blueprint (infrastructure as code)
├── .env.example                  # Example environment variables
├── .gitignore                    # Git ignore rules
└── README.md                     # This file
```

## Key Features

### Backend API
- **Authentication:** Token-based (DRF TokenAuthentication)
- **Authorization:** Role-based access control (RBAC)
  - Super Admin (system administration)
  - Bank Admin (bank management)
  - Evaluator (SME evaluation)
  - SME (self-registration)
- **CORS:** Properly configured for frontend communication
- **Static Files:** Served via WhiteNoise
- **Database:** PostgreSQL with migrations

### Frontend
- **Client-side Routing:** React Router for SPA navigation
- **API Integration:** Configured for Render environment
- **Authentication:** Token stored in localStorage
- **Responsive UI:** Tailwind CSS + custom components

## Local Development Setup

### Prerequisites
- Python 3.12+
- Node.js 18+ and npm
- PostgreSQL 15+ (or use Docker)

### Backend Setup

1. **Create and activate Python virtual environment:**
```bash
cd backend
python -m venv venv
source venv/bin/activate    # On Windows: venv\Scripts\activate
```

2. **Install dependencies:**
```bash
pip install -r requirements.txt
```

3. **Create `.env` file (copy from `.env.example`):**
```bash
cp .env.example .env
# Edit .env with your local database credentials
```

4. **Run migrations:**
```bash
python manage.py migrate
```

5. **Create superuser (optional):**
```bash
python manage.py createsuperuser
```

6. **Run development server:**
```bash
python manage.py runserver 0.0.0.0:8000
```

Backend will be available at: `http://localhost:8000`

### Frontend Setup

1. **Install dependencies:**
```bash
cd frontend
npm install
```

2. **Create `.env.local` (optional):**
```bash
# For local development, the Vite proxy handles API requests
# But you can override:
VITE_API_BASE_URL=http://localhost:8000
```

3. **Run development server:**
```bash
npm run build    # Or use: npm run dev
```

Frontend will be available at: `http://localhost:3000` (dev) or `http://localhost:5173` (vite preview)

### Test the Application

1. **Access the frontend:** http://localhost:3000 or http://localhost:5173

2. **Login with test account:**
   - Email: (created during registration)
   - Password: (created during registration)

3. **API Admin Panel:** http://localhost:8000/admin

4. **API Root:** http://localhost:8000/api/

5. **Health Check:** http://localhost:8000/api/health/

## Environment Variables

### Backend Variables

| Variable | Required | Example | Purpose |
|----------|----------|---------|---------|
| `SECRET_KEY` | ✅ Yes | (generated) | Django secret key (NEVER commit) |
| `DEBUG` | ❌ No | `0` | Debug mode (always `0` in production) |
| `DJANGO_ALLOWED_HOSTS` | ✅ Yes | `localhost,127.0.0.1` | Allowed hostnames |
| `DATABASE_URL` | ✅ Yes (prod) | `postgresql://...` | PostgreSQL connection (Render) |
| `DJANGO_CORS_ALLOWED_ORIGINS` | ✅ Yes | `https://frontend.onrender.com` | CORS allowed origins |
| `DJANGO_CSRF_TRUSTED_ORIGINS` | ✅ Yes | `https://frontend.onrender.com` | CSRF trusted origins |

**Local Development Fallback:** If `DATABASE_URL` is not set, uses individual env vars:
- `DB_ENGINE` (default: `django.db.backends.postgresql`)
- `DB_NAME` (default: `sme_scoring`)
- `DB_USER` (default: `postgres`)
- `DB_PASSWORD`
- `DB_HOST` (default: `localhost`)
- `DB_PORT` (default: `5432`)

### Frontend Variables

| Variable | Required | Example | Purpose |
|----------|----------|---------|---------|
| `VITE_API_BASE_URL` | ❌ No (dev) | `https://backend.onrender.com` | Backend API URL |

**Note:** During Render build, `VITE_API_BASE_URL` is automatically set to the backend service URL.

## Deployment to Render

### Prerequisites
- GitHub repository with this code
- Render account (free or paid)

### Deployment Steps

1. **Create Render account** at https://render.com

2. **Connect GitHub:**
   - Dashboard → Connect GitHub repository
   - Authorize Render access to your GitHub

3. **Deploy using Blueprint:**
   - Dashboard → Blueprints → Create Blueprint
   - Connect to GitHub
   - Point to this repository
   - Select `render.yaml`
   - Review and deploy

4. **Set Environment Variables:**
   - Go to Backend Service → Environment
   - Add `SECRET_KEY` (generate with Django):
     ```bash
     python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
     ```
   - Verify `DATABASE_URL` is set (auto-populated from PostgreSQL service)

5. **Update CORS after Frontend Deployment:**
   - Once frontend URL is known (e.g., `https://sme-frontend-xyz.onrender.com`)
   - Go to Backend Service → Environment
   - Update `DJANGO_CORS_ALLOWED_ORIGINS`
   - Update `DJANGO_CSRF_TRUSTED_ORIGINS`
   - Manually trigger a deploy (re-deploy from main branch)

6. **Access the Application:**
   - Frontend: `https://sme-frontend-xxx.onrender.com`
   - Backend API: `https://sme-backend-xxx.onrender.com/api/`

### Render Service Details

#### Backend (Django Web Service)
- **Type:** Web Service
- **Runtime:** Python 3.12
- **Build Command:** `./build.sh`
- **Start Command:** `gunicorn config.wsgi:application --bind 0.0.0.0:$PORT --workers 4 --timeout 60`
- **Port:** Automatically assigned by Render

#### Frontend (React Static Site)
- **Type:** Static Site
- **Build Command:** `npm install && npm run build`
- **Publish Directory:** `dist`
- **Port:** 443 (HTTPS)

#### Database (PostgreSQL)
- **Type:** PostgreSQL
- **Database Name:** `sme_scoring`
- **Automatic Connection:** `DATABASE_URL` provided to backend

## Important Production Notes

### Render Free Tier Limitations
- **Web services** spin down after 15 minutes of inactivity
- First request after spin-down may take **30+ seconds**
- **Solution:** Upgrade to paid plan for production or add monitoring/health checks

### Static Files
- Managed by **WhiteNoise** (included in `requirements.txt`)
- Collected during `build.sh` using `python manage.py collectstatic`
- Served by Django directly in production

### Media Files
- Uploaded files stored in `backend/media/` directory
- **WARNING:** Render has **ephemeral storage** - files deleted when service restarts
- **Solution for production:**
  - Upload to AWS S3, Google Cloud Storage, or Cloudinary
  - Configure Django to use cloud storage
  - Update media file handling in `settings.py`

### Database Backups
- Use Render's built-in PostgreSQL backups
- Dashboard → PostgreSQL → Backups
- Recommended: Enable automated backups

### SSL/HTTPS
- Automatically provided by Render
- HTTPS enforced via `SECURE_SSL_REDIRECT`
- HSTS headers configured

### Security
- `SECRET_KEY` never committed (set in Render Dashboard only)
- Database credentials never committed (use `DATABASE_URL`)
- HTTPS enforced in production
- CORS restricted to allowed origins
- CSRF protection enabled
- Session cookies marked `HttpOnly` and `Secure`

## Troubleshooting

### Backend Won't Start
1. Check logs: Render Dashboard → Backend Service → Logs
2. Verify `SECRET_KEY` is set in environment variables
3. Verify `DATABASE_URL` is configured correctly
4. Ensure migrations ran: `python manage.py migrate`

### Frontend Can't Reach Backend
1. Check `VITE_API_BASE_URL` is pointing to correct backend URL
2. Verify backend `DJANGO_CORS_ALLOWED_ORIGINS` includes frontend URL
3. Check CORS headers in browser DevTools Network tab
4. Verify backend service is running (check Dashboard)

### Database Connection Error
1. Verify `DATABASE_URL` is set correctly
2. Check PostgreSQL service status in Render Dashboard
3. Ensure migrations have run on backend startup
4. Check backend logs for detailed error

### Static Files Not Loading
1. Verify `collectstatic` ran successfully in build logs
2. Check `STATIC_URL` and `STATIC_ROOT` in `settings.py`
3. Verify frontend `dist/` is built correctly
4. Check browser DevTools for 404 errors

## API Endpoints

### Authentication
- `POST /api/login/` - Login with credentials
- `POST /api/signup/evaluator/` - Register as evaluator
- `POST /api/change-password/` - Change password

### SME Management
- `POST /api/sme/create/` - Create SME
- `GET /api/sme/<id>/` - Get SME details
- `POST /api/sme/<id>/scores/` - Save criterion scores
- `POST /api/sme/<id>/submit/` - Submit for evaluation

### Reports
- `GET /api/sme/report/` - Get SME report
- `GET /api/sme/report/pdf/` - Export PDF report

### Admin
- `GET /api/super-admin/overview/` - Super admin dashboard
- `GET /api/health/` - Health check endpoint

Full API documentation available after deployment at `/api/` endpoint.

## Development Guidelines

### Backend Code Style
- Follow Django conventions
- Use Django ORM instead of raw SQL
- Keep views thin, business logic in models/services
- Document complex logic with comments
- Use meaningful variable/function names

### Frontend Code Style
- Use functional components and hooks
- Keep components small and focused
- Use meaningful CSS class names (Tailwind)
- Structure pages in directories with index.jsx
- Document complex logic

### Database Migrations
- Create migrations for schema changes: `python manage.py makemigrations`
- Review migrations before committing
- Never modify existing migrations
- Test migrations locally before deployment

### Git Workflow
1. Always work on a feature branch
2. Keep commits atomic and well-described
3. Run tests before pushing
4. Create pull request for code review
5. Merge to main after review

## License

[Specify your license here]

## Support

For issues or questions:
1. Check logs on Render Dashboard
2. Review troubleshooting section above
3. Check application code for errors
4. Create GitHub issue with detailed description

## Additional Resources

- [Render Documentation](https://render.com/docs)
- [Django Documentation](https://docs.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)
- [React Documentation](https://react.dev/)
- [Vite Documentation](https://vitejs.dev/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
