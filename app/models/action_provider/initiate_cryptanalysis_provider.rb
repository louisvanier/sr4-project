module ActionProvider
  class InitiateCryptanalysis < BaseProvider
    def actions
      def initiate_cryptanalysis_actions
        return [] unless current_actor.get_program_rating(MatrixProgram::DECRYPT) > 0

        actions = []

        # encrypted node has to be decrypted first, so add all encrypted nodes

        # then add all encrypted icons on the node

        actions
      end
    end
  end
end
