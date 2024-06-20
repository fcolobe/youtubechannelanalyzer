#' Calculate Q1 and Mean Indices
#'
#' This function calculates the indices of the first quartile (Q1) and the mean of a numeric vector.
#'
#' @param x A numeric vector.
#' @return A named list containing the indices of the first quartile (Q1) and the mean.
#' @examples
#' calculate_q1_mean_indices(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10))
#' @export
calculate_q1_mean_indices <- function(x) {
    ordered_x <- sort(x)
    q1_val <- stats::quantile(ordered_x, 0.25)
    mean_val <- mean(ordered_x)
    
    q1_index <- which.min(abs(ordered_x - q1_val))
    mean_index <- which.min(abs(ordered_x - mean_val))
    return(list(q1_index = q1_index, mean_index = mean_index))
}

# Example usage of the function
# indices <- calculate_q1_mean_indices(youtube_channel_stats[["subscribers"]])
# print(indices$q1_index)
# print(indices$mean_index)
