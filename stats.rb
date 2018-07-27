attackers=[
  {name: 'helverin', ws: 3, bs: 3, pts: 174, weapons: [
    {name: 'close combat', type: 'ws', dice: 4, s: 6, ap: 0, d: 1},
    {name: 'stubber', type: 'bs', dice: 3, s: 4, ap: 0, d: 1},
    {name: 'autocannon', type: 'bs', dice: '4d3', s: 7, ap: 1, d: 3},
  ]},
  {name: 'warglaive', ws: 3, bs: 3, pts: 164, weapons: [
    {name: 'reaper', type: 'ws', dice: 4, s: 12, ap: 3, d: 3},
    {name: 'reaper sweep', type: 'ws', dice: 8, s: 6, ap: 2, d: 1},
    {name: 'stubber', type: 'bs', dice: 3, s: 4, ap: 0, d: 1},
    {name: 'thremal spear', type: 'bs', dice: 'd3', s: 8, ap: 4, d: 'd6'},
  ]},
  {name: 'gallant', ws: 2, bs: 3, pts: 399, weapons: [
    {name: 'reaper', type: 'ws', dice: 5, s: 14, ap: 4, d: 6},
    {name: 'stomp', type: 'ws', dice: 15, s: 8, ap: 2, d: 'd3'},
    {name: 'stubber', type: 'bs', dice: 3, s: 4, ap: 0, d: 1},
    {name: 'stormspear', type: 'bs', dice: 3, s: 8, ap: 2, d: 'd6'},
  ]},
  {name: 'errant', ws: 3, bs: 3, pts: 395, weapons: [
    {name: 'reaper', type: 'ws', dice: 5, s: 14, ap: 4, d: 6},
    {name: 'stomp', type: 'ws', dice: 12, s: 8, ap: 2, d: 'd3'},
    {name: 'stubber', type: 'bs', dice: 3, s: 4, ap: 0, d: 1},
    {name: 'thermal', type: 'bs', dice: 'd6', s: 9, ap: 4, d: 'd6'},
  ]},
  {name: 'paladin', ws: 3, bs: 3, pts: 423, weapons: [
    {name: 'reaper', type: 'ws', dice: 5, s: 14, ap: 4, d: 6},
    {name: 'stomp', type: 'ws', dice: 12, s: 8, ap: 2, d: 'd3'},
    {name: 'stubber', type: 'bs', dice: 6, s: 4, ap: 0, d: 1},
    {name: 'battlecannon', type: 'bs', dice: '2d6', s: 8, ap: 2, d: 'd3'},
  ]},
  {name: 'warden', ws: 3, bs: 3, pts: 411, weapons: [
    {name: 'reaper', type: 'ws', dice: 5, s: 14, ap: 4, d: 6},
    {name: 'stomp', type: 'ws', dice: 15, s: 8, ap: 2, d: 'd3'},
    {name: 'stubber', type: 'bs', dice: 3, s: 4, ap: 0, d: 1},
    {name: 'avenger', type: 'bs', dice: 12, s: 6, ap: 2, d: 2},
    {name: 'hflamer', type: 'auto', dice: 'd6', s: 5, ap: 1, d: 1},
  ]},
  {name: 'crusader', ws: 3, bs: 3, pts: 485, weapons: [ #485 battle cannon, 457 thermal
    {name: 'stomp', type: 'ws', dice: 12, s: 8, ap: 2, d: 'd3'},
    {name: 'stubber', type: 'bs', dice: 3, s: 4, ap: 0, d: 1},
    # {name: 'thermal', type: 'bs', dice: 'd6', s: 9, ap: 4, d: 'd6'},
    {name: 'battlecannon', type: 'bs', dice: '2d6', s: 8, ap: 2, d: 'd3'},
    {name: 'avenger', type: 'bs', dice: 12, s: 6, ap: 2, d: 2},
    {name: 'hflamer', type: 'auto', dice: 'd6', s: 5, ap: 1, d: 1},
  ]},
  {name: 'castellan', ws: 4, bs: 3, pts: 604, weapons: [
    {name: 'stomp', type: 'ws', dice: 12, s: 8, ap: 2, d: 'd3'},
    {name: 'missle', type: 'bs', dice: 1, s: 10, ap: 4, d: 'd6'},
    {name: 'cannon', type: 'bs', dice: '4d3', s: 7, ap: 1, d: 'd3'},
    {name: 'plasma', type: 'bs', dice: '2d6', s: 8, ap: 3, d: 3},
    {name: 'volcano', type: 'bs', dice: 'd6', s: 14, ap: 5, d: '3d3'},
    {name: 'melta', type: 'bs', dice: 2, s: 8, ap: 4, d: 'd6'},
  ]},
]

