module GildedRose
  class Item
    attr_reader :quality, :days_remaining

    def initialize(quality, days_remaining)
      @quality, @days_remaining = quality, days_remaining
    end

    def tick
    end
  end

  class Normal < Item
    def tick
      @days_remaining -= 1
      return if @quality == 0

      @quality -= 1
      @quality -= 1 if @days_remaining <= 0
    end
  end

  class Brie < Item
    def tick
      @days_remaining -= 1
      return if @quality >= 50

      @quality += 1
      return if @quality == 50
      @quality += 1 if @days_remaining <= 0
    end
  end

  class Backstage < Item
    def tick
      @days_remaining -= 1
      return if @quality >= 50
      return @quality = 0 if @days_remaining < 0

      @quality += 1
      @quality += 1 if @days_remaining < 10
      @quality += 1 if @days_remaining < 5
    end
  end

  class Conjured < Item
    def tick
      @days_remaining -= 1
      return if @quality == 0

      @quality -= 2
      @quality -= 2 if @days_remaining <= 0
    end
  end

  DEFAULT_CLASS = Item
  SPECIALIZED_CLASSES = {
    'normal' => Normal,
    'Aged Brie' => Brie,
    'Backstage passes to a TAFKAL80ETC concert' => Backstage,
    'Conjured Mana Cake' => Conjured
  }

  def self.for(name, days_remaining, quality)
    (SPECIALIZED_CLASSES[name] || DEFAULT_CLASS).
      new(quality, days_remaining)
  end

end

def update_quality(items)
  items.each do |item|
    gr = GildedRose.for(item.name, item.sell_in, item.quality)
    gr.tick
    item.quality = gr.quality
    item.sell_in = gr.days_remaining
  end
end

## DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

## We use the setup in the spec rather than the following for testing.
##
## Items = [
##   Item.new("+5 Dexterity Vest", 10, 20),
##   Item.new("Aged Brie", 2, 0),
##   Item.new("Elixir of the Mongoose", 5, 7),
##   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
##   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
##   Item.new("Conjured Mana Cake", 3, 6),
## ]

