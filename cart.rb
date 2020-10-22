class Rules
  def initialize
    @item_rules = {}
    @overall_discount_rules = {}  
  end

  # rules modifier

  def add_item_rule(product_name, price, rules_param = [])
    if @item_rules[product_name].nil? 
      @item_rules[product_name] = {}
    end
    @item_rules[product_name][:price] = price
    @item_rules[product_name][:rules] = []
    return if rules_param.empty?
    # sort rules by limit priority
    @item_rules[product_name][:rules] = rules_param.sort{|a, b| a[:limit] > b[:limit]}
  end

  def add_overall_rule(rules_param = [])
    @overall_discount_rules = rules_param.sort{|a, b| a[:limit] > b[:limit] }
  end

  # calculator

  def calc_item_amount(product_name, purchase_count)
    item_amount = @item_rules[product_name][:price] * purchase_count

    @item_rules[product_name][:rules].each do |rule|
      if purchase_count >= rule[:limit]
        item_amount -= rule[:amount]
        return item_amount
      end
    end
    
    item_amount
  end

  def overall_discount(purchase_amount)
    @overall_discount_rules.each do |rule|
      if purchase_amount > rule[:limit]
        return rule[:amount]
      end
    end
    return 0
  end
end

class Checkout
  def initialize(rules)
    @rules = rules
    @cart = []
  end

  def scan(product)
    @cart.push(product)
  end

  def cart_data
    return @cart.join(",")
  end

  def total
    total_amount = 0
    @cart.tally.each {|item, count|
      total_amount += @rules.calc_item_amount(item, count)
    }
    
    total_amount -= @rules.overall_discount(total_amount)
    total_amount
  end
end


# ========================================================================
# Solution test code
# ========================================================================

# define rules
rules = Rules.new
rules.add_item_rule("A", 30, [ {"limit": 3, "amount": 15} ])
rules.add_item_rule("B", 20, [ {"limit": 2, "amount": 5} ])
rules.add_item_rule("C", 50)
rules.add_item_rule("D", 15)
rules.add_overall_rule([ {"limit": 150, "amount": 20} ])

# Test
co = Checkout.new(rules)
co.scan("C")
co.scan("B")
co.scan("A")
puts "#{co.cart_data}: #{co.total}"

co2 = Checkout.new(rules)
co2.scan("B")
co2.scan("A")
co2.scan("B")
co2.scan("A")
co2.scan("A")
puts "#{co2.cart_data}: #{co2.total}"

co1 = Checkout.new(rules)
co1.scan("C")
co1.scan("B")
co1.scan("A")
co1.scan("A")
co1.scan("D")
co1.scan("A")
co1.scan("B")
puts "#{co1.cart_data}: #{co1.total}"

co3 = Checkout.new(rules)
co3.scan("C")
co3.scan("A")
co3.scan("D")
co3.scan("A")
co3.scan("A")
puts "#{co3.cart_data}: #{co3.total}"
