def consolidate_cart(cart)
  # code here
  new_hash = {}
  cart.each do |item|
    item.each do |name, info|
      if new_hash.key?(name)
        new_hash[name][:count] += 1
      else
        new_hash[name] = info
        new_hash[name][:count] = 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  # code here
  discounted_hash = {}
  coupons.each do |coupon|
    discounted = coupon[:item]
    discounted_name = "#{discounted} W/COUPON"
    if discounted_hash.key?(discounted_name) && cart[discounted][:count] >= coupon[:num]
      discounted_hash[discounted_name][:count] += 1
      cart[discounted][:count] -= coupon[:num]
    elsif cart.key?(discounted) && cart[discounted][:count] >= coupon[:num]
      discounted_hash[discounted_name] = {}
      cart.each do |item, info|
        if item == discounted
          info[:count] -= coupon[:num]
          discounted_hash[discounted_name] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
  end
  discounted_hash.reject { |_item, info| info == {} }
  cart.merge(discounted_hash)
end

def apply_clearance(cart)
  cart.each do |_item, info|
    info[:price] = (info[:price].to_f * 0.80).round(1) if info[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = cart.map { |_item, info| info[:price] * info[:count] }.inject(:+)
  total = (total * 0.90).round(2) if total > 100
  total
end
