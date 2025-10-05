-- Create restaurants table
CREATE TABLE public.restaurants (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  image_url TEXT,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  cuisine_type TEXT,
  rating DECIMAL(2,1) DEFAULT 4.0,
  distance_km DECIMAL(4,2),
  phone TEXT,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create deals table
CREATE TABLE public.deals (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  original_price DECIMAL(8,2) NOT NULL,
  sale_price DECIMAL(8,2) NOT NULL,
  pickup_start TIME NOT NULL,
  pickup_end TIME NOT NULL,
  items_available INTEGER NOT NULL DEFAULT 0,
  items_total INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create reservations table
CREATE TABLE public.reservations (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  deal_id UUID NOT NULL REFERENCES public.deals(id) ON DELETE CASCADE,
  pickup_time TIME NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  quantity INTEGER NOT NULL DEFAULT 1,
  total_price DECIMAL(8,2) NOT NULL,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create favorites table
CREATE TABLE public.favorites (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  restaurant_id UUID NOT NULL REFERENCES public.restaurants(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, restaurant_id)
);

-- Enable Row Level Security
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;

-- RLS Policies for restaurants (public read access)
CREATE POLICY "Restaurants are viewable by everyone" 
ON public.restaurants 
FOR SELECT 
USING (true);

-- RLS Policies for deals (public read access)
CREATE POLICY "Deals are viewable by everyone" 
ON public.deals 
FOR SELECT 
USING (true);

-- RLS Policies for reservations (user-specific)
CREATE POLICY "Users can view their own reservations" 
ON public.reservations 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own reservations" 
ON public.reservations 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reservations" 
ON public.reservations 
FOR UPDATE 
USING (auth.uid() = user_id);

-- RLS Policies for favorites (user-specific)
CREATE POLICY "Users can view their own favorites" 
ON public.favorites 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own favorites" 
ON public.favorites 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own favorites" 
ON public.favorites 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create triggers for timestamp updates
CREATE TRIGGER update_restaurants_updated_at
BEFORE UPDATE ON public.restaurants
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_deals_updated_at
BEFORE UPDATE ON public.deals
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_reservations_updated_at
BEFORE UPDATE ON public.reservations
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Insert sample restaurants
INSERT INTO public.restaurants (name, image_url, address, city, cuisine_type, rating, distance_km, phone, description) VALUES
('Green Leaf Bistro', '/placeholder.svg', '123 Main St', 'Downtown', 'Vegetarian', 4.5, 0.8, '+1-555-0123', 'Fresh organic vegetarian cuisine with a focus on sustainability'),
('Ocean View Sushi', '/placeholder.svg', '456 Harbor Blvd', 'Marina District', 'Japanese', 4.7, 1.2, '+1-555-0124', 'Premium sushi and Japanese dishes with ocean-fresh ingredients'),
('Mamma Mia Pizzeria', '/placeholder.svg', '789 Little Italy Ave', 'Little Italy', 'Italian', 4.3, 2.1, '+1-555-0125', 'Authentic wood-fired pizzas and traditional Italian pasta'),
('Spice Route', '/placeholder.svg', '321 Curry Lane', 'Spice Quarter', 'Indian', 4.6, 1.5, '+1-555-0126', 'Aromatic Indian curries and tandoor specialties'),
('Le Petit Café', '/placeholder.svg', '654 French St', 'Art District', 'French', 4.4, 0.9, '+1-555-0127', 'Charming French café with pastries, crepes, and bistro classics');

-- Insert sample deals
INSERT INTO public.deals (restaurant_id, title, description, original_price, sale_price, pickup_start, pickup_end, items_available, items_total) VALUES
((SELECT id FROM public.restaurants WHERE name = 'Green Leaf Bistro'), 'Veggie Bowl Surprise', 'Mixed seasonal vegetables with quinoa and tahini dressing', 15.99, 5.99, '17:00', '19:00', 8, 10),
((SELECT id FROM public.restaurants WHERE name = 'Ocean View Sushi'), 'Sushi Combo Deal', 'Assorted fresh sushi rolls and miso soup', 28.99, 9.99, '18:30', '20:30', 5, 8),
((SELECT id FROM public.restaurants WHERE name = 'Mamma Mia Pizzeria'), 'Pizza & Pasta Special', 'Large pizza slice and pasta portion', 22.50, 7.50, '16:00', '18:00', 12, 15),
((SELECT id FROM public.restaurants WHERE name = 'Spice Route'), 'Curry Night Box', 'Chicken curry, rice, naan, and dessert', 19.99, 6.99, '17:30', '19:30', 6, 10),
((SELECT id FROM public.restaurants WHERE name = 'Le Petit Café'), 'French Bakery Box', 'Assorted pastries, croissants, and coffee', 16.50, 5.50, '15:00', '17:00', 10, 12);