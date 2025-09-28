-- Initialize the notes database
-- This script runs when the PostgreSQL container starts for the first time

-- Create the notes table
CREATE TABLE IF NOT EXISTS notes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create an index on created_at for better query performance
CREATE INDEX IF NOT EXISTS idx_notes_created_at ON notes(created_at);

-- Insert some sample data for testing
INSERT INTO notes (title, content) VALUES 
    ('Welcome to Notes App', 'This is your first note! You can edit or delete it.'),
    ('Getting Started', 'Use the form above to create new notes. Each note can have a title and content.'),
    ('Features', 'You can create, read, update, and delete notes. The app automatically saves your changes.')
ON CONFLICT DO NOTHING;

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create a trigger to automatically update the updated_at column
DROP TRIGGER IF EXISTS update_notes_updated_at ON notes;
CREATE TRIGGER update_notes_updated_at
    BEFORE UPDATE ON notes
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

