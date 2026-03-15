package com.hagl.model;

import java.time.LocalDate;
import java.time.LocalTime;

public class Match {
    private int matchId;
    private String opponent; 
    private LocalDate matchDate;
    private LocalTime matchTime;
    private String stadiumName;
    private double maxPrice; 
    private double minPrice; 
    private String opponentImageName; 

    public Match() {}

    public Match(int matchId, String opponent, LocalDate matchDate, LocalTime matchTime, String stadiumName, double maxPrice, double minPrice) {
        this.matchId = matchId;
        this.opponent = opponent;
        this.matchDate = matchDate;
        this.matchTime = matchTime;
        this.stadiumName = stadiumName;
        this.maxPrice = maxPrice;
        this.minPrice = minPrice;
    }
    
    // Getters and Setters
    public int getMatchId() { return matchId; }
    public String getOpponent() { return opponent; }
    public LocalDate getMatchDate() { return matchDate; }
    public LocalTime getMatchTime() { return matchTime; }
    public String getStadiumName() { return stadiumName; }
    public double getMaxPrice() { return maxPrice; }
    public double getMinPrice() { return minPrice; }


    public String getOpponentImageName() {
        return opponentImageName;
    }

    public void setOpponentImageName(String opponentImageName) {
        this.opponentImageName = opponentImageName;
    }
}