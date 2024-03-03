# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveView.Studio.Repo.insert!(%LiveView.Studio.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LiveView.Studio.Repo
alias LiveView.Studio.Boats.Boat
alias LiveView.Studio.Stores.Store
alias LiveView.Studio.Flights.Flight
alias LiveView.Studio.GitRepos.GitRepo
alias LiveView.Studio.Servers.Server
alias LiveView.Studio.Donations.Donation
alias LiveView.Studio.Vehicles.Vehicle
alias LiveView.Studio.PizzaOrders.PizzaOrder
alias LiveView.Studio.Incidents.Incident
alias LiveView.Studio.Geo

## Vehicles

for _i <- 1..400 do
  %Vehicle{
    make: Faker.Vehicle.make(),
    model: Faker.Vehicle.model(),
    color: Faker.Color.name()
  }
  |> Repo.insert!()
end

## Boats

%Boat{
  model: "1760 Retriever Jon Deluxe",
  price: "$",
  type: "fishing",
  image: "/images/boats/1760-retriever-jon-deluxe.jpg"
}
|> Repo.insert!()

%Boat{
  model: "1650 Super Hawk",
  price: "$",
  type: "fishing",
  image: "/images/boats/1650-super-hawk.jpg"
}
|> Repo.insert!()

%Boat{
  model: "1850 Super Hawk",
  price: "$$",
  type: "fishing",
  image: "/images/boats/1850-super-hawk.jpg"
}
|> Repo.insert!()

%Boat{
  model: "1950 Super Hawk",
  price: "$$",
  type: "fishing",
  image: "/images/boats/1950-super-hawk.jpg"
}
|> Repo.insert!()

%Boat{
  model: "2050 Authority",
  price: "$$$",
  type: "fishing",
  image: "/images/boats/2050-authority.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Deep Sea Elite",
  price: "$$$",
  type: "fishing",
  image: "/images/boats/deep-sea-elite.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Beneteau First 14",
  price: "$$",
  type: "sailing",
  image: "/images/boats/beneteau-first-14.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Beneteau First 24",
  price: "$$$",
  type: "sailing",
  image: "/images/boats/beneteau-first-24.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Beneteau Oceanis 31",
  price: "$$$",
  type: "sailing",
  image: "/images/boats/beneteau-oceanis-31.jpg"
}
|> Repo.insert!()

%Boat{
  model: "RS Quest",
  price: "$",
  type: "sailing",
  image: "/images/boats/rs-quest.jpg"
}
|> Repo.insert!()

%Boat{
  model: "RS Feva",
  price: "$",
  type: "sailing",
  image: "/images/boats/rs-feva.jpg"
}
|> Repo.insert!()

%Boat{
  model: "RS Cat 16",
  price: "$$",
  type: "sailing",
  image: "/images/boats/rs-cat-16.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Yamaha SX190",
  price: "$",
  type: "sporting",
  image: "/images/boats/yamaha-sx190.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Yamaha 212X",
  price: "$$",
  type: "sporting",
  image: "/images/boats/yamaha-212x.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Glastron GT180",
  price: "$",
  type: "sporting",
  image: "/images/boats/glastron-gt180.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Glastron GT225",
  price: "$$",
  type: "sporting",
  image: "/images/boats/glastron-gt225.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Yamaha 275E",
  price: "$$$",
  type: "sporting",
  image: "/images/boats/yamaha-275e.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Yamaha 275SD",
  price: "$$$",
  type: "sporting",
  image: "/images/boats/yamaha-275sd.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Sunset Sail",
  price: "$$$$",
  type: "sailing",
  image: "/images/boats/sail-in-sunset.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Motor Boat",
  price: "$$$$",
  type: "sporting",
  image: "/images/boats/motor-boat-impressive-navigation-37924770.jpg"
}
|> Repo.insert!()

%Boat{
  model: "Marine Max",
  price: "$$$$",
  type: "fishing",
  image: "/images/boats/marine-max.jpg"
}
|> Repo.insert!()

## Stores

%Store{
  name: "Downtown Helena",
  street: "312 Montana Avenue",
  phone_number: "406-555-0100",
  city: "Helena, MT",
  zip: "59602",
  open: true,
  hours: "8am - 10pm M-F"
}
|> Repo.insert!()

