# original implementation

class Pet
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end
end

class Owner
  attr_reader :name
  attr_accessor :number_of_pets

  def initialize(name)
    @name = name
    @number_of_pets = 0
  end
end

class Shelter
  def initialize
    @adoptions = {}
  end

  def adopt(owner, pet)
    owner.number_of_pets += 1
    update_database(owner, pet)
  end

  def print_adoptions
    @adoptions.each do |owner, pets|
      puts "#{owner} has adopted the following pets:"
      pets.each { |pet| puts "a #{pet.type} named #{pet.name}"}
      puts
    end
  end

  private

  def update_database(owner, pet)
    if @adoptions[owner.name]
      @adoptions[owner.name] << pet
    else
      @adoptions[owner.name] = [pet]
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."


#######################################################################
# Further Exploration

class Pet
  attr_reader :animal, :name

  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def to_s
    "a #{animal} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(pet)
    @pets << pet
  end

  def number_of_pets
    pets.size
  end

  def print_pets
    pets.each { |pet| puts pet }
  end
end

class Shelter
  attr_reader :unadopted_pets

  def initialize
    @owners = {}
    @unadopted_pets = []
  end

  def rescue_pet(pet)
    @unadopted_pets << pet
  end

  def adopt(owner, pet)
    @unadopted_pets.delete(pet)
    owner.add_pet(pet)
    @owners[owner.name] ||= owner
  end

  def print_adoptions
    @owners.each_pair do |name, owner|
      puts "#{name} has adopted the following pets:"
      owner.print_pets
      puts
    end
  end

  def print_unadopted_pets
    puts "The Animal Shelter has the following unadopted pets:"
    @unadopted_pets.each { |pet| puts pet }
    puts
  end
end


butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
huey         = Pet.new('dog', 'Huey')
lacey        = Pet.new('dog', 'Lacey')
asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluffy       = Pet.new('cat', 'Fluffy')
kat          = Pet.new('cat', 'Kat')
ben          = Pet.new('cat', 'Ben')
chatterbox   = Pet.new('parakeet', 'Chatterbox')
bluebell     = Pet.new('parakeet', 'Bluebell')

phanson  = Owner.new('P Hanson')
bholmes  = Owner.new('B Holmes')
scunnane = Owner.new('S Cunnane')

shelter = Shelter.new
shelter.rescue_pet(butterscotch)
shelter.rescue_pet(pudding)
shelter.rescue_pet(darwin)
shelter.rescue_pet(kennedy)
shelter.rescue_pet(sweetie)
shelter.rescue_pet(molly)
shelter.rescue_pet(chester)
shelter.rescue_pet(huey)
shelter.rescue_pet(lacey)
shelter.rescue_pet(asta)
shelter.rescue_pet(laddie)
shelter.rescue_pet(fluffy)
shelter.rescue_pet(kat)
shelter.rescue_pet(ben)
shelter.rescue_pet(chatterbox)
shelter.rescue_pet(bluebell)
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.adopt(scunnane, huey)
shelter.adopt(scunnane, lacey)
shelter.print_adoptions
shelter.print_unadopted_pets

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "#{scunnane.name} has #{scunnane.number_of_pets} adopted pets."
puts "The Animal shelter has #{shelter.unadopted_pets.size} unadopted pets."
