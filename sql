-- db/schema.sql
CREATE TABLE alumni (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  batch_year INT,
  degree TEXT,
  job_title TEXT,
  company TEXT,
  linkedin TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  starts_at TIMESTAMPTZ NOT NULL,
  venue TEXT,
  created_by TEXT
);

CREATE TABLE rsvp (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id UUID REFERENCES events(id) ON DELETE CASCADE,
  alumni_id UUID REFERENCES alumni(id) ON DELETE CASCADE,
  response TEXT CHECK (response IN ('Yes','No','Maybe')),
  responded_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE (event_id, alumni_id)
);

CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  alumni_id UUID REFERENCES alumni(id) ON DELETE SET NULL,
  event_id UUID REFERENCES events(id) ON DELETE SET NULL,
  channel TEXT CHECK (channel IN ('email','whatsapp','sms')),
  status TEXT CHECK (status IN ('queued','sent','failed')) DEFAULT 'queued',
  payload JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);