%Store{
  name: "East Helena",
  street: "227 Miner's Lane",
  phone_number: "406-555-0120",
  city: "Helena, MT",
  zip: "59602",
  open: false,
  hours: "8am - 10pm M-F"
}
|> Repo.insert!()

%Store{
  name: "Westside Helena",
  street: "734 Lake Loop",
  phone_number: "406-555-0130",
  city: "Helena, MT",
  zip: "59602",
  open: true,
  hours: "8am - 10pm M-F"
}
|> Repo.insert!()

%Store{
  name: "Downtown Denver",
  street: "426 Aspen Loop",
  phone_number: "303-555-0140",
  city: "Denver, CO",
  zip: "80204",
  open: true,
  hours: "8am - 10pm M-F"
}
|> Repo.insert!()

%Store{
  name: "Midtown Denver",
  street: "7 Broncos Parkway",
  phone_number: "720-555-0150",
  city: "Denver, CO",
  zip: "80204",
  open: false,
  hours: "8am - 10pm M-F"
}
|> Repo.insert!()

%Store{
  name: "Denver Stapleton",
  street: "965 Summit Peak",
  phone_number: "303-555-0160",
  city: "Denver, CO",
  zip: "80204",
  open: true,
  hours: "8am - 10pm M-F"
}
|> Repo.insert!()

%Store{
  name: "Denver West",
  street: "501 Mountain Lane",
  phone_number: "720-555-0170",
  city: "Denver, CO",
  zip: "80204",
  open: true,
  hours: "8am - 10pm M-F"
}
|> Repo.insert!()

## Flights

%Flight{
  number: "450",
  origin: "DEN",
  destination: "ORD",
  departure_time: Timex.shift(Timex.now(), days: 1),
  arrival_time: Timex.shift(Timex.now(), days: 1, hours: 2)
}
|> Repo.insert!()

%Flight{
  number: "450",
  origin: "DEN",
  destination: "ORD",
  departure_time: Timex.shift(Timex.now(), days: 2),
  arrival_time: Timex.shift(Timex.now(), days: 2, hours: 2)
}
|> Repo.insert!()

%Flight{
  number: "450",
  origin: "DEN",
  destination: "ORD",
  departure_time: Timex.shift(Timex.now(), days: 3),
  arrival_time: Timex.shift(Timex.now(), days: 3, hours: 2)
}
|> Repo.insert!()

%Flight{
  number: "450",
  origin: "DEN",
  destination: "ORD",
  departure_time: Timex.shift(Timex.now(), days: 4),
  arrival_time: Timex.shift(Timex.now(), days: 4, hours: 2)
}
|> Repo.insert!()

%Flight{
  number: "860",
  origin: "DFW",
  destination: "ORD",
  departure_time: Timex.shift(Timex.now(), days: 1),
  arrival_time: Timex.shift(Timex.now(), days: 1, hours: 3)
}
|> Repo.insert!()

%Flight{
  number: "860",
  origin: "DFW",
  destination: "ORD",
  departure_time: Timex.shift(Timex.now(), days: 2),
  arrival_time: Timex.shift(Timex.now(), days: 2, hours: 3)
}
|> Repo.insert!()

%Flight{
  number: "860",
  origin: "DFW",
  destination: "ORD",
  departure_time: Timex.shift(Timex.now(), days: 3),
  arrival_time: Timex.shift(Timex.now(), days: 3, hours: 3)
}
|> Repo.insert!()

%Flight{
  number: "740",
  origin: "DAB",
  destination: "DEN",
  departure_time: Timex.shift(Timex.now(), days: 1),
  arrival_time: Timex.shift(Timex.now(), days: 1, hours: 4)
}
|> Repo.insert!()

%Flight{
  number: "740",
  origin: "DAB",
  destination: "DEN",
  departure_time: Timex.shift(Timex.now(), days: 2),
  arrival_time: Timex.shift(Timex.now(), days: 2, hours: 4)
}
|> Repo.insert!()

%Flight{
  number: "740",
  origin: "DAB",
  destination: "DEN",
  departure_time: Timex.shift(Timex.now(), days: 3),
  arrival_time: Timex.shift(Timex.now(), days: 3, hours: 4)
}
|> Repo.insert!()

