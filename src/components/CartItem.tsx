import { useState } from 'react';
import { Link } from 'react-router-dom';
import { Minus, Plus, Trash2 } from 'lucide-react';
import { CartItem as CartItemType } from '../utils/types';
import { useCart } from '../context/CartContext';
import { formatCurrency } from '../utils/formatters';

interface CartItemProps {
  item: CartItemType;
}

const CartItem = ({ item }: CartItemProps) => {
  const [isImageLoaded, setIsImageLoaded] = useState(false);
  const { updateQuantity, removeFromCart } = useCart();
  
  const isPastry = item.product.category === 'pastries';
  
  const handleQuantityChange = (newQuantity: number) => {
    if (newQuantity < (isPastry ? 0.25 : 1)) return;
    updateQuantity(item.product.id, newQuantity);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = parseFloat(e.target.value);
    if (!isNaN(value)) {
      updateQuantity(item.product.id, value);
    }
  };

  const itemTotal = item.product.price * item.quantity;

  return (
    <div className="flex items-start py-6 first:pt-0 border-b border-border last:border-b-0 animate-fade-in">
      {/* Product image */}
      <div className="relative h-24 w-24 rounded-md overflow-hidden bg-muted mr-4">
        {!isImageLoaded && (
          <div className="absolute inset-0 bg-muted animate-pulse" />
        )}
        <img
          src={item.product.image}
          alt={item.product.name}
          className={`object-cover h-full w-full ${isImageLoaded ? 'opacity-100' : 'opacity-0'}`}
          onLoad={() => setIsImageLoaded(true)}
        />
      </div>

      {/* Product details */}
      <div className="flex-1 min-w-0">
        <Link 
          to={`/product/${item.product.id}`}
          className="font-medium text-primary hover:text-primary/80 transition-colors"
        >
          {item.product.name}
        </Link>
        <p className="text-sm text-muted-foreground mt-1">{item.product.description}</p>
        
        <div className="flex flex-wrap items-center justify-between mt-3 gap-3">
          {/* Quantity controls */}
          <div className="flex items-center border border-input rounded-md">
            <button
              onClick={() => handleQuantityChange(
                isPastry 
                  ? Math.round((item.quantity - 0.25) * 100) / 100 
                  : item.quantity - 1
              )}
              className="p-1 hover:bg-muted transition-colors"
              aria-label="Decrease quantity"
              disabled={item.quantity <= (isPastry ? 0.25 : 1)}
            >
              <Minus className="h-4 w-4" />
            </button>
            <input
              type="number"
              min={isPastry ? "0.25" : "1"}
              step={isPastry ? "0.25" : "1"}
              value={item.quantity}
              onChange={handleInputChange}
              className="w-16 text-center text-sm font-medium py-1 border-0 focus:ring-0"
              aria-label="Quantity"
            />
            <button
              onClick={() => handleQuantityChange(
                isPastry 
                  ? Math.round((item.quantity + 0.25) * 100) / 100 
                  : item.quantity + 1
              )}
              className="p-1 hover:bg-muted transition-colors"
              aria-label="Increase quantity"
            >
              <Plus className="h-4 w-4" />
            </button>
          </div>

          {/* Price and remove */}
          <div className="flex items-center space-x-4">
            <span className="font-medium">{formatCurrency(itemTotal)}</span>
            <button
              onClick={() => removeFromCart(item.product.id)}
              className="text-muted-foreground hover:text-destructive transition-colors"
              aria-label="Remove item"
            >
              <Trash2 className="h-4 w-4" />
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CartItem;
