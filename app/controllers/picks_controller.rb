class PicksController < ApplicationController
  def public

    @pick = Pick.where(public_lock: true).last

    return redirect_to "/admin" if !@pick

    @season = @pick.game.week.season

    if params[:sport]
      sport = Sport.find_by_slug(params[:sport])
      if sport && params[:year]
        season = sport.seasons.find_by_year(params[:year])
        if season && params[:week]
          week = season.weeks.find_by_position(params[:week])
          if week && week.public_pick
            @pick = week.public_pick
          end
        end
      end
    end

    @season = @pick.game.week.season
    @seasons_picks = @season.picks.where(public_lock: true)
    @game = @pick.game
    @last_three = @pick.previous_three
  end
end