## GitRepos

%GitRepo{
  name: "elixir",
  url: "https://github.com/elixir-lang/elixir",
  owner_login: "elixir-lang",
  owner_url: "https://github.com/elixir-lang",
  fork: false,
  stars: 16900,
  language: "elixir",
  license: "apache"
}
|> Repo.insert!()

%GitRepo{
  name: "phoenix",
  url: "https://github.com/phoenixframework/phoenix",
  owner_login: "phoenixframework",
  owner_url: "https://github.com/phoenixframework",
  fork: false,
  stars: 15200,
  language: "elixir",
  license: "mit"
}
|> Repo.insert!()

%GitRepo{
  name: "phoenix_live_view",
  url: "https://github.com/phoenixframework/phoenix_live_view",
  owner_login: "phoenixframework",
  owner_url: "https://github.com/phoenixframework",
  fork: false,
  stars: 3000,
  language: "elixir",
  license: "mit"
}
|> Repo.insert!()

%GitRepo{
  name: "phoenix_live_view",
  url: "https://github.com/clarkware/phoenix_live_view",
  owner_login: "clarkware",
  owner_url: "https://github.com/clarkware",
  fork: true,
  stars: 0,
  language: "elixir",
  license: "mit"
}
|> Repo.insert!()

%GitRepo{
  name: "rails",
  url: "https://github.com/rails/rails",
  owner_login: "rails",
  owner_url: "https://github.com/rails",
  fork: false,
  stars: 45600,
  language: "ruby",
  license: "mit"
}
|> Repo.insert!()

%GitRepo{
  name: "ruby",
  url: "https://github.com/ruby/ruby",
  owner_login: "ruby",
  owner_url: "https://github.com/ruby",
  fork: false,
  stars: 16800,
  language: "ruby",
  license: "bsdl"
}
|> Repo.insert!()

%GitRepo{
  name: "Web-Dev-For-Beginners",
  url: "https://github.com/microsoft/Web-Dev-For-Beginners",
  owner_login: "microsoft",
  owner_url: "https://github.com/microsoft",
  fork: true,
  stars: 66700,
  language: "js",
  license: "MIT"
}
|> Repo.insert!()

%GitRepo{
  name: "perl5",
  url: "https://github.com/Perl/perl5",
  owner_login: "Perl",
  owner_url: "https://github.com/Perl",
  fork: true,
  stars: 1600,
  language: "perl",
  license: "MIT"
}
|> Repo.insert!()

%GitRepo{
  name: "cpython",
  url: "https://github.com/python/cpython",
  owner_login: "python",
  owner_url: "https://github.com/python",
  fork: true,
  stars: 50800,
  language: "python",
  license: "MIT"
}
|> Repo.insert!()

%GitRepo{
  name: "live_view_studio",
  url: "https://github.com/RaymondLoranger/live_view_studio",
  owner_login: "RaymondLoranger",
  owner_url: "https://github.com/RaymondLoranger",
  fork: false,
  stars: 0,
  language: "elixir",
  license: "MIT"
}
|> Repo.insert!()

## Servers

%Server{
  name: "dancing-lizard",
  status: "up",
  deploy_count: 14,
  size: 19.5,
  framework: "Elixir/Phoenix",
  git_repo: "https://git.example.com/dancing-lizard.git",
  last_commit_id: "f3d41f7",
  last_commit_message: "If this works, I'm going disco dancing. 🦎"
}
|> Repo.insert!()

%Server{
  name: "lively-frog",
  status: "up",
  deploy_count: 12,
  size: 24.0,
  framework: "Elixir/Phoenix",
  git_repo: "https://git.example.com/lively-frog.git",
  last_commit_id: "d2eba26",
  last_commit_message: "Hopping on this rocket ship! 🚀"
}
|> Repo.insert!()

%Server{
  name: "curious-raven",
  status: "up",
  deploy_count: 21,
  size: 17.25,
  framework: "Ruby/Rails",
  git_repo: "https://git.example.com/curious-raven.git",
  last_commit_id: "a3708f1",
  last_commit_message: "Fixed a bug! 🐞"
}
|> Repo.insert!()

