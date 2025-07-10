package com.bookmymovies.util;

public class InputValidator {

    public static boolean isValidInput(String input, int maxLength, boolean numericOnly) {
        // Null or blank check
        if (input == null || input.trim().isEmpty()) {
            return false;
        }

        // Length check
        if (input.length() > maxLength) {
            return false;
        }

        // Type check: numeric only
        if (numericOnly && !input.matches("\\d+")) {
            return false;
        }

        // Basic security check (sanitize)
        if (containsSuspiciousCharacters(input)) {
            return false;
        }

        return true;
    }


        public static boolean isValidInput(String input) {
        // Null or blank check
        if (input == null || input.trim().isEmpty()) {
            return false;
        }


        // Basic security check (sanitize)
        if (containsSuspiciousCharacters(input)) {
            return false;
        }

        return true;
    }
    private static boolean containsSuspiciousCharacters(String input) {
        // Check for common SQL/script injection characters
        String lowerInput = input.toLowerCase();
        return input.contains("'") ||
               input.contains("\"") ||
               input.contains(";") ||
               lowerInput.contains(" or ") ||
               lowerInput.contains(" and ") ||
               lowerInput.contains("<script>") ||
               lowerInput.contains("select ") ||
               lowerInput.contains("drop ") ||
               lowerInput.contains("--");
    }
}