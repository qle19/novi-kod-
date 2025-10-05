-- Create enum for user types
CREATE TYPE user_type AS ENUM ('personal', 'business');

-- Update profiles table to support both personal and business users
ALTER TABLE public.profiles 
ADD COLUMN user_type user_type DEFAULT 'personal',
ADD COLUMN business_name text,
ADD COLUMN business_type text,
ADD COLUMN tax_id text,
ADD COLUMN business_address text,
ADD COLUMN business_city text,
ADD COLUMN website text,
ADD COLUMN contact_person text;

-- Update the trigger function to handle user type from metadata
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
BEGIN
  INSERT INTO public.profiles (
    user_id, 
    full_name, 
    user_type,
    business_name,
    business_type
  )
  VALUES (
    NEW.id, 
    NEW.raw_user_meta_data ->> 'full_name',
    COALESCE((NEW.raw_user_meta_data ->> 'user_type')::user_type, 'personal'),
    NEW.raw_user_meta_data ->> 'business_name',
    NEW.raw_user_meta_data ->> 'business_type'
  );
  RETURN NEW;
END;
$function$;