defenders=[
  {name: 'geq', t: 3, w: 1, sv: 5},
  {name: 'meq', t: 4, w: 1, sv: 3},
  {name: 'req', t: 7, w: 10, sv: 3},
  {name: 'keq', t: 8, w: 24, sv: 3, inv: {val: 5, ws: false, bs: true}},
]

attackers = attackers.each{|attacker|replace_random(attacker)}

#well this is an ON3 party...
attackers.each do |attacker|
  puts "___________"
  puts "Calculating damge output for #{attacker[:name]}"
  total_wounds = 0
  defenders.each do |defender|
    defenders_wounds_taken = 0
    puts "versus #{defender[:name]}"
    close_combat_damage = []
    attacker[:weapons].each do |weapon|
      close_combat_damage << attack(weapon, attacker, defender) if weapon[:type] == 'ws'
      defenders_wounds_taken += attack(weapon, attacker, defender) if weapon[:type] == 'bs'
    end
    defenders_wounds_taken += close_combat_damage.max
    puts "Wounds against #{defender[:name]}: #{defenders_wounds_taken}"
    total_wounds += defenders_wounds_taken
  end
  puts "Total wounds: #{total_wounds}"
  puts "Efficiency: #{attacker[:pts]/(total_wounds/defenders.count)} points per wound per turn"
  puts ""
end 


BEGIN {
  def replace_random(attacker)
    attacker.each do |key, value|
      if value.is_a?(String) && (key == :dice || key == :d)
        attacker[key] = calculate_random(value)
      elsif value.is_a?(Hash) 
        replace_random value
      elsif value.is_a?(Array)  
        value.flatten.each { |x| replace_random(x) if x.is_a?(Hash) }
      end
    end
    attacker
  end

  def calculate_random(value)
    components = value.split('d')
    components[0] = 1 if components[0] == ""
    random_value = ((1..components[1].to_i).inject(:+) || 1) / components[1].to_f
    components[0].to_i * random_value
  end

  def attack(weapon, attacker, defender)
    wounds_from_weapon = 0
    # puts "Weapon: #{weapon[:name]}"
    hits = r_t_h(attacker, weapon, defender)
    # puts "Hits: #{hits}"
    wounds = r_t_w(hits, weapon, defender)
    # puts "Wounds: #{wounds}"
    unsaved = r_t_s(wounds, weapon, defender)
    # puts "Unsaved: #{unsaved}"
    damage = r_t_d(unsaved, weapon, defender)
    # puts "Damage: #{damage}"
    wounds_from_weapon += damage
    # puts "Weapon did #{wounds_from_weapon} wounds"
    wounds_from_weapon
  end


  def r_t_h(attacker, weapon, target)
    return weapon[:dice] if weapon[:type] == 'auto'
    weapon[:dice] * ((7 - attacker[weapon[:type].to_sym])/6.00)
  end

  def r_t_w(hits, weapon, target)
    hits * ((7 - w_chart(weapon[:s], target[:t]))/6.00)
  end

  def w_chart(s, t)
    if s >= t * 2
      return 2
    elsif s > t
      return 3
    elsif s == t
      return 4
    elsif t * 2 >= s
      return 6
    else
      return 5
    end 
  end

  def r_t_s(wounds, weapon, target)
    save = target[:sv] + weapon[:ap]
    save = save >= 7 ? 7 : save
    if (defined?(target[:inv])).nil? && target[:inv][weapon[:type].to_sym]
      save = save > target[:inv][:val] ? target[:inv][:val] : save
    end
    wounds - (wounds * (7-save)/6.00)
  end

  def r_t_d(unsaved, weapon, target)
    model_damage = weapon[:d] >= target[:w] ? target[:w] : weapon[:d]
    model_damage * unsaved
  end
}