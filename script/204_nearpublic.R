# Loop through rows where 'dist_to_haltst is NA
for(i in 1:nrow(data)) {
  if(is.na(data$dist_to_haltst[i])) {
    origin_lat <- data$lat[i]
    origin_lng <- data$lon[i]
  
    # Find the nearest place
    location <- find_nearest(origin_lat, origin_lng, api_key, "transit_station")
    
    # Check if a school was found
    if(!is.null(location)) {
      # Format for Distance Matrix API
      origin <- paste(origin_lat, origin_lng, sep = ",")
      destination <- paste(location[1], location[2], sep = ",")
      
      # Calculate distance
      distance <- calculate_distance(origin, destination, api_key)
      
      # Update 'dist_to_school_1' in data
      if(!is.null(distance)) {
        data$dist_to_haltst[i] <- distance
      }
    }
  }
}
sum(is.na(data$dist_to_haltst))


imputed_haltst <- mice(data[, c("dist_to_haltst", "Micro_rating_Accessibility")], method = 'pmm', m = 5, maxit = 5)
completed_haltst <- complete(imputed_haltst)
# Check results 
summary(data$dist_to_haltst)
summary(completed_haltst$dist_to_haltst)
data$dist_to_haltst <- completed_haltst$dist_to_haltst