%Server{
  name: "cryptic-owl",
  status: "down",
  deploy_count: 2,
  size: 5.0,
  framework: "Elixir/Phoenix",
  git_repo: "https://git.example.com/cryptic-owl.git",
  last_commit_id: "c497e91",
  last_commit_message: "Woot! First big launch! 🤞"
}
|> Repo.insert!()

## Donations

donation_items = [
  {"☕️", "Coffee"},
  {"🥛", "Milk"},
  {"🥩", "Beef"},
  {"🍗", "Chicken"},
  {"🍖", "Pork"},
  {"🍗", "Turkey"},
  {"🥔", "Potatoes"},
  {"🥣", "Cereal"},
  {"🥣", "Oatmeal"},
  {"🥚", "Eggs"},
  {"🥓", "Bacon"},
  {"🧀", "Cheese"},
  {"🥬", "Lettuce"},
  {"🥒", "Cucumber"},
  {"🐠", "Smoked Salmon"},
  {"🐟", "Tuna"},
  {"🐡", "Halibut"},
  {"🥦", "Broccoli"},
  {"🧅", "Onions"},
  {"🍊", "Oranges"},
  {"🍯", "Honey"},
  {"🍞", "Sourdough Bread"},
  {"🥖", "French Bread"},
  {"🍐", "Pear"},
  {"🥜", "Nuts"},
  {"🍎", "Apples"},
  {"🥥", "Coconut"},
  {"🧈", "Butter"},
  {"🧀", "Mozzarella"},
  {"🍅", "Tomatoes"},
  {"🍄", "Mushrooms"},
  {"🍚", "Rice"},
  {"🍜", "Pasta"},
  {"🍌", "Banana"},
  {"🥕", "Carrots"},
  {"🍋", "Lemons"},
  {"🍉", "Watermelons"},
  {"🍇", "Grapes"},
  {"🍓", "Strawberries"},
  {"🍈", "Melons"},
  {"🍒", "Cherries"},
  {"🍑", "Peaches"},
  {"🍍", "Pineapples"},
  {"🥝", "Kiwis"},
  {"🍆", "Eggplants"},
  {"🥑", "Avocados"},
  {"🌶", "Peppers"},
  {"🌽", "Corn"},
  {"🍠", "Sweet Potatoes"},
  {"🥯", "Bagels"},
  {"🥫", "Soup"},
  {"🍪", "Cookies"}
]

for _i <- 1..100 do
  {emoji, item} = Enum.random(donation_items)

  %Donation{
    emoji: emoji,
    item: item,
    quantity: Enum.random(1..20),
    days_until_expires: Enum.random(1..30)
  }
  |> Repo.insert!()
end

## Pizza Orders

pizza_toppings = [
  "🍗 Chicken",
  "🌿 Basil",
  "🧄 Garlic",
  "🥓 Bacon",
  "🧀 Cheese",
  "🐠 Salmon",
  "🍤 Shrimp",
  "🥦 Broccoli",
  "🧅 Onions",
  "🍅 Tomatoes",
  "🍄 Mushrooms",
  "🍍 Pineapples",
  "🍆 Eggplants",
  "🥑 Avocados",
  "🌶 Peppers",
  "🍕 Pepperonis"
]

for _i <- 1..200 do
  [topping1, topping2] = pizza_toppings |> Enum.shuffle() |> Enum.take(2)

  pizza =
    "#{Faker.Pizza.size()} #{Faker.Pizza.style()} " <>
      "with #{topping1} and #{topping2}"

  %PizzaOrder{username: Faker.Internet.user_name(), pizza: pizza}
  |> Repo.insert!()
end

## Mapped Incidents

incident_descriptions = [
  "🦊 Fox in the henhouse",
  "🏢 Stuck in an elevator",
  "🚦 Traffic lights out",
  "🏎 Reckless driving",
  "🐻 Bear in the trash",
  "🤡 Disturbing the peace",
  "🔥 BBQ fire",
  "🙀 Cat stuck in a tree",
  "🐶 Dog on the loose"
]

for description <- incident_descriptions do
  # {lat, lng} = Geo.randomDenverLatLng()
  {lat, lng} = Geo.randomMontrealLatLng()

  %Incident{
    description: description,
    lat: lat,
    lng: lng
  }
  |> Repo.insert!()
end
