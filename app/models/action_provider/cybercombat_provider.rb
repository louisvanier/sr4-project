module ActionProvider
  class CybercombatProvider
    def actions
      return [] unless current_actor.programs.any? { |prog| prog.damage_type && prog.rating > 0 }

      # must include actions to attack, and actions to soak damage

      actions = []

      current_actor.nodes_present_in.each do |node|
        node.icons.each do |icon|
          next unless known_data_pieces[current_actor][icon][PerceptionData::ICON_TYPE] && icon.is_a?(CanCybercombat)
          current_actor.programs.each do |prog|
            next unless prog.damage_type
            actions << { icon => CybercombatProcess.get_attack_details(current_actor, icon, prog, false) }
          end
        end
      end

      actions
    end
  end
end
